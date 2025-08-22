import { WebPlugin } from '@capacitor/core';

import type {
  CustomerIoPlugin,
  CustomerIoConfig,
  IdentifyOptions,
  TrackEventOptions,
  TrackScreenOptions,
  DeviceAttributesOptions,
  ProfileAttributesOptions,
  RegisterDeviceTokenOptions,
  TrackPushEventOptions,
  PushNotificationOptions,
  HandlePushResult,
} from './definitions';

export class CustomerIoWeb extends WebPlugin implements CustomerIoPlugin {
  async initialize(options: CustomerIoConfig): Promise<void> {
    console.log('CustomerIo Web: initialize called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async identify(options: IdentifyOptions): Promise<void> {
    console.log('CustomerIo Web: identify called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async clearIdentify(): Promise<void> {
    console.log('CustomerIo Web: clearIdentify called');
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async track(options: TrackEventOptions): Promise<void> {
    console.log('CustomerIo Web: track called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async screen(options: TrackScreenOptions): Promise<void> {
    console.log('CustomerIo Web: screen called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async setDeviceAttributes(options: DeviceAttributesOptions): Promise<void> {
    console.log('CustomerIo Web: setDeviceAttributes called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async setProfileAttributes(options: ProfileAttributesOptions): Promise<void> {
    console.log('CustomerIo Web: setProfileAttributes called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async registerDeviceToken(options: RegisterDeviceTokenOptions): Promise<void> {
    console.log('CustomerIo Web: registerDeviceToken called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async trackPushEvent(options: TrackPushEventOptions): Promise<void> {
    console.log('CustomerIo Web: trackPushEvent called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }

  async handlePushNotification(options: PushNotificationOptions): Promise<HandlePushResult> {
    console.log('CustomerIo Web: handlePushNotification called', options);
    throw new Error('Customer.io web implementation not available. Use native platforms.');
  }
}