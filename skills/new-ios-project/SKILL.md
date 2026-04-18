---
name: new-ios-project
description: Apply Fanxie iOS project conventions to a newly-created Xcode project. Use when the user says things like "set up the iOS project structure", "bootstrap this new iOS app", "apply our iOS conventions", or "scaffold a new iOS project for [name]". Assumes an empty Xcode project already exists at the target path.
argument-hint: [project-path] [app-name]
---

# New iOS Project Bootstrap

Apply the shared Fanxie iOS project structure, conventions, and dependencies to a brand-new (empty) Xcode project. The user has already created the Xcode project via `Xcode → New Project`; this skill sets up everything else.

## Inputs

- `$1` — absolute path to the Xcode project directory (the folder containing the `.xcodeproj`). If missing, ask the user.
- `$2` — app name / module name (e.g. `Kiveo`, `Breeze`). Defaults to the `.xcodeproj` basename if not given.

## Preflight checks

Before touching anything:

1. Confirm `$1` exists and contains exactly one `.xcodeproj`.
2. Confirm the inner source folder exists (Xcode creates `$1/$2/` with `$2App.swift` inside).
3. If a `CLAUDE.md` already exists at the project root, **stop and ask** — do not overwrite.
4. If `$1/$2/Core/` or `$1/$2/Shared/` already exist, stop and ask — this skill is for empty projects.

## Steps

### 1. Create folder structure

Create the canonical directory layout inside `$1/$2/`. Reference: [references/folder-structure.md](references/folder-structure.md).

```
$2/
├── App/
│   └── Navigation/
├── Core/
│   ├── Models/
│   ├── Services/
│   │   └── ErrorHandling/
│   ├── Utilities/
│   └── Persistence/
├── Features/
├── Shared/
│   ├── Components/
│   │   ├── Common/
│   │   ├── Controls/
│   │   └── Feedback/
│   ├── Design/
│   ├── Extensions/
│   └── Modifiers/
├── Resources/
├── DevHelpers/
└── PreviewContent/
```

Use `mkdir -p` for all directories in a single command.

### 2. Move the Xcode-generated app file

Xcode places `$2App.swift` at `$1/$2/$2App.swift`. Move it to `$1/$2/App/$2App.swift` so the App/ folder owns app-level code. **Note:** moving the file in the filesystem does not update the `.xcodeproj` file reference — tell the user they'll need to re-add it in Xcode (drag into the `App` group, or right-click → "Add Files...").

### 3. Drop in template files

Copy the following from `references/templates/` into the project, substituting `{{APP_NAME}}` with `$2` in **both file contents and file names**. Some templates have `{{APP_NAME}}` in the filename itself — rename accordingly when copying.

**App shell + error taxonomy:**

| Template | Destination |
|---|---|
| `SheetManager.swift` | `$1/$2/App/Navigation/SheetManager.swift` |
| `AppSheet.swift` | `$1/$2/App/Navigation/AppSheet.swift` |
| `AppError.swift` | `$1/$2/Core/Services/ErrorHandling/{{APP_NAME}}Error.swift` |
| `NetworkError.swift` | `$1/$2/Core/Services/ErrorHandling/NetworkError.swift` |
| `PersistenceError.swift` | `$1/$2/Core/Services/ErrorHandling/PersistenceError.swift` |
| `ValidationError.swift` | `$1/$2/Core/Services/ErrorHandling/ValidationError.swift` |
| `ErrorLogger.swift` | `$1/$2/Core/Services/ErrorHandling/ErrorLogger.swift` |
| `SheetPreview.swift` | `$1/$2/DevHelpers/SheetPreview.swift` |
| `CLAUDE.md` | `$1/CLAUDE.md` |

**Design vocabulary:**

| Template | Destination |
|---|---|
| `Design/Color+{{APP_NAME}}Tokens.swift` | `$1/$2/Shared/Design/Color+{{APP_NAME}}Tokens.swift` |
| `Design/DesignTokens.swift` | `$1/$2/Shared/Design/DesignTokens.swift` |
| `Design/ButtonStyles.swift` | `$1/$2/Shared/Design/ButtonStyles.swift` |
| `Design/{{APP_NAME}}CardModifier.swift` | `$1/$2/Shared/Design/{{APP_NAME}}CardModifier.swift` |
| `Design/FontExtension.swift` | `$1/$2/Shared/Extensions/FontExtension.swift` |

**Feedback (snackbar / alert / loading / skeleton):**

