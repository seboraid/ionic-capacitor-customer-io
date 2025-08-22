export interface CustomerIoPlugin {
  /**
   * Initialize the Customer.io SDK with configuration
   * @param options Configuration options for Customer.io
   */
  initialize(options: CustomerIoConfig): Promise<void>;

  /**
   * Identify a user with Customer.io
   * @param options User identification options
   */
  identify(options: IdentifyOptions): Promise<void>;

  /**
   * Clear user identification
   */
  clearIdentify(): Promise<void>;

  /**
   * Track an event
   * @param options Event tracking options
   */
  track(options: TrackEventOptions): Promise<void>;

  /**
   * Track a screen view
   * @param options Screen tracking options
   */
  screen(options: TrackScreenOptions): Promise<void>;

  /**
   * Set device attributes
   * @param options Device attributes
   */
  setDeviceAttributes(options: DeviceAttributesOptions): Promise<void>;

  /**
   * Set profile attributes for the identified user
   * @param options Profile attributes
   */
  setProfileAttributes(options: ProfileAttributesOptions): Promise<void>;

  /**
   * Register device for push notifications
   * @param options Push notification registration options
   */
  registerDeviceToken(options: RegisterDeviceTokenOptions): Promise<void>;

  /**
   * Track push notification events
   * @param options Push notification event options
   */
  trackPushEvent(options: TrackPushEventOptions): Promise<void>;

  /**
   * Handle incoming push notification data
   * @param options Push notification data
   */
  handlePushNotification(options: PushNotificationOptions): Promise<HandlePushResult>;
}

export interface CustomerIoConfig {
  /**
   * Your Customer.io site ID
   */
  siteId: string;
  
  /**
   * Your Customer.io API key
   */
  apiKey: string;
  
  /**
   * Customer.io region (US or EU)
   */
  region?: 'US' | 'EU';
  
  /**
   * Enable automatic screen tracking
   */
  autoTrackScreens?: boolean;
  
  /**
   * Enable automatic push notification handling
   */
  autoTrackPushEvents?: boolean;
  
  /**
   * Background queue minimum number of tasks
   */
  backgroundQueueMinNumberOfTasks?: number;
  
  /**
   * Background queue seconds delay
   */
  backgroundQueueSecondsDelay?: number;
}

export interface IdentifyOptions {
  /**
   * Unique identifier for the user
   */
  userId: string;
  
  /**
   * Additional attributes for the user
   */
  attributes?: { [key: string]: any };
}

export interface TrackEventOptions {
  /**
   * Name of the event to track
   */
  name: string;
  
  /**
   * Additional properties for the event
   */
  properties?: { [key: string]: any };
}

export interface TrackScreenOptions {
  /**
   * Name of the screen
   */
  name: string;
  
  /**
   * Additional properties for the screen
   */
  properties?: { [key: string]: any };
}

export interface DeviceAttributesOptions {
  /**
   * Device attributes to set
   */
  attributes: { [key: string]: any };
}

export interface ProfileAttributesOptions {
  /**
   * Profile attributes to set
   */
  attributes: { [key: string]: any };
}

export interface RegisterDeviceTokenOptions {
  /**
   * Device token for push notifications
   */
  token: string;
}

export interface TrackPushEventOptions {
  /**
   * Event name (e.g., 'opened', 'delivered')
   */
  event: string;
  
  /**
   * Delivery ID from the push notification
   */
  deliveryId: string;
  
  /**
   * Device token
   */
  deviceToken: string;
}

export interface PushNotificationOptions {
  /**
   * Push notification data payload
   */
  data: { [key: string]: any };
}

export interface HandlePushResult {
  /**
   * Whether the push was handled by Customer.io
   */
  handled: boolean;
}