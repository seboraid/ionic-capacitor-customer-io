# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2025-08-24

### Changed
- Simplified push messaging initialization in iOS CustomerIoPlugin
- Improved error handling in native plugin implementation
- Minor code cleanup and optimization

### Technical Details
- Refactored CustomerIoPlugin.swift for cleaner push messaging setup
- Enhanced error handling patterns in iOS implementation

## [1.1.1] - 2024-08-22

### Fixed
- **CRITICAL**: Enabled `autoFetchDeviceToken(true)` in iOS MessagingPushAPN initialization
- iOS devices with granted permissions now automatically fetch device tokens
- Fixed edge case where permissions were granted but no device token was obtained
- Improved automatic device registration reliability

### Technical Details
- iOS: Updated MessagingPushAPN.initialize() to use MessagingPushConfigBuilder with autoFetchDeviceToken(true)
- Android: Already had autoFetchDeviceToken enabled (second parameter = true)
- This resolves the common issue where permissions are granted but tokens are not automatically fetched

## [1.1.0] - 2024-08-22

### Added
- Complete push notifications setup documentation in README
- Integration guide for Capacitor Push Notifications plugin
- iOS push notifications capability configuration steps
- Android push notifications permissions and Firebase setup guide
- Comprehensive push notification service examples
- Push notification listeners and handlers in example code
- Device token storage and management examples

### Fixed
- Threading issue in iOS plugin where Customer.io SDK initialization was running on background thread
- Main Thread Checker warnings for UIView and WKWebView creation
- Added DispatchQueue.main.async wrapper for all UI-related Customer.io initializations

### Changed
- Updated AndroidManifest.xml to include push notification permissions
- Enhanced example.ts with complete push notification integration
- Improved README structure with clear setup sections
- Added prerequisites section for APNs and Firebase configuration

### Technical Details
- Fixed CustomerIoPlugin.swift to ensure MessagingInApp.initialize() runs on main thread
- Added WAKE_LOCK and C2D_MESSAGE permissions for Android push notifications
- Integrated @capacitor/push-notifications plugin for cross-platform push handling

## [1.0.0] - 2024-08-22

### Added
- Initial release of Customer.io Capacitor plugin
- Support for iOS and Android platforms
- Customer.io SDK integration with native features:
  - User identification and management
  - Event and screen tracking
  - Device and profile attributes
  - Push notification token registration
  - Push notification event tracking
  - Push notification handling
- TypeScript definitions and type safety
- Comprehensive example implementation
- Basic documentation and usage guide

### Features
- Initialize Customer.io SDK with site ID and API key
- Support for US and EU regions
- Automatic screen tracking (optional)
- Automatic push event tracking (optional)
- Background queue configuration
- Cross-platform API consistency

### Dependencies
- Capacitor 6.0+
- iOS 13.0+
- Android API 22+
- Customer.io iOS SDK 2.13
- Customer.io Android SDK 3.2.1