# Release Guidelines

## Versioning

Follow [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH` (e.g., 1.2.3)
- **MAJOR** — breaking changes
- **MINOR** — new features, backwards compatible
- **PATCH** — bug fixes

Until 1.0.0, breaking changes can happen in MINOR versions.

## Tag Format

Use `v` prefix: `v0.1.0`, `v1.0.0`, `v2.3.1`

Pre-releases: `v0.2.0-beta.1`

## Release Notes Template

```markdown
# Orient UI vX.X.X

Brief one-liner about this release.

## Added
- `ComponentName` — short description

## Changed
- What changed and why

## Fixed
- Bug that was fixed

## Removed
- What was removed (if any)

## Breaking
- ⚠️ Describe breaking changes clearly

## Links

- [Live Demo](https://widgets.userorient.com)
- [Pub.dev](https://pub.dev/packages/orient_ui)

---

Built by [@kamranbekirovyz](https://x.com/kamranbekirovyz) at [UserOrient](https://userorient.com)
```

## Checklist Before Release

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run tests: `flutter test`
4. Publish to pub.dev: `dart pub publish`
5. Create GitHub release with tag `vX.X.X`
6. Announce on X/Twitter

## First Release Example

For initial releases, use announcement style:

```markdown
# Orient UI v0.1.0

First public release!

## Components
- `Button` — 6 variants
- `Spinner` — loading indicator
- ...

## CLI
- `orient_ui init`
- `orient_ui add <widget>`
```

## Patch Release Example

```markdown
# Orient UI v0.1.1

## Fixed
- Button focus state on web (#12)
- Toast dismiss animation (#15)
```

## Minor Release Example

```markdown
# Orient UI v0.2.0

## Added
- `TextField` component
- `Checkbox` component

## Changed
- Button now supports `loading` state
```
