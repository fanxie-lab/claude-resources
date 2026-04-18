# Canonical iOS project folder structure

This is the folder convention used across Fanxie iOS projects. It is inspired by MVVM + feature-based organization, with clear separation between app shell, domain core, reusable UI, and per-feature scenes.

## Top-level layout

```
{{APP_NAME}}/
├── App/              # App entry point, tab bar, navigation, environment
│   ├── {{APP_NAME}}App.swift
│   ├── MainTabView.swift     (created per-app)
│   └── Navigation/
│       ├── AppSheet.swift    (enum of every sheet in the app)
│       └── SheetManager.swift (published current sheet)
│
├── Core/             # Domain layer — no SwiftUI imports here
│   ├── Models/       # SwiftData @Model types, domain enums, DTOs
│   ├── Services/     # API clients, persistence coordinators, import/export
│   │   └── ErrorHandling/
│   ├── Utilities/    # Small generic helpers (not UI)
│   └── Persistence/  # ModelContainer setup, migrations, upgrade hooks
│
├── Features/         # One folder per user-facing feature
│   └── <FeatureName>/
│       ├── Views/
│       ├── ViewModels/
│       └── Components/   (feature-scoped; promote to Shared/ if reused)
│
├── Shared/           # Reusable UI — no domain knowledge
│   ├── Components/
│   │   ├── Common/       (SafariView, CachedAsyncImage, FlowLayout, PillTabBar)
│   │   ├── Controls/     (pickers, buttons, form fields)
│   │   └── Feedback/     (snackbars, alerts, loading, skeletons)
│   ├── Design/       # Tokens, button styles, card modifier
│   ├── Extensions/   # SwiftUI/UIKit type extensions
│   └── Modifiers/    # ViewModifiers (gradients, press effects, etc.)
│
├── Resources/        # Assets.xcassets, Localizable.xcstrings, fonts
├── DevHelpers/       # SeedData, SheetPreview, debug-only tooling
└── PreviewContent/   # Preview-only model containers and fixtures
```

## Rules

### Import direction
- `App` can import everything.
- `Features` can import `Core` + `Shared`.
- `Shared` can import `Core` utilities only — **never** domain models.
- `Core` imports nothing from other app folders (Foundation / SwiftData only).

### When to promote
- A component used in ≥2 features → move to `Shared/Components/`.
- A utility used in ≥2 services → move to `Core/Utilities/`.
- A pattern used in ≥2 apps → move to the `fanxie-ios-core` package.

### Naming
- Feature folder: PascalCase singular (`Library`, `Sessions`, not `Libraries`).
- Views: `<Noun>View.swift` or `<Noun>Screen.swift` for top-level feature screens.
- ViewModels: `<Noun>ViewModel.swift`, `@MainActor` + `@Observable`.
- Services: `<Noun>Service.swift` (stateless) or `<Noun>Manager.swift` (stateful).

### What lives where: quick reference
| Kind of file | Folder |
|---|---|
| `@Model` class | `Core/Models/<Group>/` |
| API response DTO | `Core/Models/<Feature>/` |
| Network client | `Core/Services/API/` |
| Reusable button style | package (`FanxieDesign`) |
| App-specific button | `Shared/Design/` |
| Snackbar view | package (`FanxieFeedback`) |
| A screen | `Features/<Feature>/Views/` |
| A modifier for a single screen | inside the screen file, private extension |
| A modifier used across features | `Shared/Modifiers/` |

### What NOT to create
- `Utils/` or `Helpers/` as dumping grounds — force categorization.
- Folders with a single file — inline it until there are 2+ peers.
- `Managers/` at the top level — managers live alongside what they manage (`Core/Services/` or `Core/Utilities/`).
