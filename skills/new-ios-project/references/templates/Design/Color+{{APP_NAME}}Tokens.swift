//
//  Color+{{APP_NAME}}Tokens.swift
//  {{APP_NAME}}
//
//  Semantic color tokens referencing the asset catalog. Every user-facing color
//  in the app should come through this namespace — never use `Color(.systemX)`
//  or hex literals scattered across views.
//
//  Workflow when adding a color:
//  1. Add the color to `Assets.xcassets` with an asset name (e.g. `AccentWarm`).
//  2. Add a `static let` here that loads it via `Color("AccentWarm")`.
//  3. Reference it as `Color.theme.accentWarm` at the call site.
//

import SwiftUI

extension Color {
    enum theme {
        // MARK: - Backgrounds
        static let backgroundPrimary = Color("Background")
        static let backgroundSecondary = Color("BackgroundSecondary")

        // MARK: - Text
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        static let textTertiary = Color("TextTertiary")

        // MARK: - Accents
        /// Primary brand accent — also set via `.tint(Color.theme.accent)` at
        /// the app root so `Color.accentColor` resolves to this everywhere.
        static let accent = Color("Accent")

        // MARK: - UI
        static let borderSubtle = Color("BorderSubtle")
        static let shadow = Color("Shadow")

        // Add app-specific tokens below as needed.
    }
}
