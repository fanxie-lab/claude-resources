//
//  AlertMessage.swift
//  {{APP_NAME}}
//
//  Model for a modal alert presented via SwiftUI's native `.alert(...)` API.
//  Paired with `ErrorAlertModifier`. For a custom-styled alert (dimmed
//  background + card), see `{{APP_NAME}}Alert.swift` instead.
//

import Foundation
import SwiftUI

struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: AlertAction?
    let secondaryAction: AlertAction?

    struct AlertAction {
        let label: String
        let role: ButtonRole?
        let action: () -> Void

        init(label: String, role: ButtonRole? = nil, action: @escaping () -> Void = {}) {
            self.label = label
            self.role = role
            self.action = action
        }
    }

    init(
        title: String,
        message: String,
        primaryAction: AlertAction? = nil,
        secondaryAction: AlertAction? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    // MARK: - Convenience Initializers

    /// Builds an alert from an `{{APP_NAME}}Error`, wiring up retry if the error is retryable.
    static func from(_ error: {{APP_NAME}}Error, retry: (() -> Void)? = nil) -> AlertMessage {
        let title = error.errorDescription ?? String(localized: "alert.error.title", comment: "Default error alert title")
        let message = [error.failureReason, error.recoverySuggestion]
            .compactMap { $0 }
            .joined(separator: "\n\n")

        var primaryAction: AlertAction?
        var secondaryAction: AlertAction?

        if error.isRetryable, let retry = retry {
            primaryAction = AlertAction(label: String(localized: "button.retry", comment: "Retry action button"), action: retry)
            secondaryAction = AlertAction(label: String(localized: "button.cancel", comment: "Cancel action button"), role: .cancel)
        } else {
            primaryAction = AlertAction(label: String(localized: "button.ok", comment: "OK action button"), role: .cancel)
        }

        return AlertMessage(title: title, message: message, primaryAction: primaryAction, secondaryAction: secondaryAction)
    }

    static func confirmation(
        title: String,
        message: String,
        confirmLabel: String = String(localized: "button.confirm", comment: "Confirm action button"),
        cancelLabel: String = String(localized: "button.cancel", comment: "Cancel action button"),
        destructive: Bool = false,
        onConfirm: @escaping () -> Void
    ) -> AlertMessage {
        AlertMessage(
            title: title,
            message: message,
            primaryAction: AlertAction(label: confirmLabel, role: destructive ? .destructive : nil, action: onConfirm),
            secondaryAction: AlertAction(label: cancelLabel, role: .cancel)
        )
    }

    static func info(title: String, message: String) -> AlertMessage {
        AlertMessage(
            title: title,
            message: message,
            primaryAction: AlertAction(label: String(localized: "button.ok", comment: "OK action button"), role: .cancel)
        )
    }
}
