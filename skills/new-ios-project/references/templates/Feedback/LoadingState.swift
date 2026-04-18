//
//  LoadingState.swift
//  {{APP_NAME}}
//
//  Loading indicator + overlay modifier. Wrap any view with
//  `.loadingOverlay(isLoading)` to dim + disable it while an operation runs.
//

import SwiftUI

enum LoadingStyle {
    case spinner
    case spinnerWithText(String)
}

struct LoadingView: View {
    let style: LoadingStyle

    init(_ style: LoadingStyle = .spinner) {
        self.style = style
    }

    var body: some View {
        switch style {
        case .spinner:
            ProgressView()
                .accessibilityLabel(Text("common.loading", comment: "Loading indicator accessibility label"))
        case .spinnerWithText(let message):
            VStack(spacing: 16) {
                ProgressView()
                Text(message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(Text("common.loading.with_message \(message)", comment: "Loading indicator with message accessibility label"))
        }
    }
}

struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    let style: LoadingStyle

    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(isLoading ? 0.5 : 1.0)
                .disabled(isLoading)

            if isLoading {
                LoadingView(style)
            }
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, style: LoadingStyle = .spinner) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading, style: style))
    }
}
