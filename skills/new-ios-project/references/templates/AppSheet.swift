//
//  AppSheet.swift
//  {{APP_NAME}}
//
//  Enumerates every sheet the app can present. Each case should produce a
//  stable `id` so re-entrant presentations do not flicker. Add a new case
//  whenever a new modal is introduced.
//

import Foundation

enum AppSheet: Identifiable {
    case settings
    // Add new cases here, e.g.:
    // case detail(SomeModel)

    var id: String {
        switch self {
            case .settings: return "settings"
        }
    }
}

extension AppSheet: Equatable {
    static func == (lhs: AppSheet, rhs: AppSheet) -> Bool {
        lhs.id == rhs.id
    }
}
