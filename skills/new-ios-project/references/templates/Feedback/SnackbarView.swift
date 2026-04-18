//
//  SnackbarView.swift
//  {{APP_NAME}}
//
//  Toast-style notification: slides in from the bottom, auto-dismisses after
//  `message.duration`, supports swipe-down-to-dismiss. Attach to any view via
//  `.snackbar(message: $someBinding)`.
//

import SwiftUI

struct SnackbarView: View {
    let message: SnackbarMessage
    let onDismiss: () -> Void

    @State private var offset: CGFloat = 100
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: message.type.iconName)
                .foregroundStyle(message.type.color)
                .font(.system(size: 20, weight: .semibold))

            Text(message.text)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            if let actionLabel = message.actionLabel, let action = message.action {
                Button {
                    action()
                    onDismiss()
                } label: {
                    Text(actionLabel)
                        .font(.caption2.weight(.bold))
                }
            }

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(message.type.color)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56)
        .background {
            RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.card)
                .fill(.regularMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: {{APP_NAME}}Radius.card)
                        .fill(message.type.color.opacity(0.1))
                }
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
        .tint(.primary)
        .offset(y: offset + dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 { dragOffset = value.translation.height }
                }
                .onEnded { value in
                    if value.translation.height > 50 {
                        withAnimation(.easeInOut(duration: 0.2)) { offset = 100 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { onDismiss() }
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { dragOffset = 0 }
                    }
                }
        )
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { offset = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + message.duration) { dismiss() }
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.25)) { offset = 100 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { onDismiss() }
    }
}

// MARK: - Snackbar Container Modifier

struct SnackbarModifier: ViewModifier {
    @Binding var message: SnackbarMessage?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if let message = message {
                VStack {
                    Spacer()
                    SnackbarView(message: message) {
                        self.message = nil
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 16)
                }
                .zIndex(999)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: message != nil)
    }
}

extension View {
    func snackbar(message: Binding<SnackbarMessage?>) -> some View {
        modifier(SnackbarModifier(message: message))
    }
}
