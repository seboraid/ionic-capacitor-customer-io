import { CustomerIo } from '@seboraid/ionic-capacitor-customer-io';

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

  // Example usage in an Ionic page
  async onPageLoad() {
    // Initialize when app starts
    await this.initializeCustomerIo();
    
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