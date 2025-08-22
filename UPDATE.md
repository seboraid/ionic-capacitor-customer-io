# Release Process

This document outlines the steps to release a new version of `@seboraid/ionic-capacitor-customer-io` to both GitHub and npm.

## Prerequisites

- [ ] Ensure you have write access to the GitHub repository
- [ ] Ensure you're logged into npm with publishing permissions
- [ ] Have your npm 2FA authenticator app ready
- [ ] All changes are committed and pushed to main branch
- [ ] Tests pass and plugin builds successfully

## Release Steps

### 1. Prepare the Release

```bash
# Make sure you're on the main branch and up to date
git checkout main
git pull origin main

# Ensure the build works
npm run build

# Run any tests
npm test  # if you have tests configured
```

### 2. Update Version Number

Choose the appropriate version bump based on [Semantic Versioning](https://semver.org/):

- **Patch** (1.0.0 → 1.0.1): Bug fixes, small improvements
- **Minor** (1.0.0 → 1.1.0): New features, backward compatible
- **Major** (1.0.0 → 2.0.0): Breaking changes

```bash
# For patch version (bug fixes)
npm version patch

# For minor version (new features)
npm version minor

# For major version (breaking changes)
npm version major

# Or specify exact version
npm version 1.2.3
```

This command will:
- Update `package.json` version
- Create a git commit with the version bump
- Create a git tag

### 3. Update Changelog (Optional but Recommended)

Create or update `CHANGELOG.md` with the new version details:

```markdown
## [1.0.1] - 2024-01-15

### Added
- New feature X
- Support for Y

### Fixed
- Bug Z resolved
- Performance improvement

### Changed
- Updated dependency versions
```

### 4. Push Changes and Tags

```bash
# Push the version bump commit and tags
git push origin main --follow-tags
```

### 5. Publish to npm

```bash
# Build the latest version
npm run build

# Publish to npm (will require 2FA code)
npm publish --access public --otp=123456
```

Replace `123456` with your actual 6-digit 2FA code from your authenticator app.

### 6. Create GitHub Release

#### Option A: Via GitHub Web Interface

1. Go to https://github.com/seboraid/ionic-capacitor-customer-io/releases
2. Click "Create a new release"
3. Select the version tag (e.g., `v1.0.1`)
4. Add release title (e.g., `v1.0.1`)
5. Add release notes describing changes
6. Click "Publish release"

#### Option B: Via GitHub CLI

```bash
# Install GitHub CLI if not already installed
# brew install gh  # macOS
# gh auth login    # Login to GitHub

# Create release with auto-generated notes
gh release create v1.0.1 --generate-notes

# Or create release with custom notes
gh release create v1.0.1 --title "v1.0.1" --notes "Release notes here"
```

#### Option C: Via Git Tags (Automatic)

If you have GitHub Actions set up, you can automate releases:

```bash
# The tag was already created by npm version
# GitHub can auto-create releases from tags
```

### 7. Verify Release

- [ ] Check npm package: https://www.npmjs.com/package/@seboraid/ionic-capacitor-customer-io
- [ ] Check GitHub release: https://github.com/seboraid/ionic-capacitor-customer-io/releases
- [ ] Test installation: `npm install @seboraid/ionic-capacitor-customer-io@latest`
- [ ] Verify version: `npm view @seboraid/ionic-capacitor-customer-io version`

## Troubleshooting

### npm Publish Issues

**2FA Code Expired:**
```bash
# Get fresh code and try again
npm publish --access public --otp=654321
```

**Permission Denied:**
```bash
# Check if you're logged in
npm whoami

# Login again if needed
npm login
```

**Version Already Exists:**
```bash
# Bump version again
npm version patch
git push origin main --follow-tags
npm publish --access public --otp=123456
```

### GitHub Issues

**Tag Already Exists:**
```bash
# Delete local tag
git tag -d v1.0.1

# Delete remote tag
git push origin :refs/tags/v1.0.1

# Create new version
npm version patch
git push origin main --follow-tags
```

**Permission Denied:**
- Ensure you have write access to the repository
- Check if branch protection rules are blocking the push

## Automation (Optional)

Consider setting up GitHub Actions to automate the release process:

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags:
      - 'v*'
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'
      - run: npm ci
      - run: npm run build
      - run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: ${{ github.ref }}
          draft: false
          prerelease: false
```

## Quick Reference

```bash
# Standard release workflow
git checkout main && git pull
npm version patch
git push origin main --follow-tags
npm run build
npm publish --access public --otp=123456
gh release create $(git describe --tags --abbrev=0) --generate-notes
```

---

For questions or issues with the release process, please open an issue on GitHub.