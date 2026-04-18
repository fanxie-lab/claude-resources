//
//  NetworkError.swift
//  {{APP_NAME}}
//

import Foundation

enum NetworkError: LocalizedError {
    case offline
    case timeout
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case unknownStatusCode(Int)
    case requestFailed(Error?)
    case decodingFailed(Error)
    case invalidData
    case rateLimited
    case sslError

    var errorDescription: String? {
        switch self {
        case .offline: return "No internet connection"
        case .timeout: return "Request timed out"
        case .invalidURL: return "Invalid web address"
        case .invalidResponse: return "Invalid server response"
        case .serverError(let code): return "Server error (code: \(code))"
        case .unknownStatusCode(let code): return "Unexpected response (code: \(code))"
        case .requestFailed: return "Network request failed"
        case .decodingFailed: return "Failed to process server response"
        case .invalidData: return "Invalid data received"
        case .rateLimited: return "Too many requests"
        case .sslError: return "Secure connection failed"
        }
    }

    var failureReason: String? {
        switch self {
        case .offline: return "Your device is not connected to the internet."
        case .timeout: return "The server took too long to respond."
        case .invalidURL: return "The web address is malformed or incomplete."
        case .invalidResponse: return "The server sent an unexpected response format."
        case .serverError: return "The server encountered an internal error."
        case .unknownStatusCode: return "The server responded with an unexpected status."
        case .requestFailed(let underlying):
            if let error = underlying { return "The network request failed: \(error.localizedDescription)" }
            return "The network request failed for an unknown reason."
        case .decodingFailed(let error): return "Failed to decode the response: \(error.localizedDescription)"
        case .invalidData: return "The data received from the server is corrupted or in an unexpected format."
        case .rateLimited: return "You've made too many requests in a short period."
        case .sslError: return "Unable to establish a secure connection to the server."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .offline: return "Check your internet connection and try again."
        case .timeout: return "Check your connection and try again."
        case .invalidURL: return "Please check the URL and try again."
        case .invalidResponse: return "Try again in a few moments. If the problem persists, contact support."
        case .serverError: return "Try again in a few moments. If the problem persists, the service may be down."
        case .unknownStatusCode: return "Try again. If the problem persists, contact support."
        case .requestFailed: return "Check your connection and try again."
        case .decodingFailed: return "Try again. If the problem persists, the response may be malformed."
        case .invalidData: return "Try again. If the problem persists, the resource may be unavailable."
        case .rateLimited: return "Please wait a moment before trying again."
        case .sslError: return "Check your device's date and time settings, or try again later."
        }
    }

    var isRetryable: Bool {
        switch self {
        case .offline, .timeout, .serverError, .requestFailed, .rateLimited: return true
        case .invalidURL, .invalidResponse, .unknownStatusCode, .decodingFailed, .invalidData, .sslError: return false
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .offline: return .info
        case .timeout, .serverError, .requestFailed, .rateLimited, .invalidData: return .warning
        case .invalidURL, .invalidResponse, .decodingFailed, .unknownStatusCode, .sslError: return .critical
        }
    }
}
