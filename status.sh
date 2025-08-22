#!/bin/bash

# Project Status Script
# Shows current status of plugin and related repositories

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PLUGIN_DIR="/Users/seboraid/playground/stampit/ionic-customer-io"
APP_DIR="/Users/seboraid/playground/stampit/fake-app"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    Project Status                         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "${YELLOW}📋 $1${NC}"
    echo -e "${YELLOW}$(printf '%.0s─' {1..60})${NC}"
}

check_plugin_status() {
    cd "$PLUGIN_DIR"
    
    local version=$(node -p "require('./package.json').version")
    local git_status=$(git status --porcelain | wc -l | xargs)
    local branch=$(git branch --show-current)
    local last_commit=$(git log -1 --format="%h - %s (%cr)")
    
    echo -e "  • Version: ${GREEN}$version${NC}"
    echo -e "  • Branch: ${GREEN}$branch${NC}"
    if [ $git_status -eq 0 ]; then
        echo -e "  • Uncommitted changes: ${GREEN}None${NC}"
    else
        echo -e "  • Uncommitted changes: ${RED}$git_status files${NC}"
    fi
    echo -e "  • Last commit: ${BLUE}$last_commit${NC}"
    
    # Check if version is tagged
    if git tag -l | grep -q "^v$version$"; then
        echo -e "  • Git tag: ${GREEN}v$version ✅${NC}"
    else
        echo -e "  • Git tag: ${YELLOW}v$version (not created)${NC}"
    fi
    
    # Check npm status
    echo -e "  • npm status: ${BLUE}Checking...${NC}"
    local npm_version=$(npm view @seboraid/ionic-capacitor-customer-io version 2>/dev/null || echo "not-found")
    if [ "$npm_version" = "$version" ]; then
        echo -e "  • npm version: ${GREEN}$npm_version ✅ (matches)${NC}"
    elif [ "$npm_version" = "not-found" ]; then
        echo -e "  • npm version: ${RED}Not published${NC}"
    else
        echo -e "  • npm version: ${YELLOW}$npm_version (differs from local $version)${NC}"
    fi
}

check_app_status() {
    if [ ! -d "$APP_DIR" ]; then
        echo -e "  • ${RED}App directory not found${NC}"
        return
    fi
    
    cd "$APP_DIR"
    
    local plugin_version=$(node -p "require('./package.json').dependencies['@seboraid/ionic-capacitor-customer-io']" 2>/dev/null || echo "not-installed")
    local git_status=$(git status --porcelain | wc -l | xargs)
    local branch=$(git branch --show-current)
    
    if [ "$plugin_version" = "not-installed" ]; then
        echo -e "  • Plugin version: ${RED}Not installed${NC}"
    else
        echo -e "  • Plugin version: ${GREEN}$plugin_version${NC}"
    fi
    echo -e "  • Branch: ${GREEN}$branch${NC}"
    if [ $git_status -eq 0 ]; then
        echo -e "  • Uncommitted changes: ${GREEN}None${NC}"
    else
        echo -e "  • Uncommitted changes: ${YELLOW}$git_status files${NC}"
    fi
    
    # Check if app is built
    if [ -d "www" ]; then
        echo -e "  • Built: ${GREEN}Yes ✅${NC}"
    else
        echo -e "  • Built: ${RED}No (run npm run build)${NC}"
    fi
    
    # Check Capacitor sync status
    if [ -d "ios/App" ] && [ -d "android/app" ]; then
        echo -e "  • Capacitor: ${GREEN}Synced ✅${NC}"
    else
        echo -e "  • Capacitor: ${YELLOW}Not synced (run npx cap sync)${NC}"
    fi
}

check_prerequisites() {
    echo -e "  • Git config:"
    local git_user=$(git config user.name 2>/dev/null || echo "not-set")
    local git_email=$(git config user.email 2>/dev/null || echo "not-set")
    if [ "$git_user" != "not-set" ]; then
        echo -e "    - Name: ${GREEN}$git_user${NC}"
    else
        echo -e "    - Name: ${RED}Not set${NC}"
    fi
    if [ "$git_email" != "not-set" ]; then
        echo -e "    - Email: ${GREEN}$git_email${NC}"
    else
        echo -e "    - Email: ${RED}Not set${NC}"
    fi
    
    echo -e "  • npm login:"
    local npm_user=$(npm whoami 2>/dev/null || echo "not-logged-in")
    if [ "$npm_user" != "not-logged-in" ]; then
        echo -e "    - User: ${GREEN}$npm_user ✅${NC}"
    else
        echo -e "    - User: ${RED}Not logged in${NC}"
    fi
    
    echo -e "  • Scripts:"
    if [ -x "release.sh" ]; then
        echo -e "    - release.sh: ${GREEN}Executable ✅${NC}"
    else
        echo -e "    - release.sh: ${RED}Not executable${NC}"
    fi
    
    if [ -x "sync-to-app.sh" ]; then
        echo -e "    - sync-to-app.sh: ${GREEN}Executable ✅${NC}"
    else
        echo -e "    - sync-to-app.sh: ${RED}Not executable${NC}"
    fi
}

show_next_steps() {
    echo -e "${GREEN}🚀 Suggested Next Steps:${NC}\n"
    
    cd "$PLUGIN_DIR"
    local git_status=$(git status --porcelain | wc -l | xargs)
    local version=$(node -p "require('./package.json').version")
    
    if [ $git_status -gt 0 ]; then
        echo -e "  1. ${YELLOW}Commit your changes:${NC}"
        echo -e "     git add . && git commit -m 'your message'"
        echo -e ""
    fi
    
    if ! git tag -l | grep -q "^v$version$"; then
        echo -e "  2. ${YELLOW}Release new version:${NC}"
        echo -e "     ./release.sh $version"
        echo -e ""
    fi
    
    echo -e "  3. ${BLUE}Test changes quickly:${NC}"
    echo -e "     ./sync-to-app.sh"
    echo -e ""
    
    echo -e "  4. ${BLUE}Check status anytime:${NC}"
    echo -e "     ./status.sh"
}

main() {
    print_header
    
    print_section "Plugin Status"
    check_plugin_status
    echo ""
    
    print_section "Test App Status"
    check_app_status
    echo ""
    
    print_section "Prerequisites"
    check_prerequisites
    echo ""
    
    show_next_steps
}

main "$@"