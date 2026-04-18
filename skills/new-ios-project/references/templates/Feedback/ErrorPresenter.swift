//
//  ErrorPresenter.swift
//  {{APP_NAME}}
//
//  Central manager that routes errors to the right UI surface:
//  - Critical errors → modal alert (via `AlertMessage` + `.errorAlert(...)`)
//  - Warnings / info → snackbar (non-blocking)
//
//  Inject via environment or ownership depending on scope. See CLAUDE.md for
//  the wiring convention.
//

import Foundation
import SwiftUI

@MainActor
class ErrorPresenter: ObservableObject {
    @Published var currentSnackbar: SnackbarMessage?
    @Published var currentAlert: AlertMessage?

    private var snackbarQueue: [SnackbarMessage] = []

    // MARK: - Error Presentation

    func present(
        _ error: {{APP_NAME}}Error,
        context: [String: String] = [:],
        retry: (() -> Void)? = nil
    ) {
        ErrorLogger.log(error, context: context)

        switch error.severity {
        case .critical:
            currentAlert = AlertMessage.from(error, retry: retry)
        case .warning, .info:
            showSnackbar(SnackbarMessage.from(error, retry: retry))
        }
    }

    func present(
        _ error: Error,
        context: [String: String] = [:],
        retry: (() -> Void)? = nil
    ) {
        present({{APP_NAME}}Error.from(error), context: context, retry: retry)
    }

    // MARK: - Snackbar Queue

    func showSnackbar(_ message: SnackbarMessage) {
        if currentSnackbar == nil {
            currentSnackbar = message
        } else {
            snackbarQueue.append(message)
        }
    }

    func dismissSnackbar() {
        currentSnackbar = nil
        if !snackbarQueue.isEmpty {
            Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                currentSnackbar = snackbarQueue.isEmpty ? nil : snackbarQueue.removeFirst()
            }
        }
    }

    // MARK: - Convenience

    func showSuccess(_ message: String, context: [String: String] = [:]) {
        ErrorLogger.logSuccess(SuccessMessage(message), context: context)
        showSnackbar(.success(message))
    }

    func showInfo(_ message: String) {
        showSnackbar(.info(message))
    }

    func showWarning(_ message: String) {
        showSnackbar(.warning(message))
    }

    // MARK: - Alert Helpers

    func showConfirmation(
        title: String,
        message: String,
        confirmLabel: String = String(localized: "button.confirm", comment: "Confirm action button"),
        cancelLabel: String = String(localized: "button.cancel", comment: "Cancel action button"),
        destructive: Bool = false,
        onConfirm: @escaping () -> Void
    ) {
        currentAlert = AlertMessage.confirmation(
            title: title,
            message: message,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            destructive: destructive,
            onConfirm: onConfirm
        )
    }

    func showAlert(title: String, message: String) {
        currentAlert = AlertMessage.info(title: title, message: message)
    }

    func dismissAlert() { currentAlert = nil }

    func clearAll() {
        currentSnackbar = nil
        currentAlert = nil
        snackbarQueue.removeAll()
    }
}

// MARK: - Typed conveniences

extension ErrorPresenter {
    func presentNetwork(_ error: NetworkError, url: String? = nil, operation: String? = nil, retry: (() -> Void)? = nil) {
        var context: [String: String] = [:]
        if let url { context["url"] = url }
        if let operation { context["operation"] = operation }
        present(.network(error), context: context, retry: retry)
    }

    func presentPersistence(_ error: PersistenceError, entity: String? = nil, operation: String? = nil, retry: (() -> Void)? = nil) {
        var context: [String: String] = [:]
        if let entity { context["entity"] = entity }
        if let operation { context["operation"] = operation }
        present(.persistence(error), context: context, retry: retry)
    }

    func presentValidation(_ error: ValidationError, field: String? = nil, value: String? = nil) {
        var context: [String: String] = [:]
        if let field { context["field"] = field }
        if let value { context["attemptedValue"] = value }
        present(.validation(error), context: context)
    }
}

// MARK: - Environment

struct ErrorPresenterKey: EnvironmentKey {
    @MainActor
    static let defaultValue = ErrorPresenter()
}

extension EnvironmentValues {
    var errorPresenter: ErrorPresenter {
        get { self[ErrorPresenterKey.self] }
        set { self[ErrorPresenterKey.self] = newValue }
    }
}
