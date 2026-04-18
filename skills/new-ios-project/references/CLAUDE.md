# {{APP_NAME}}

<!-- One-line description of what the app does. Replace this. -->

## Tech Stack

- SwiftUI with MVVM architecture
- SwiftData for persistence
- CloudKit for sync (if applicable)
- WidgetKit for Live Activities (if applicable)
- `fanxie-ios-core` Swift package for shared utilities/design/feedback/components

## Development Rules

1. **All development work must be conducted by the `swift-ui-architect` agent** — ensures consistent architecture, proper SwiftUI patterns, and comprehensive testing.

2. Follow the canonical folder structure — check `/Features` for feature organization and `/Shared/Components` for reusable UI. Promote components to the `fanxie-ios-core` package when reused across ≥2 apps.

3. Use SwiftData models in `/Core/Models` — maintain CloudKit compatibility if the app syncs.

4. All new views should include SwiftUI previews.

5. **Haptic Feedback** — use `FanxieHaptics` from the package:
   - `HapticManager.impact(.light)` — Toggles, selections, button taps
   - `HapticManager.impact(.medium)` — Pause/resume, drag reorder, confirmations
   - `HapticManager.notification(.success)` — Save, complete, import success
   - `HapticManager.notification(.error)` — Delete, remove, errors

6. **Glass Effect (iOS 26+)** — use `GlassEffectExtension` from `FanxieDesign`:
   - `.glassEffectCard(cornerRadius: 8)` — Cards with rounded corners (default 8pt)
   - `.glassEffectCircle()` — Circular views
   - `.glassEffectCapsule()` — Pill-shaped views
   - `.glassEffect(in: customShape)` — Any custom Shape
   - Handles iOS 26 availability automatically; no-op on earlier versions

7. **PRD Workflow** — when a new feature or update requires a PRD document:
   - All PRD work requires input from `prd-architect` and `swift-ui-architect` agents
   - Create the PRD under `/_PRD` with naming convention: `FEATURE_NAME_PRD.md`
   - After the PRD is approved, create a corresponding checklist file: `FEATURE_NAME_CHECKLIST.md`

8. **Changelog Maintenance** — keep `CHANGELOG.md` updated:
   - Update when completing a new feature, bug fix, or notable change
   - Follow [Keep a Changelog](https://keepachangelog.com/) format
   - Use sections: Added, Changed, Fixed, Removed
   - Add entries under `[Unreleased]` until a version is released

9. **In-App Links** — use `SafariView` from `FanxieComponents` for HTTP/HTTPS links:
   - For web URLs, use `sheetManager.show(.webView(url))` instead of SwiftUI `Link`
   - Opens `SFSafariViewController` within the app
   - `mailto:` links should continue using standard `Link` to open Mail app

10. **Localization** — all user-facing strings must use semantic localization keys:
    - Format: `Text("feature.element", comment: "Context for translators")`
    - Key naming: dot notation — `feature.context.element` (e.g., `library.addBook`, `button.cancel`)
    - Examples:
      - `Text("button.cancel", comment: "Dismiss dialog")`
      - `Button("button.save", comment: "Save changes") { action }`
      - `.navigationTitle(Text("settings.title", comment: "Settings screen"))`
      - Computed properties: `String(localized: "library.status.reading", comment: "Currently reading status")`
    - Always provide `comment:` describing context for translators
    - String Catalog: `{{APP_NAME}}/Resources/Localizable.xcstrings`
    - Do NOT use English text as keys — use semantic keys for maintainability

11. **Error Handling** — every thrown/surfaced error must be categorized:
    - Domain errors conform to the app's `{{APP_NAME}}Error` enum
    - Use `NetworkError`, `PersistenceError`, `ValidationError` sub-types
    - Log via `ErrorLogger.log(_:context:)` — never `print` or silent catches
    - Raw `Error` values go through `ErrorLogger.logRaw(_:)` which categorizes them

12. **Sheet Presentation** — all modals go through `SheetManager` + `AppSheet`:
    - Add a new case to `AppSheet` for each distinct sheet
    - Ensure each case produces a stable `id` (so re-entrant presentations don't flicker)
    - Present via `sheetManager.show(.caseName(args))`
