//
//  DesignTokens.swift
//  {{APP_NAME}}
//
//  Spacing and corner radius constants used across the app. Keep these in
//  sync with what your design vocabulary expects; view code should reference
//  these enums rather than scattering magic numbers.
//

import SwiftUI

enum {{APP_NAME}}Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

enum {{APP_NAME}}Radius {
    static let cover: CGFloat = 12
    static let card: CGFloat = 16
    static let input: CGFloat = 12
    static let modal: CGFloat = 20
    static let badge: CGFloat = 8
    // Buttons use Capsule()
}
