//
//  FontExtension.swift
//  {{APP_NAME}}
//
//  Typography tokens. Swap `"YourCustomFont"` below for the app's actual font
//  family. If you haven't picked one yet, leave the system fallbacks; delete
//  and replace whole functions as brand guidance lands.
//
//  Add the custom font files to the app target, then list them in Info.plist
//  under `UIAppFonts` (or the "Fonts provided by application" key) so the
//  custom family loads at runtime.
//

import SwiftUI

extension Font {
    // MARK: - Titles (custom family)

    /// Replace `"YourCustomFont"` with the actual PostScript name.
    static func appTitle(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .custom("YourCustomFont", size: size, relativeTo: .title).weight(weight)
    }

    static var appLargeTitle: Font { appTitle(34) }
    static var appTitle1: Font { appTitle(28) }
    static var appTitle2: Font { appTitle(22) }
    static var appTitle3: Font { appTitle(20) }
    static var appHeadline: Font { appTitle(17) }

    // MARK: - Body / Caption

    static var appBody: Font {
        .custom("YourCustomFont", size: 17, relativeTo: .body).weight(.regular)
    }

    static var appCaption: Font {
        .custom("YourCustomFont", size: 13, relativeTo: .caption).weight(.regular)
    }

    // MARK: - System fallbacks (use until custom font is wired up)

    // static var appBody: Font { .body }
    // static var appHeadline: Font { .headline }
}
