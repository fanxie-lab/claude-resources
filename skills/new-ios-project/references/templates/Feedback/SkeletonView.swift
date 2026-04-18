//
//  SkeletonView.swift
//  {{APP_NAME}}
//
//  Pulsing skeleton placeholders for async content. Respects Reduce Motion.
//  Compose app-specific skeletons (lists, cards, etc.) using the primitives
//  below — don't bake them in here.
//

import SwiftUI

/// Base pulsing rectangle. Fill a parent container to shape it.
struct SkeletonView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false

    var body: some View {
        Rectangle()
            .fill(Color.theme.borderSubtle)
            .opacity(reduceMotion ? 0.7 : (isAnimating ? 1.0 : 0.4))
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}

/// Skeleton shaped like a single line of text.
struct SkeletonTextLine: View {
    var width: CGFloat = 100

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.theme.borderSubtle)
            .frame(width: width, height: 12)
            .opacity(reduceMotion ? 0.7 : (isAnimating ? 1.0 : 0.4))
            .animation(
                reduceMotion ? nil : .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}
