//
//  PersistenceError.swift
//  {{APP_NAME}}
//

import Foundation

enum PersistenceError: LocalizedError {
    case containerInitializationFailed(Error)
    case schemaIncompatible
    case storageUnavailable
    case migrationFailed(Error)
    case inMemoryFallback

    var errorDescription: String? {
        switch self {
        case .containerInitializationFailed(let error):
            return "Failed to initialize data storage: \(error.localizedDescription)"
        case .schemaIncompatible:
            return "Database schema is incompatible with this version of the app"
        case .storageUnavailable:
            return "Storage is currently unavailable"
        case .migrationFailed(let error):
            return "Failed to migrate data: \(error.localizedDescription)"
        case .inMemoryFallback:
            return "Using temporary storage - your data will not persist"
        }
    }

    var failureReason: String? {
        switch self {
        case .containerInitializationFailed: return "The database could not be created or opened."
        case .schemaIncompatible: return "The database structure has changed."
        case .storageUnavailable: return "Unable to access the file system."
        case .migrationFailed: return "Data migration from previous version failed."
        case .inMemoryFallback: return "Falling back to temporary in-memory storage."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .containerInitializationFailed:
            return "Please ensure you have sufficient storage space and try restarting the app."
        case .schemaIncompatible:
            return "Please update to the latest version of the app."
        case .storageUnavailable:
            return "Check your device storage and try again."
        case .migrationFailed:
            return "You may need to reinstall the app. Contact support if the problem persists."
        case .inMemoryFallback:
            return "Your changes will be lost when you close the app. Please free up storage space."
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .containerInitializationFailed, .schemaIncompatible, .migrationFailed: return .critical
        case .storageUnavailable: return .warning
        case .inMemoryFallback: return .info
        }
    }
}
