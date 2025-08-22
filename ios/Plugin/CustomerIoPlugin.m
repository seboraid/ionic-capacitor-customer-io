#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CustomerIoPlugin, "CustomerIo",
           CAP_PLUGIN_METHOD(initialize, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(identify, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearIdentify, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(track, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(screen, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setDeviceAttributes, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setProfileAttributes, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(registerDeviceToken, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackPushEvent, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(handlePushNotification, CAPPluginReturnPromise);
)