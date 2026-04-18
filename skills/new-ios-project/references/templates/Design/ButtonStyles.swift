//
//  ButtonStyles.swift
//  {{APP_NAME}}
//
//  The app's canonical button vocabulary. Every `Button` in user-facing code
//  should apply one of these styles via the convenience accessors at the
//  bottom (e.g. `.buttonStyle(.appPrimary)`).
//
//  Uses `Color.accentColor` which reads from `.tint(_:)` in the environment,
//  so make sure the root view sets `.tint(Color.theme.accent)` (or whatever
//  your brand accent is) once at the app entry point.
//

import SwiftUI

// MARK: - Primary

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    let expanded: Bool
    init(expanded: Bool = false) { self.expanded = expanded }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .frame(maxWidth: expanded ? .infinity : nil)
            .padding(.horizontal, expanded ? 0 : 20)
            .padding(.vertical, expanded ? 14 : 12)
            .background(isEnabled ? Color.accentColor : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - Secondary

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    let expanded: Bool
    init(expanded: Bool = false) { self.expanded = expanded }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .frame(maxWidth: expanded ? .infinity : nil)
            .padding(.horizontal, expanded ? 0 : 20)
            .padding(.vertical, expanded ? 14 : 12)
            .background(
                expanded
                    ? AnyShapeStyle(Color(.systemGray5))
                    : AnyShapeStyle(Color.clear)
            )
            .background(
                expanded
                    ? nil
                    : Capsule().stroke(isEnabled ? Color.accentColor : Color.gray, lineWidth: 1.5)
            )
            .foregroundColor(expanded ? (isEnabled ? .primary : .gray) : (isEnabled ? .accentColor : .gray))
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - Destructive

struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    let expanded: Bool
    init(expanded: Bool = false) { self.expanded = expanded }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .frame(maxWidth: expanded ? .infinity : nil)
            .padding(.horizontal, expanded ? 0 : 20)
            .padding(.vertical, expanded ? 14 : 12)
            .background(isEnabled ? Color.red : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct SubtleDestructiveButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.bold))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.red)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - Accent (tinted background)

/// Bordered-style button with accent background tint. Matches `.bordered` but
/// stays visually consistent across light/dark schemes.
struct AccentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.accentColor.opacity(isEnabled ? 0.15 : 0.08))
            .foregroundColor(isEnabled ? .accentColor : .gray)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - Plain Accent

/// No background, accent-colored text. For lightweight inline actions like "Edit".
struct PlainAccentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout.weight(.medium))
            .foregroundColor(isEnabled ? .accentColor : .gray)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

// MARK: - Convenience

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var appPrimary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static var appPrimaryExpanded: PrimaryButtonStyle { PrimaryButtonStyle(expanded: true) }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var appSecondary: SecondaryButtonStyle { SecondaryButtonStyle() }
    static var appSecondaryExpanded: SecondaryButtonStyle { SecondaryButtonStyle(expanded: true) }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    static var appDestructive: DestructiveButtonStyle { DestructiveButtonStyle() }
    static var appDestructiveExpanded: DestructiveButtonStyle { DestructiveButtonStyle(expanded: true) }
}

extension ButtonStyle where Self == SubtleDestructiveButtonStyle {
    static var appSubtleDestructive: SubtleDestructiveButtonStyle { SubtleDestructiveButtonStyle() }
}

extension ButtonStyle where Self == AccentButtonStyle {
    static var appAccent: AccentButtonStyle { AccentButtonStyle() }
}

extension ButtonStyle where Self == PlainAccentButtonStyle {
    static var appPlainAccent: PlainAccentButtonStyle { PlainAccentButtonStyle() }
}
