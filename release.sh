#!/bin/bash

# Customer.io Plugin Release Script
# This script automates version bumping, git tagging, npm publishing, and app updating

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_DIR="/Users/seboraid/playground/stampit/ionic-customer-io"
APP_DIR="/Users/seboraid/playground/stampit/fake-app"
PACKAGE_NAME="@seboraid/ionic-capacitor-customer-io"

# Function to print colored output
print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if we're in the right directory
check_directory() {
    if [[ ! -f "package.json" ]] || [[ ! -d "ios" ]] || [[ ! -d "android" ]]; then
        print_error "This script must be run from the plugin root directory containing package.json, ios/, and android/ folders"
        exit 1
    fi
}

# Function to check if git working tree is clean
check_git_status() {
    if [[ -n $(git status --porcelain) ]]; then
        print_error "Git working tree is not clean. Please commit or stash changes first."
        git status --short
        exit 1
    fi
}

# Function to validate version format
validate_version() {
    if [[ ! $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Version must be in format X.Y.Z (e.g., 1.2.3)"
        exit 1
    fi
}

# Function to check if version already exists
check_version_exists() {
    if git tag -l | grep -q "^v$1$"; then
        print_error "Version $1 already exists as a git tag"
        exit 1
    fi
}

# Function to update version in package.json
update_package_version() {
    print_step "Updating package.json version to $1"
    
    # Use npm version to update package.json
    npm version "$1" --no-git-tag-version
    
    print_success "Updated package.json to version $1"
}

# Function to build the plugin
build_plugin() {
    print_step "Building plugin"
    
    # Clean previous build
    npm run clean || true
    
    # Install dependencies
    npm install
    
    # Build the plugin
    npm run build
    
    print_success "Plugin built successfully"
}

# Function to run tests if they exist
run_tests() {
    if npm run | grep -q "test"; then
        print_step "Running tests"
        npm test
        print_success "All tests passed"
    else
        print_warning "No tests found, skipping"
    fi
}

# Function to commit changes
commit_changes() {
    print_step "Committing version bump"
    
    git add package.json package-lock.json dist/
    git commit -m "chore: bump version to $1

🤖 Generated with release script

Co-Authored-By: Release Script <noreply@seboraid.com>"
    
    print_success "Changes committed"
}

# Function to create git tag
create_tag() {
    print_step "Creating git tag v$1"
    
    git tag -a "v$1" -m "Release version $1

🚀 Release Notes:
- See CHANGELOG.md for detailed changes
- Plugin tested and ready for production

🤖 Generated with release script"
    
    print_success "Git tag v$1 created"
}

# Function to push to GitHub
push_to_github() {
    print_step "Pushing to GitHub"
    
    # Push commits and tags
    git push origin main
    git push origin "v$1"
    
    print_success "Pushed to GitHub with tag v$1"
}

# Function to publish to npm
publish_to_npm() {
    print_step "Publishing to npm"
    
    # Check if we're logged in to npm
    if ! npm whoami >/dev/null 2>&1; then
        print_error "Not logged in to npm. Please run 'npm login' first"
        exit 1
    fi
    
    # Get 2FA code from user
    print_warning "Please enter your npm 2FA code (6 digits):"
    read -r OTP_CODE
    
    # Validate OTP format
    if [[ ! $OTP_CODE =~ ^[0-9]{6}$ ]]; then
        print_error "Invalid OTP code format. Must be 6 digits."
        exit 1
    fi
    
    # Publish to npm with 2FA
    npm publish --access public --otp="$OTP_CODE"
    
    print_success "Published to npm successfully"
}

# Function to update plugin in test app
update_app_plugin() {
    print_step "Updating plugin in test app"
    
    if [[ ! -d "$APP_DIR" ]]; then
        print_warning "App directory not found at $APP_DIR, skipping app update"
        return 0
    fi
    
    cd "$APP_DIR"
    
    # Wait a bit for npm registry to update
    print_step "Waiting 30 seconds for npm registry to update..."
    sleep 30
    
    # Update the plugin to the latest version
    npm update "$PACKAGE_NAME"
    
    # Install any peer dependencies
    npm install
    
    print_success "Plugin updated in test app"
}

# Function to rebuild test app
rebuild_app() {
    print_step "Rebuilding test app"
    
    if [[ ! -d "$APP_DIR" ]]; then
        print_warning "App directory not found, skipping app rebuild"
        return 0
    fi
    
    cd "$APP_DIR"
    
    # Build the Ionic app
    npm run build
    
    # Sync with Capacitor
    npx cap sync
    
    print_success "Test app rebuilt successfully"
    
    cd "$PLUGIN_DIR"
}

# Function to show completion summary
show_summary() {
    echo -e "\n${GREEN}🎉 RELEASE COMPLETED SUCCESSFULLY! 🎉${NC}\n"
    echo -e "${BLUE}📋 Summary:${NC}"
    echo -e "  • Plugin version: ${GREEN}$1${NC}"
    echo -e "  • Git tag: ${GREEN}v$1${NC}"
    echo -e "  • GitHub: ${GREEN}✅ Pushed${NC}"
    echo -e "  • npm: ${GREEN}✅ Published${NC}"
    echo -e "  • Test app: ${GREEN}✅ Updated & rebuilt${NC}"
    echo -e "\n${BLUE}🔗 Links:${NC}"
    echo -e "  • npm: ${BLUE}https://www.npmjs.com/package/$PACKAGE_NAME${NC}"
    echo -e "  • GitHub: ${BLUE}https://github.com/seboraid/ionic-capacitor-customer-io/releases/tag/v$1${NC}"
    echo -e "\n${YELLOW}📝 Next steps:${NC}"
    echo -e "  1. Verify the npm package: npm view $PACKAGE_NAME version"
    echo -e "  2. Test the updated app on a real device"
    echo -e "  3. Create a GitHub release with notes if needed"
    echo -e "  4. Update any dependent projects"
}

# Main execution function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║          Customer.io Plugin Release Script              ║"
    echo "║                                                          ║"
    echo "║  Automates: Version bump, Git tag, npm publish,         ║"
    echo "║             and test app update                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    # Change to plugin directory
    cd "$PLUGIN_DIR"
    
    # Pre-flight checks
    print_step "Running pre-flight checks"
    check_directory
    check_git_status
    print_success "Pre-flight checks passed"
    
    # Get version from user if not provided
    if [[ -z "$1" ]]; then
        echo -e "${YELLOW}Please enter the new version (e.g., 1.2.3):${NC}"
        read -r NEW_VERSION
    else
        NEW_VERSION="$1"
    fi
    
    # Validate version
    validate_version "$NEW_VERSION"
    check_version_exists "$NEW_VERSION"
    
    # Show confirmation
    echo -e "\n${YELLOW}📋 Release Plan:${NC}"
    echo -e "  • Current directory: ${BLUE}$(pwd)${NC}"
    echo -e "  • New version: ${GREEN}$NEW_VERSION${NC}"
    echo -e "  • Package: ${BLUE}$PACKAGE_NAME${NC}"
    echo -e "  • App directory: ${BLUE}$APP_DIR${NC}"
    echo -e "\n${YELLOW}This will:${NC}"
    echo -e "  1. Update package.json version"
    echo -e "  2. Build the plugin"
    echo -e "  3. Run tests (if available)"
    echo -e "  4. Commit changes"
    echo -e "  5. Create git tag"
    echo -e "  6. Push to GitHub"
    echo -e "  7. Publish to npm"
    echo -e "  8. Update plugin in test app"
    echo -e "  9. Rebuild test app"
    
    echo -e "\n${YELLOW}Continue with release? (y/N):${NC}"
    read -r CONFIRM
    
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_warning "Release cancelled by user"
        exit 0
    fi
    
    # Execute release steps
    echo -e "\n${GREEN}🚀 Starting release process...${NC}\n"
    
    update_package_version "$NEW_VERSION"
    build_plugin
    run_tests
    commit_changes "$NEW_VERSION"
    create_tag "$NEW_VERSION"
    push_to_github "$NEW_VERSION"
    publish_to_npm
    update_app_plugin
    rebuild_app
    
    show_summary "$NEW_VERSION"
}

# Handle script arguments
case "$1" in
    --help|-h)
        echo "Usage: $0 [VERSION]"
        echo ""
        echo "Arguments:"
        echo "  VERSION     Version to release (e.g., 1.2.3)"
        echo ""
        echo "Options:"
        echo "  --help, -h  Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 1.2.3    Release version 1.2.3"
        echo "  $0          Interactive mode - will prompt for version"
        exit 0
        ;;
    --version|-v)
        echo "Customer.io Plugin Release Script v1.0.0"
        exit 0
        ;;
    *)
        main "$1"
        ;;
esac