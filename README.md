# @seboraid/ionic-capacitor-customer-io

[![Publish Package](https://github.com/seboraid/ionic-capacitor-customer-io/actions/workflows/npm-publish.yml/badge.svg?event=status)](https://github.com/seboraid/ionic-capacitor-customer-io/actions/workflows/npm-publish.yml)

Ionic Capacitor plugin for Customer.io native SDK integration on Android and iOS platforms.

## Features

- 🚀 Initialize Customer.io SDK with site ID and API key
- 👤 User identification and management
- 📊 Event and screen tracking
- 🔔 Push notification support
- 📱 Device and profile attribute management
- 🌍 Support for US and EU regions
- 📱 Native Android and iOS integration

## Installation

```bash
npm install @seboraid/ionic-capacitor-customer-io
npx cap sync
```

## Configuration

### Basic Configuration

#### Android Configuration

Add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS Configuration

The plugin automatically configures the necessary permissions and dependencies.

## Push Notifications Setup

To enable push notifications, you need to configure both the native platforms and integrate with Capacitor's Push Notifications plugin.

### Prerequisites

1. Configure APNs certificates in your Customer.io dashboard for iOS
2. Configure Firebase/FCM keys in your Customer.io dashboard for Android

### 1. Install Capacitor Push Notifications Plugin

```bash
npm install @capacitor/push-notifications
npx cap sync
```

### 2. iOS Push Notification Configuration

#### Enable Push Notifications Capability

1. Open your project in Xcode: `npx cap open ios`
2. Select your app target
3. Go to "Signing & Capabilities" tab
4. Click "+" and add "Push Notifications" capability

#### Configure Info.plist (Optional)

Add to `ios/App/App/Info.plist` if you want to customize notification settings:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>background-processing</string>
    <string>remote-notification</string>
</array>
```

### 3. Android Push Notification Configuration

#### Add Required Permissions

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Push Notifications -->
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />

<!-- Optional: For notification icons -->
<uses-permission android:name="android.permission.VIBRATE" />
```

#### Add Firebase Configuration

1. Download `google-services.json` from your Firebase project
2. Place it in `android/app/` directory
3. The plugin will automatically handle Firebase messaging setup

### 4. Request Push Notification Permissions

Add this to your app initialization:

```typescript
import { PushNotifications } from '@capacitor/push-notifications';
import { CustomerIo } from '@seboraid/ionic-capacitor-customer-io';

export class PushNotificationService {
  
  async initializePushNotifications() {
    // Initialize Customer.io first
    await CustomerIo.initialize({
      siteId: 'your-site-id',
      apiKey: 'your-api-key',
      region: 'US',
      autoTrackPushEvents: true
    });

    // Request permissions
    const permStatus = await PushNotifications.requestPermissions();
    
    if (permStatus.receive === 'granted') {
      // Register for push notifications
      await PushNotifications.register();
    }
  }

  async setupPushListeners() {
    // Listen for registration success
    PushNotifications.addListener('registration', async (token) => {
      console.log('Push registration success, token: ' + token.value);
      
      // Register token with Customer.io
      await CustomerIo.registerDeviceToken({
        token: token.value
      });
    });

    // Listen for registration errors
    PushNotifications.addListener('registrationError', (error) => {
      console.error('Push registration error:', error.error);
    });

    // Listen for push notifications received
    PushNotifications.addListener('pushNotificationReceived', async (notification) => {
      console.log('Push notification received:', notification);
      
      // Handle the notification with Customer.io
      const result = await CustomerIo.handlePushNotification({
        data: notification.data
      });
      
      if (!result.handled) {
        // Handle custom notification logic here
        console.log('Notification not handled by Customer.io');
      }
    });

    // Listen for push notification actions (user tapped)
    PushNotifications.addListener('pushNotificationActionPerformed', async (notification) => {
      console.log('Push notification action performed:', notification);
      
      // Track push notification opened
      const deliveryId = notification.notification.data?.delivery_id;
      const deviceToken = await this.getStoredDeviceToken(); // You need to store this
      
      if (deliveryId && deviceToken) {
        await CustomerIo.trackPushEvent({
          event: 'opened',
          deliveryId: deliveryId,
          deviceToken: deviceToken
        });
      }
    });
  }

  private async getStoredDeviceToken(): Promise<string | null> {
    // Implement token storage/retrieval logic
    // You can use Capacitor Storage or Ionic Storage
    return localStorage.getItem('push_device_token');
  }
}
```

### 5. Usage in Your App

```typescript
// In your main app component or service
export class AppComponent implements OnInit {
  private pushService = new PushNotificationService();

  async ngOnInit() {
    await this.pushService.initializePushNotifications();
    await this.pushService.setupPushListeners();
  }
}
```

## Usage

### Import the Plugin

```typescript
import { CustomerIo } from '@seboraid/ionic-capacitor-customer-io';
```

### Initialize Customer.io

```typescript
await CustomerIo.initialize({
  siteId: 'your-site-id',
  apiKey: 'your-api-key',
  region: 'US', // or 'EU'
  autoTrackScreens: true,
  autoTrackPushEvents: true
});
```

### Identify a User

```typescript
await CustomerIo.identify({
  userId: 'user123',
  attributes: {
    email: 'user@example.com',
    firstName: 'John',
    lastName: 'Doe',
    plan: 'premium'
  }
});
```

### Track Events

```typescript
await CustomerIo.track({
  name: 'purchase_completed',
  properties: {
    orderId: 'order_123',
    total: 99.99,
    currency: 'USD'
  }
});
```

### Track Screen Views

```typescript
await CustomerIo.screen({
  name: 'Product Details',
  properties: {
    productId: 'prod_123',
    category: 'electronics'
  }
});
```

### Set Device Attributes

```typescript
await CustomerIo.setDeviceAttributes({
  attributes: {
    app_version: '1.0.0',
    device_model: 'iPhone 14',
    os_version: '16.0'
  }
});
```

### Set Profile Attributes

```typescript
await CustomerIo.setProfileAttributes({
  attributes: {
    subscription_status: 'active',
    last_login: new Date().toISOString()
  }
});
```

### Register for Push Notifications

```typescript
// Register device token (get this from your push notification setup)
await CustomerIo.registerDeviceToken({
  token: 'device-token-here'
});
```

### Handle Push Notifications

```typescript
// Handle incoming push notification
const result = await CustomerIo.handlePushNotification({
  data: {
    // Push notification payload
  }
});

if (result.handled) {
  console.log('Push notification was handled by Customer.io');
}
```

### Track Push Events

```typescript
await CustomerIo.trackPushEvent({
  event: 'opened', // or 'delivered'
  deliveryId: 'delivery-id-from-push',
  deviceToken: 'device-token'
});
```

### Clear User Identity

```typescript
await CustomerIo.clearIdentify();
```

## API Reference

### CustomerIoConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `siteId` | `string` | - | Your Customer.io site ID |
| `apiKey` | `string` | - | Your Customer.io API key |
| `region` | `'US' \| 'EU'` | `'US'` | Customer.io region |
| `autoTrackScreens` | `boolean` | `false` | Enable automatic screen tracking |
| `autoTrackPushEvents` | `boolean` | `true` | Enable automatic push event tracking |
| `backgroundQueueMinNumberOfTasks` | `number` | `10` | Minimum tasks before queue processing |
| `backgroundQueueSecondsDelay` | `number` | `30` | Delay in seconds before queue processing |

### Methods

- `initialize(options: CustomerIoConfig): Promise<void>`
- `identify(options: IdentifyOptions): Promise<void>`
- `clearIdentify(): Promise<void>`
- `track(options: TrackEventOptions): Promise<void>`
- `screen(options: TrackScreenOptions): Promise<void>`
- `setDeviceAttributes(options: DeviceAttributesOptions): Promise<void>`
- `setProfileAttributes(options: ProfileAttributesOptions): Promise<void>`
- `registerDeviceToken(options: RegisterDeviceTokenOptions): Promise<void>`
- `trackPushEvent(options: TrackPushEventOptions): Promise<void>`
- `handlePushNotification(options: PushNotificationOptions): Promise<HandlePushResult>`

## Requirements

- Capacitor 6.0+
- iOS 13.0+
- Android API 22+

## Customer.io SDK Versions

- Android: Customer.io Android SDK 3.2.1
- iOS: Customer.io iOS SDK 2.13

## License

MIT

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Development Scripts

This plugin includes automated scripts to streamline development and release workflows.

### 🚀 Release Script (`release.sh`)

Automates the complete release process: version bump, git tag, npm publish, and test app update.

```bash
# Interactive mode (will prompt for version)
./release.sh

# Direct version specification
./release.sh 1.2.3

# Show help
./release.sh --help
```

**What it does:**
1. ✅ Validates git working tree is clean
2. ✅ Updates `package.json` version
3. ✅ Builds the plugin
4. ✅ Runs tests (if available)
5. ✅ Commits changes with standardized message
6. ✅ Creates git tag
7. ✅ Pushes to GitHub
8. ✅ Publishes to npm (with 2FA support)
9. ✅ Updates plugin in test app
10. ✅ Rebuilds test app with new plugin

### 🔧 Development Sync Script (`sync-to-app.sh`)

Quick development workflow for testing changes without releasing to npm.

```bash
./sync-to-app.sh
```

**What it does:**
1. ✅ Builds the plugin
2. ✅ Copies built files directly to test app's node_modules
3. ✅ Rebuilds test app with changes
4. ✅ Perfect for rapid iteration during development

### Prerequisites for Release Script

Before using the release script, ensure:

- [x] **Git configured**: Committer name and email set
- [x] **npm login**: Authenticated with npm (`npm whoami` should work)  
- [x] **2FA setup**: npm 2FA enabled and authenticator app ready
- [x] **GitHub access**: SSH keys configured for pushing
- [x] **Clean working tree**: All changes committed

### Example Workflow

```bash
# 1. Make changes to plugin code
vim ios/Plugin/CustomerIoPlugin.swift

# 2. Test changes quickly
./sync-to-app.sh

# 3. Test on device/simulator...

# 4. When ready to release
./release.sh 1.1.2
```

## Support

For issues and questions:
- [GitHub Issues](https://github.com/seboraid/ionic-capacitor-customer-io/issues)
- [Customer.io Documentation](https://customer.io/docs/)