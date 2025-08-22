# @seboraid/ionic-capacitor-customer-io

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

### Android Configuration

Add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS Configuration

The plugin automatically configures the necessary permissions and dependencies.

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

## Support

For issues and questions:
- [GitHub Issues](https://github.com/seboraid/ionic-capacitor-customer-io/issues)
- [Customer.io Documentation](https://customer.io/docs/)