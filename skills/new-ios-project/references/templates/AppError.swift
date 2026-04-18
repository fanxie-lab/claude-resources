//
//  {{APP_NAME}}Error.swift
//  {{APP_NAME}}
//
//  Master error type that categorizes every surfaced error in the app.
//  Every throw site should produce (or be wrapped into) one of these cases.
//

import Foundation

enum {{APP_NAME}}Error: LocalizedError {
    case network(NetworkError)
    case persistence(PersistenceError)
    case validation(ValidationError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .network(let error): return error.errorDescription
        case .persistence(let error): return error.errorDescription
        case .validation(let error): return error.errorDescription
        case .unknown(let error): return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }

    var failureReason: String? {
        switch self {
        case .network(let error): return error.failureReason
        case .persistence(let error): return error.failureReason
        case .validation(let error): return error.failureReason
        case .unknown(let error): return "The error was: \(error.localizedDescription)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network(let error): return error.recoverySuggestion
        case .persistence(let error): return error.recoverySuggestion
        case .validation(let error): return error.recoverySuggestion
        case .unknown: return "Please try again. If the problem persists, contact support."
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .network(let error): return error.severity
        case .persistence(let error): return error.severity
        case .validation(let error): return error.severity
        case .unknown: return .critical
        }
    }

    var isRetryable: Bool {
        switch self {
        case .network(let error): return error.isRetryable
        case .persistence, .validation, .unknown: return false
        }
    }

    var telemetryIdentifier: String {
        switch self {
        case .network(let error): return "network.\(String(describing: error))"
        case .persistence(let error): return "persistence.\(String(describing: error))"
        case .validation(let error): return "validation.\(String(describing: error))"
        case .unknown: return "unknown"
        }
    }

    static func from(_ error: Error) -> {{APP_NAME}}Error {
        if let appError = error as? {{APP_NAME}}Error { return appError }
        if let networkError = error as? NetworkError { return .network(networkError) }
        if let persistenceError = error as? PersistenceError { return .persistence(persistenceError) }
        if let validationError = error as? ValidationError { return .validation(validationError) }
        return .unknown(error)
    }
}

enum ErrorSeverity {
    case info
    case warning
    case critical
}

struct SuccessMessage {
    let message: String
    let icon: String?

    init(_ message: String, icon: String? = "checkmark.circle.fill") {
        self.message = message
        self.icon = icon
    }
}
