---
name: php-lts-compat-audit
description: Audit a WordPress project (plugin, theme, or wp-content folder) for PHP compatibility issues against current PHP LTS versions. Finds deprecations, breaking changes, and provides a prioritized migration report. Use when the user wants to check PHP compatibility, audit for deprecations, or prepare for a PHP upgrade.
argument-hint: [target-php-version]
---

# PHP LTS Compatibility Audit

Audit a WordPress project's codebase for PHP compatibility issues against a target PHP LTS version.

## Input

`$1` is the target PHP version (e.g., `8.4`). If not provided, determine the current LTS versions in the next step.

## Steps

### 1. Determine Target PHP Version

- **Always** fetch https://www.php.net/supported-versions.php to check the current PHP supported versions.
- Identify which versions are currently in **Active Support** and **Security Fixes Only** — these are the LTS-relevant versions.
- If `$1` was provided, validate it against the supported versions list.
- If `$1` was not provided, default to the **latest Active Support** version and confirm with the user.
- Note the EOL dates for context in the report.

### 2. Identify the Project Scope

- Determine what type of WordPress project this is (plugin, theme, mu-plugin, wp-content folder, full WP install).
- Find all PHP files in the project: `**/*.php`
- Check for a `composer.json` to identify the currently declared PHP requirement (`require.php`).
- Check for any existing compatibility tools config (`.phpcs.xml`, `phpstan.neon`, etc.) that may indicate the current target PHP version.
- Identify the project's **current minimum PHP version** from any of:
  - `composer.json` `require.php`
  - Plugin/theme header `Requires PHP:`
  - `readme.txt` `Requires PHP:` field
  - Any version check code (e.g., `version_compare(PHP_VERSION, ...)`)

### 3. Audit for Compatibility Issues

Search the codebase systematically for issues in each category below. For each PHP version between the project's current minimum and the target version, check for relevant changes.

#### 3a. Removed Functions & Features
Search for usage of functions, classes, constants, and features that have been **removed** in PHP versions up to and including the target version. Examples:
- Removed functions (e.g., `utf8_encode`/`utf8_decode` removed in 8.2, `mb_strimwidth` behavioral changes)
- Removed INI directives
- Removed class methods or properties

#### 3b. Deprecated Features
Search for usage of features that are **deprecated** in the target PHP version or earlier versions leading up to it. Common areas:
- Deprecated functions (e.g., `strftime()` deprecated in 8.1)
- Deprecated syntax patterns (e.g., `${}` string interpolation deprecated in 8.2)
- Deprecated dynamic properties (PHP 8.2 — classes without `#[\AllowDynamicProperties]`)
- Deprecated calling conventions or parameter changes
- Deprecated type coercions
- Implicit nullable types (deprecated in 8.4)

#### 3c. Breaking Behavioral Changes
Search for code patterns affected by **behavioral changes** that don't produce deprecation notices but change outcomes:
- Stricter type handling in internal functions
- Changed return types of built-in functions
- Changed default parameter values
- Stricter error/exception handling (warnings promoted to errors, etc.)
- Changes to string/array/math function behaviors
- `readonly` property changes (PHP 8.2+)
- New reserved words or keywords

#### 3d. New Required Patterns
Identify places where new PHP features should or must be used:
- Enum adoption opportunities (8.1+)
- Readonly properties/classes (8.1/8.2+)
- Fibers, intersection types, never return type
- `readonly` classes (8.2+)
- New functions that replace deprecated ones

#### 3e. Extension & Dependency Changes
- Check for reliance on extensions that have been removed or unbundled
- Check `composer.json` dependencies for their own PHP version compatibility
- Identify any PECL extensions that may need updates

### 4. Classify Findings by Priority

Assign each finding a priority level:

- **CRITICAL**: Removed features, fatal errors, or code that will break immediately on the target PHP version.
- **HIGH**: Deprecated features that emit notices/warnings and will be removed in the next major version.
- **MEDIUM**: Behavioral changes that may cause subtle bugs or unexpected behavior.
- **LOW**: Style/pattern improvements to adopt new PHP features (not breaking, but recommended for forward-compatibility).

### 5. Generate the Report

Save the report as `php_compat_audit_{target-php-version}_{YYYYMMDD_HHMMSS}.md` in the project root.

The report must follow this structure:

```markdown
# PHP Compatibility Audit Report

**Project:** {project name}
**Audit Date:** {date}
**Current PHP Requirement:** {version from project metadata}
**Target PHP Version:** {target version}
**PHP Version Support Status:** {Active Support / Security Only} until {EOL date}

## Summary

- **Critical Issues:** {count}
- **High Priority:** {count}
- **Medium Priority:** {count}
- **Low Priority:** {count}
- **Total Files Scanned:** {count}
- **Files with Issues:** {count}

## Critical Issues

### {Issue Title}
- **Category:** Removed Function / Breaking Change / etc.
- **Affected Since:** PHP {version}
- **Files Affected:**
  - `path/to/file.php` (lines X, Y, Z)
- **Description:** {what the issue is}
- **Migration:**
  ```php
  // Before (incompatible)
  {old code pattern}

  // After (compatible)
  {new code pattern}
  ```
- **References:** {link to PHP RFC or migration guide}

## High Priority Issues
{same structure as above}

## Medium Priority Issues
{same structure as above}

## Low Priority Issues
{same structure as above}

## Recommended Migration Order

1. {Step-by-step migration plan, ordered by dependency and risk}

## Resources

- [PHP Migration Guides](https://www.php.net/manual/en/appendices.php)
- {version-specific migration guide links}
```

### 6. Respond with Summary

After saving the report, respond in chat with:
- A concise summary of findings (counts by priority)
- The top 3 most critical issues with brief descriptions
- The path to the full report file
- A recommended next step (e.g., "Start by addressing the {N} critical issues — they will cause fatal errors on PHP {version}")

## Important Notes

- **Do not modify any project files** — this is an audit-only skill.
- When in doubt about whether a pattern is affected, include it with a note that it should be verified.
- Always provide the specific PHP version where a deprecation/removal was introduced.
- Always include code migration examples — show before/after.
- For WordPress-specific code, be aware of WP's own PHP compatibility layer and polyfills.
- Check if WordPress core itself supports the target PHP version (ref: https://make.wordpress.org/core/handbook/references/php-compatibility-and-target-versions/).
