//
//  ErrorLogger.swift
//  {{APP_NAME}}
//
//  Centralized error logging. By default logs to OSLog + console in DEBUG.
//  To wire in a telemetry SDK (e.g., TelemetryDeck), replace the `emit(_:_:)`
//  implementation below.
//

import Foundation
import OSLog

@MainActor
class ErrorLogger {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "{{APP_NAME}}", category: "errors")

    /// Logs a categorized error with optional context.
    static func log(_ error: {{APP_NAME}}Error, context: [String: String] = [:]) {
        var parameters = context
        parameters["errorType"] = error.telemetryIdentifier
        parameters["errorSeverity"] = String(describing: error.severity)
        if let description = error.errorDescription {
            parameters["errorDescription"] = description
        }

        emit("Error.\(error.telemetryIdentifier)", parameters)

        #if DEBUG
        logToConsole(error, context: context)
        #endif
    }

    /// Logs a raw `Error`, wrapping it into the app's error taxonomy first.
    static func logRaw(_ error: Error, context: [String: String] = [:]) {
        log({{APP_NAME}}Error.from(error), context: context)
    }

    /// Logs a successful operation (for tracking positive outcomes).
    static func logSuccess(_ message: SuccessMessage, context: [String: String] = [:]) {
        var parameters = context
        parameters["message"] = message.message
        emit("Operation.success", parameters)
    }

    // MARK: - Emit

    /// Override this to route signals to a telemetry SDK.
    private static func emit(_ signal: String, _ parameters: [String: String]) {
        // Example (TelemetryDeck):
        // TelemetryDeck.signal(signal, parameters: parameters)
        logger.info("\(signal, privacy: .public) \(parameters, privacy: .public)")
    }

    // MARK: - Debug console

    #if DEBUG
    private static func logToConsole(_ error: {{APP_NAME}}Error, context: [String: String]) {
        print("🔴 Error: \(error.errorDescription ?? "Unknown error")")
        if let reason = error.failureReason { print("   Reason: \(reason)") }
        if let suggestion = error.recoverySuggestion { print("   Suggestion: \(suggestion)") }
        if !context.isEmpty { print("   Context: \(context)") }
        print("   Severity: \(error.severity)")
        print("   Identifier: \(error.telemetryIdentifier)")
    }
    #endif
}

// MARK: - Convenience

extension ErrorLogger {
    static func logNetwork(_ error: NetworkError, url: String? = nil, operation: String? = nil) {
        var context: [String: String] = [:]
        if let url { context["url"] = url }
        if let operation { context["operation"] = operation }
        log(.network(error), context: context)
    }

    static func logPersistence(_ error: PersistenceError, entity: String? = nil, operation: String? = nil) {
        var context: [String: String] = [:]
        if let entity { context["entity"] = entity }
        if let operation { context["operation"] = operation }
        log(.persistence(error), context: context)
    }

    static func logValidation(_ error: ValidationError, field: String? = nil, value: String? = nil) {
        var context: [String: String] = [:]
        if let field { context["field"] = field }
        if let value { context["attemptedValue"] = value }
        log(.validation(error), context: context)
    }
}
