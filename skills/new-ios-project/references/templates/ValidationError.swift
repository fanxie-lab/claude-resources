//
//  ValidationError.swift
//  {{APP_NAME}}
//
//  Generic starter validation cases. Add app-specific cases as needed.
//

import Foundation

enum ValidationError: LocalizedError {
    case missingRequiredField(String)
    case duplicateEntry(String)
    case invalidDateRange
    case emptyInput(String)
    case invalidFormat(field: String, expected: String)
    case outOfRange(field: String, min: Int, max: Int, actual: Int)

    var errorDescription: String? {
        switch self {
        case .missingRequiredField(let field): return "Missing \(field)"
        case .duplicateEntry: return "Duplicate entry"
        case .invalidDateRange: return "Invalid date range"
        case .emptyInput(let field): return "\(field) cannot be empty"
        case .invalidFormat: return "Invalid format"
        case .outOfRange(let field, _, _, _): return "\(field) is out of range"
        }
    }

    var failureReason: String? {
        switch self {
        case .missingRequiredField(let field):
            return "The \(field) field is required but was not provided."
        case .duplicateEntry(let item):
            return "An entry for '\(item)' already exists."
        case .invalidDateRange:
            return "The start date must be before the end date."
        case .emptyInput(let field):
            return "The \(field) field cannot be left empty."
        case .invalidFormat(let field, let expected):
            return "The \(field) field has an invalid format. Expected: \(expected)"
        case .outOfRange(let field, let min, let max, let actual):
            return "\(field) must be between \(min) and \(max) (got \(actual))."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .missingRequiredField(let field):
            return "Please provide a value for \(field) and try again."
        case .duplicateEntry:
            return "This item already exists. Please use a different entry."
        case .invalidDateRange:
            return "Please ensure the start date is before the end date."
        case .emptyInput(let field):
            return "Please enter a value for \(field)."
        case .invalidFormat(_, let expected):
            return "Please use the format: \(expected)"
        case .outOfRange(_, let min, let max, _):
            return "Please enter a value between \(min) and \(max)."
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .missingRequiredField, .emptyInput: return .info
        case .duplicateEntry, .invalidDateRange, .invalidFormat, .outOfRange: return .warning
        }
    }
}
