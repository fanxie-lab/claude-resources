//
//  ErrorAlertModifier.swift
//  {{APP_NAME}}
//
//  Binds an optional `AlertMessage` to SwiftUI's native `.alert(...)`.
//  Usage: `.errorAlert(message: $viewModel.alertMessage)`.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var alertMessage: AlertMessage?

    func body(content: Content) -> some View {
        content
            .alert(
                alertMessage?.title ?? "",
                isPresented: Binding(
                    get: { alertMessage != nil },
                    set: { if !$0 { alertMessage = nil } }
                )
            ) {
                if let secondaryAction = alertMessage?.secondaryAction {
                    Button(secondaryAction.label, role: secondaryAction.role) {
                        secondaryAction.action()
                    }
                }

                if let primaryAction = alertMessage?.primaryAction {
                    Button(primaryAction.label, role: primaryAction.role) {
                        primaryAction.action()
                    }
                }
            } message: {
                if let message = alertMessage?.message {
                    Text(message)
                }
            }
    }
}

extension View {
    func errorAlert(message: Binding<AlertMessage?>) -> some View {
        modifier(ErrorAlertModifier(alertMessage: message))
    }
}
