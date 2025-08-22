import { CustomerIo } from '@seboraid/ionic-capacitor-customer-io';
import { PushNotifications } from '@capacitor/push-notifications';

export class CustomerIoExample {
  
  async initializeCustomerIo() {
    try {
      await CustomerIo.initialize({
        siteId: 'your-site-id',
        apiKey: 'your-api-key',
        region: 'US',
        autoTrackScreens: true,
        autoTrackPushEvents: true,
        backgroundQueueMinNumberOfTasks: 10,
        backgroundQueueSecondsDelay: 30
      });
      console.log('Customer.io initialized successfully');
    } catch (error) {
      console.error('Failed to initialize Customer.io:', error);
    }
  }

  async identifyUser() {
    try {
      await CustomerIo.identify({
        userId: 'user_12345',
        attributes: {
          email: 'john.doe@example.com',
          firstName: 'John',
          lastName: 'Doe',
          plan: 'premium',
          signupDate: new Date().toISOString(),
          isActive: true
        }
      });
      console.log('User identified successfully');
    } catch (error) {
      console.error('Failed to identify user:', error);
    }
  }

  async trackPurchaseEvent() {
    try {
      await CustomerIo.track({
        name: 'purchase_completed',
        properties: {
          orderId: 'order_67890',
          total: 149.99,
          currency: 'USD',
          items: [
            { id: 'item_1', name: 'Premium Plan', price: 149.99 }
          ],
          paymentMethod: 'credit_card',
          timestamp: new Date().toISOString()
        }
      });
      console.log('Purchase event tracked successfully');
    } catch (error) {
      console.error('Failed to track purchase event:', error);
    }
  }

  async trackScreenView() {
    try {
      await CustomerIo.screen({
        name: 'Product Catalog',
        properties: {
          category: 'electronics',
          numberOfItems: 25,
          sortBy: 'price',
          filterApplied: 'brand:apple'
        }
      });
      console.log('Screen view tracked successfully');
    } catch (error) {
      console.error('Failed to track screen view:', error);
    }
  }

  async updateDeviceAttributes() {
    try {
      await CustomerIo.setDeviceAttributes({
        attributes: {
          app_version: '2.1.0',
          device_model: 'iPhone 14 Pro',
          os_version: '16.1',
          language: 'en',
          timezone: 'America/New_York',
          push_enabled: true
        }
      });
      console.log('Device attributes updated successfully');
    } catch (error) {
      console.error('Failed to update device attributes:', error);
    }
  }

  async updateUserProfile() {
    try {
      await CustomerIo.setProfileAttributes({
        attributes: {
          subscription_status: 'active',
          last_login: new Date().toISOString(),
          preferences: {
            newsletter: true,
            push_notifications: true,
            sms: false
          },
          loyalty_points: 1250
        }
      });
      console.log('User profile updated successfully');
    } catch (error) {
      console.error('Failed to update user profile:', error);
    }
  }

  async registerForPushNotifications(deviceToken: string) {
    try {
      await CustomerIo.registerDeviceToken({
        token: deviceToken
      });
      console.log('Device registered for push notifications');
    } catch (error) {
      console.error('Failed to register device token:', error);
    }
  }

  async handleIncomingPush(pushData: any) {
    try {
      const result = await CustomerIo.handlePushNotification({
        data: pushData
      });
      
      if (result.handled) {
        console.log('Push notification handled by Customer.io');
      } else {
        console.log('Push notification not handled by Customer.io - handle manually');
        // Handle the push notification in your app
        this.handleCustomPushNotification(pushData);
      }
    } catch (error) {
      console.error('Failed to handle push notification:', error);
    }
  }

  async trackPushOpened(deliveryId: string, deviceToken: string) {
    try {
      await CustomerIo.trackPushEvent({
        event: 'opened',
        deliveryId: deliveryId,
        deviceToken: deviceToken
      });
      console.log('Push open event tracked');
    } catch (error) {
      console.error('Failed to track push open event:', error);
    }
  }

  async logoutUser() {
    try {
      await CustomerIo.clearIdentify();
      console.log('User logged out and identity cleared');
    } catch (error) {
      console.error('Failed to clear user identity:', error);
    }
  }

  private handleCustomPushNotification(pushData: any) {
    // Implement your custom push notification handling logic here
    console.log('Handling custom push notification:', pushData);
  }

  // Push Notifications Setup
  async initializePushNotifications() {
    try {
      // Initialize Customer.io first
      await this.initializeCustomerIo();

      // Request push notification permissions
      const permStatus = await PushNotifications.requestPermissions();
      
      if (permStatus.receive === 'granted') {
        // Register for push notifications
        await PushNotifications.register();
        console.log('Push notifications registered successfully');
        
        // Setup listeners
        await this.setupPushListeners();
      } else {
        console.log('Push notification permissions not granted');
      }
    } catch (error) {
      console.error('Failed to initialize push notifications:', error);
    }
  }

  async setupPushListeners() {
    // Listen for registration success
    PushNotifications.addListener('registration', async (token) => {
      console.log('Push registration success, token: ' + token.value);
      
      // Store token for later use
      localStorage.setItem('push_device_token', token.value);
      
      // Register token with Customer.io
      await this.registerForPushNotifications(token.value);
    });

    // Listen for registration errors
    PushNotifications.addListener('registrationError', (error) => {
      console.error('Push registration error:', error.error);
    });

    // Listen for push notifications received (app in foreground)
    PushNotifications.addListener('pushNotificationReceived', async (notification) => {
      console.log('Push notification received:', notification);
      
      // Handle the notification with Customer.io
      const result = await CustomerIo.handlePushNotification({
        data: notification.data
      });
      
      if (!result.handled) {
        // Handle custom notification logic here
        console.log('Notification not handled by Customer.io, handling manually');
        this.handleCustomPushNotification(notification);
      }
    });

    // Listen for push notification actions (user tapped notification)
    PushNotifications.addListener('pushNotificationActionPerformed', async (notification) => {
      console.log('Push notification action performed:', notification);
      
      // Track push notification opened
      const deliveryId = notification.notification.data?.delivery_id;
      const deviceToken = localStorage.getItem('push_device_token');
      
      if (deliveryId && deviceToken) {
        await this.trackPushOpened(deliveryId, deviceToken);
      }
      
      // Handle the tap action (e.g., navigate to specific screen)
      this.handlePushNotificationTap(notification.notification.data);
    });
  }

  private handlePushNotificationTap(data: any) {
    // Implement navigation or action based on notification data
    console.log('Handling push notification tap with data:', data);
    
    // Example: Navigate to specific page based on notification data
    if (data?.screen) {
      // Navigate to screen specified in push data
      // this.router.navigate([data.screen]);
    }
  }

  // Example usage in an Ionic page
  async onPageLoad() {
    // Initialize when app starts (including push notifications)
    await this.initializePushNotifications();
    
    // Identify user after login
    await this.identifyUser();
    
    // Track screen view
    await this.trackScreenView();
    
    // Update device attributes
    await this.updateDeviceAttributes();
  }

  async onUserAction() {
    // Track user events
    await this.trackPurchaseEvent();
    
    // Update profile
    await this.updateUserProfile();
  }

  async onAppBackground() {
    // Any cleanup or final tracking before app goes to background
    console.log('App going to background - Customer.io tracking will continue');
  }
}