| Template | Destination |
|---|---|
| `Feedback/SnackbarMessage.swift` | `$1/$2/Shared/Components/Feedback/SnackbarMessage.swift` |
| `Feedback/SnackbarView.swift` | `$1/$2/Shared/Components/Feedback/SnackbarView.swift` |
| `Feedback/AlertMessage.swift` | `$1/$2/Shared/Components/Feedback/AlertMessage.swift` |
| `Feedback/ErrorAlertModifier.swift` | `$1/$2/Shared/Components/Feedback/ErrorAlertModifier.swift` |
| `Feedback/{{APP_NAME}}Alert.swift` | `$1/$2/Shared/Components/Feedback/{{APP_NAME}}Alert.swift` |
| `Feedback/ErrorPresenter.swift` | `$1/$2/Shared/Components/Feedback/ErrorPresenter.swift` |
| `Feedback/LoadingState.swift` | `$1/$2/Shared/Components/Feedback/LoadingState.swift` |
| `Feedback/SkeletonView.swift` | `$1/$2/Shared/Components/Feedback/SkeletonView.swift` |

Substitution rules:
- Replace `{{APP_NAME}}` everywhere (including type names: `{{APP_NAME}}Error` → `BreezeError`, `{{APP_NAME}}Alert` → `BreezeAlert`, `{{APP_NAME}}CardModifier` → `BreezeCardModifier`).
- Also rename files whose names contain `{{APP_NAME}}` (e.g. `{{APP_NAME}}Alert.swift` → `BreezeAlert.swift`).
- Leave `Color.theme.*`, `Font.app*`, and `.appPrimary`/`.appCard(…)` identifiers as-is — those are the shared convention across all Fanxie apps.

**Note on seed localization keys:** several templates reference keys like `button.cancel`, `button.retry`, `button.ok`, `button.confirm`, `alert.error.title`, `alert.error.generic`, `common.loading`, `common.loading.with_message`, `prompt.optional`, `picker.mode`. Xcode's String Catalog auto-extracts these on first build. Nothing to do at scaffold time.

### 4. Create Localizable.xcstrings

Create an empty String Catalog at `$1/$2/Resources/Localizable.xcstrings` with this content:

```json
{
  "sourceLanguage" : "en",
  "strings" : {},
  "version" : "1.0"
}
```

Tell the user to add this file to the Xcode project manually (drag into the `Resources` group).

### 5. Add the Fanxie iOS Core package dependency

Tell the user to add the shared package via Xcode:

1. `File → Add Package Dependencies…`
2. URL: `https://github.com/fanxie-lab/fanxie-ios-core-package`
3. Pick the products:
   - `FanxieCore` — always add (haptics, utilities, extensions, `GlassEffectExtension`). Required by the `{{APP_NAME}}CardModifier` template, so the project won't compile without it.
   - `FanxieComponents` — add if the app needs `SafariView`, `CachedAsyncImage`, `FlowLayout`, `PillTabBar`, `ChipPicker`, `RadioButton`, `ComboButton`, or `RepresentableSearchField`. Safe to add on day one — unused imports cost nothing.

**Do not** attempt to edit `project.pbxproj` directly — that's fragile. Instead, print the exact URL and product list for the user to add in Xcode.

**Design and feedback primitives ship as templates (step 3), not as package products.** Design is brand, and brand is per-app — see `_PRD/PackageMigration_PRD.md` in any existing Fanxie app repo for the rationale.

### 6. Update `.gitignore`

Ensure the project `.gitignore` includes iOS standards. If missing, create `$1/.gitignore` with:

```
# Xcode
build/
DerivedData/
*.pbxuser
*.mode1v3
*.mode2v3
*.perspectivev3
xcuserdata/
*.xccheckout
*.xcscmblueprint
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.swiftpm/
Package.resolved

# CocoaPods (unused but common false-positive additions)
Pods/

# macOS
.DS_Store

# Claude / dev
.claude/settings.local.json
```

If a `.gitignore` already exists, add only missing lines — don't overwrite.

### 7. Report back

Print a concise summary with:

- ✅ what was created
- ⚠️ what the user needs to do manually (add files to Xcode project, add SPM package)
- 📝 suggested next commit message: `chore: bootstrap project structure`

## Notes for the agent running this skill

- **Never** create `.md` files other than `CLAUDE.md` unless the user asks.
- **Never** modify `project.pbxproj` — tell the user to do file additions in Xcode.
- **Never** run `git init` or `git commit` — the user drives that.
- If the user's new Xcode project already has their own opinions (different folders, existing code), stop and ask before merging conventions in.
- The `swift-ui-architect` agent rule in the scaffolded `CLAUDE.md` assumes that agent exists in the user's global Claude config — it does for this user.
