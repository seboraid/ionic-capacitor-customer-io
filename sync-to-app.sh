#!/bin/bash

# Quick Sync Script for Development
# Syncs plugin changes to test app without releasing to npm

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
PLUGIN_DIR="/Users/seboraid/playground/stampit/ionic-customer-io"
APP_DIR="/Users/seboraid/playground/stampit/fake-app"

print_step() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo -e "${BLUE}🔧 Quick Development Sync${NC}"
echo -e "${YELLOW}This will sync plugin changes to the test app without releasing${NC}\n"

# Build plugin
cd "$PLUGIN_DIR"
print_step "Building plugin"
npm run clean || true
npm run build
print_success "Plugin built"

# Copy to app node_modules (for quick testing)
if [[ -d "$APP_DIR" ]]; then
    print_step "Copying plugin files to app"
    
    # Remove existing plugin files
    rm -rf "$APP_DIR/node_modules/@seboraid/ionic-capacitor-customer-io"
    
    # Create directory structure
    mkdir -p "$APP_DIR/node_modules/@seboraid/ionic-capacitor-customer-io"
    
    # Copy plugin files
    cp -r "$PLUGIN_DIR/"* "$APP_DIR/node_modules/@seboraid/ionic-capacitor-customer-io/"
    
    print_success "Plugin files copied to app"
    
    # Rebuild app
    cd "$APP_DIR"
    print_step "Rebuilding app"
    npm run build
    npx cap sync
    print_success "App rebuilt with updated plugin"
    
    echo -e "\n${GREEN}🎉 Development sync completed!${NC}"
    echo -e "${YELLOW}The test app now has your latest plugin changes${NC}"
else
    print_warning "App directory not found, only built plugin"
fi