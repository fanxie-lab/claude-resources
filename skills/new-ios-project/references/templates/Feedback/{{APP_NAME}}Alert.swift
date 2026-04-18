//
//  {{APP_NAME}}Alert.swift
//  {{APP_NAME}}
//
//  Custom-styled modal alert rendered via a UIKit overlay window (so it sits
//  above sheets, toolbars, and keyboards). Use for branded confirmations and
//  destructive prompts. For lightweight system-styled alerts, see
//  `AlertMessage` + `ErrorAlertModifier` instead.
//
//  Starter version: title + message + primary action + optional secondary.
//  Extend as needed — add inputs, segmented pickers, icons, etc. once the
//  brand direction for those is settled.
//
//  Usage:
//  ```
//  SomeView()
//      .appAlert(
//          isPresented: $showAlert,
//          icon: "exclamationmark.triangle",
//          title: "End Session",
//          message: "Are you sure?",
//          primaryAction: .init(label: "End", role: .destructive) { ... },
//          secondaryAction: .cancel()
//      )
//  ```
//

import SwiftUI
import UIKit

// MARK: - Action

struct {{APP_NAME}}AlertAction {
    let label: String
    let role: ButtonRole?
    let action: () -> Void

    init(label: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.label = label
        self.role = role
        self.action = action
    }

    static func cancel(_ action: @escaping () -> Void = {}) -> {{APP_NAME}}AlertAction {
        {{APP_NAME}}AlertAction(
            label: String(localized: "button.cancel", comment: "Cancel action button"),
            role: .cancel,
            action: action
        )
    }

    static func destructive(_ label: String, action: @escaping () -> Void) -> {{APP_NAME}}AlertAction {
        {{APP_NAME}}AlertAction(label: label, role: .destructive, action: action)
    }
}

// MARK: - Alert View

struct {{APP_NAME}}Alert: View {
    let icon: String?
    let title: String
    let message: String
    let primaryAction: {{APP_NAME}}AlertAction
    let secondaryAction: {{APP_NAME}}AlertAction?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.accent)
                }
                Text(title)
                    .font(.appTitle(22))
                    .foregroundStyle(.primary)
            }

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                if let secondary = secondaryAction {
                    Button {
                        secondary.action()
                    } label: {
                        Text(secondary.label)
                    }
                    .buttonStyle(.appSecondaryExpanded)
                }

                Button {
                    primaryAction.action()
                } label: {
                    Text(primaryAction.label)
                }
                .buttonStyle(primaryAction.role == .destructive ? .appDestructiveExpanded : .appPrimaryExpanded)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.modal))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Window Presenter

private final class {{APP_NAME}}AlertWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        windowLevel = .alert + 1
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@MainActor
final class {{APP_NAME}}AlertPresenter: ObservableObject {
    static let shared = {{APP_NAME}}AlertPresenter()

    private var alertWindow: {{APP_NAME}}AlertWindow?
    private var hostingController: UIHostingController<AnyView>?

    private init() {}

    func present<Content: View>(content: Content, colorScheme: ColorScheme?) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first
        else { return }

        let window = {{APP_NAME}}AlertWindow(windowScene: windowScene)
        var viewContent = AnyView(content)
        if let scheme = colorScheme {
            viewContent = AnyView(content.environment(\.colorScheme, scheme))
        }

        let hc = UIHostingController(rootView: viewContent)
        hc.view.backgroundColor = .clear
        window.rootViewController = hc
        window.makeKeyAndVisible()

        self.alertWindow = window
        self.hostingController = hc
    }

    func dismiss() {
        alertWindow?.isHidden = true
        alertWindow = nil
        hostingController = nil
    }
}

// MARK: - Container

private struct {{APP_NAME}}AlertContainer<AlertContent: View>: View {
    @Binding var isPresented: Bool
    let colorScheme: ColorScheme?
    let alertContent: () -> AlertContent
    let onDismiss: () -> Void

    @State private var showBackground = false
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.black.opacity(showBackground ? 0.5 : 0)
                .ignoresSafeArea()

            if showAlert {
                alertContent()
                    .frame(maxWidth: 320)
                    .padding(.horizontal, 40)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                showBackground = true
                showAlert = true
            }
        }
        .onChange(of: isPresented) { _, newValue in
            if !newValue { dismissWithAnimation() }
        }
    }

    private func dismissWithAnimation() {
        withAnimation(.easeIn(duration: 0.15)) {
            showBackground = false
            showAlert = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            onDismiss()
        }
    }
}

// MARK: - Modifier

struct {{APP_NAME}}AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let colorScheme: ColorScheme?
    let icon: String?
    let title: String
    let message: String
    let primaryAction: {{APP_NAME}}AlertAction
    let secondaryAction: {{APP_NAME}}AlertAction?

    @State private var internalPresented = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                if isPresented && !internalPresented { presentAlert() }
            }
            .onChange(of: isPresented) { _, newValue in
                if newValue && !internalPresented {
                    presentAlert()
                } else if !newValue && internalPresented {
                    {{APP_NAME}}AlertPresenter.shared.dismiss()
                    internalPresented = false
                }
            }
    }

    private func presentAlert() {
        internalPresented = true

        let wrappedPrimary = {{APP_NAME}}AlertAction(label: primaryAction.label, role: primaryAction.role) {
            isPresented = false
            primaryAction.action()
        }
        let wrappedSecondary: {{APP_NAME}}AlertAction? = secondaryAction.map { secondary in
            {{APP_NAME}}AlertAction(label: secondary.label, role: secondary.role) {
                isPresented = false
                secondary.action()
            }
        }

        let container = {{APP_NAME}}AlertContainer(
            isPresented: $isPresented,
            colorScheme: colorScheme,
            alertContent: {
                {{APP_NAME}}Alert(
                    icon: icon,
                    title: title,
                    message: message,
                    primaryAction: wrappedPrimary,
                    secondaryAction: wrappedSecondary
                )
            },
            onDismiss: {
                {{APP_NAME}}AlertPresenter.shared.dismiss()
                internalPresented = false
                isPresented = false
            }
        )

        {{APP_NAME}}AlertPresenter.shared.present(content: container, colorScheme: colorScheme)
    }
}

// MARK: - View Extension

extension View {
    func appAlert(
        isPresented: Binding<Bool>,
        colorScheme: ColorScheme? = nil,
        icon: String? = nil,
        title: String,
        message: String,
        primaryAction: {{APP_NAME}}AlertAction,
        secondaryAction: {{APP_NAME}}AlertAction? = nil
    ) -> some View {
        modifier({{APP_NAME}}AlertModifier(
            isPresented: isPresented,
            colorScheme: colorScheme,
            icon: icon,
            title: title,
            message: message,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        ))
    }
}
