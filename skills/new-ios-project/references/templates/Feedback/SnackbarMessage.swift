//
//  SnackbarMessage.swift
//  {{APP_NAME}}
//
//  Model for a toast/snackbar notification. Paired with `SnackbarView` and
//  `ErrorPresenter`.
//

import Foundation
import SwiftUI

struct SnackbarMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let type: MessageType
    let duration: TimeInterval
    let actionLabel: String?
    let action: (() -> Void)?

    enum MessageType {
        case success
        case error
        case warning
        case info

        var iconName: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error:   return "exclamationmark.octagon.fill"
            case .warning: return "exclamationmark.triangle"
            case .info:    return "info.circle"
            }
        }

        var color: Color {
            switch self {
            case .success: return .green
            case .error:   return .red
            case .warning: return .orange
            case .info:    return .blue
            }
        }
    }

    init(
        text: String,
        type: MessageType = .info,
        duration: TimeInterval = 4.0,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.type = type
        self.duration = duration
        self.actionLabel = actionLabel
        self.action = action
    }

    // MARK: - Convenience Initializers

    static func success(_ text: String, duration: TimeInterval = 3.0) -> SnackbarMessage {
        SnackbarMessage(text: text, type: .success, duration: duration)
    }

    static func error(_ text: String, duration: TimeInterval = 5.0, retry: (() -> Void)? = nil) -> SnackbarMessage {
        SnackbarMessage(
            text: text,
            type: .error,
            duration: duration,
            actionLabel: retry != nil ? String(localized: "button.retry", comment: "Retry action button") : nil,
            action: retry
        )
    }

    static func warning(_ text: String, duration: TimeInterval = 4.0) -> SnackbarMessage {
        SnackbarMessage(text: text, type: .warning, duration: duration)
    }

    static func info(_ text: String, duration: TimeInterval = 4.0) -> SnackbarMessage {
        SnackbarMessage(text: text, type: .info, duration: duration)
    }

    /// Creates a snackbar message from a {{APP_NAME}}Error.
    static func from(_ error: {{APP_NAME}}Error, retry: (() -> Void)? = nil) -> SnackbarMessage {
        let text = error.errorDescription ?? String(localized: "alert.error.generic", comment: "Generic error message")
        let messageType: MessageType
        switch error.severity {
        case .critical: messageType = .error
        case .warning:  messageType = .warning
        case .info:     messageType = .info
        }
        return SnackbarMessage(
            text: text,
            type: messageType,
            duration: 5.0,
            actionLabel: (retry != nil && error.isRetryable) ? String(localized: "button.retry", comment: "Retry action button") : nil,
            action: retry
        )
    }

    static func == (lhs: SnackbarMessage, rhs: SnackbarMessage) -> Bool {
        lhs.id == rhs.id
    }
}
