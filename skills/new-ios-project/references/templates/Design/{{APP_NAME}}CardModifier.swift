//
//  {{APP_NAME}}CardModifier.swift
//  {{APP_NAME}}
//
//  Card container for list items, detail sections, and small groupings.
//  Apply via `.appCard()` on any view. Three flavors:
//    - .accent: tinted with the app's accent
//    - .muted:  system gray background
//    - .plain:  system background (looks like a raised sheet)
//
//  Requires FanxieCore's GlassEffectExtension (iOS 26 Liquid Glass).
//

import SwiftUI
import FanxieCore

enum {{APP_NAME}}CardStyle {
    case accent
    case muted
    case plain
}

struct {{APP_NAME}}CardModifier: ViewModifier {
    let style: {{APP_NAME}}CardStyle

    func body(content: Content) -> some View {
        switch style {
        case .accent:
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(0.1), in: RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.card))
                .glassEffectCard(cornerRadius: {{APP_NAME}}Radius.card)
        case .muted:
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.card))
                .glassEffectCard(cornerRadius: {{APP_NAME}}Radius.card)
        case .plain:
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.card))
                .glassEffectCard(cornerRadius: {{APP_NAME}}Radius.card)
        }
    }
}

extension View {
    func appCard(_ style: {{APP_NAME}}CardStyle = .accent) -> some View {
        modifier({{APP_NAME}}CardModifier(style: style))
    }
}
