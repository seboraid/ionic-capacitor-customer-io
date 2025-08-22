import Foundation
import Capacitor
import CioTracking
import CioMessagingPush
import CioMessagingInApp

@objc(CustomerIoPlugin)
public class CustomerIoPlugin: CAPPlugin {
    private var isInitialized: Bool = false
    
    @objc func initialize(_ call: CAPPluginCall) {
        guard let siteId = call.getString("siteId"),
              let apiKey = call.getString("apiKey") else {
            call.reject("siteId and apiKey are required")
            return
        }
        
        let region = call.getString("region") ?? "US"
        let autoTrackScreens = call.getBool("autoTrackScreens") ?? false
        let autoTrackPushEvents = call.getBool("autoTrackPushEvents") ?? true
        let backgroundQueueMinNumberOfTasks = call.getInt("backgroundQueueMinNumberOfTasks") ?? 10
        let backgroundQueueSecondsDelay = call.getDouble("backgroundQueueSecondsDelay") ?? 30.0
        
        let cioRegion: Region = region == "EU" ? .EU : .US
        
        // Ensure all UI-related initializations happen on the main thread
        DispatchQueue.main.async {
            // Initialize CustomerIO SDK
            CustomerIO.initialize(
                siteId: siteId,
                apiKey: apiKey,
                region: cioRegion
            ) { config in
                config.autoTrackScreenViews = autoTrackScreens
                config.backgroundQueueMinNumberOfTasks = backgroundQueueMinNumberOfTasks
                config.backgroundQueueSecondsDelay = backgroundQueueSecondsDelay
            }
            
            // Initialize push messaging with auto fetch device token
            if autoTrackPushEvents {
                MessagingPushAPN.initialize(
                    withConfig: MessagingPushConfigBuilder()
                        .autoFetchDeviceToken(true)
                        .build()
                )
            }
            
            // Initialize in-app messaging (this creates WKWebView internally)
            MessagingInApp.initialize()
            
            self.isInitialized = true
            call.resolve()
        }
    }
    
    @objc func identify(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let userId = call.getString("userId") else {
            call.reject("userId is required")
            return
        }
        
        let attributes = call.getObject("attributes")
        
        if let attributes = attributes {
            CustomerIO.shared.identify(identifier: userId, body: attributes)
        } else {
            CustomerIO.shared.identify(identifier: userId)
        }
        
        call.resolve()
    }
    
    @objc func clearIdentify(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        CustomerIO.shared.clearIdentify()
        call.resolve()
    }
    
    @objc func track(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let name = call.getString("name") else {
            call.reject("name is required")
            return
        }
        
        let properties = call.getObject("properties")
        
        if let properties = properties {
            CustomerIO.shared.track(name: name, data: properties)
        } else {
            CustomerIO.shared.track(name: name)
        }
        
        call.resolve()
    }
    
    @objc func screen(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let name = call.getString("name") else {
            call.reject("name is required")
            return
        }
        
        let properties = call.getObject("properties")
        
        if let properties = properties {
            CustomerIO.shared.screen(name: name, data: properties)
        } else {
            CustomerIO.shared.screen(name: name)
        }
        
        call.resolve()
    }
    
    @objc func setDeviceAttributes(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let attributes = call.getObject("attributes") else {
            call.reject("attributes is required")
            return
        }
        
        CustomerIO.shared.deviceAttributes = attributes
        call.resolve()
    }
    
    @objc func setProfileAttributes(_ call: CAPPluginCall) {
        guard isInitialized else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let attributes = call.getObject("attributes") else {
            call.reject("attributes is required")
            return
        }
        
        CustomerIO.shared.profileAttributes = attributes
        call.resolve()
    }
    
    @objc func registerDeviceToken(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            call.reject("token is required")
            return
        }
        
        MessagingPush.shared.registerDeviceToken(token)
        call.resolve()
    }
    
    @objc func trackPushEvent(_ call: CAPPluginCall) {
        guard let event = call.getString("event"),
              let deliveryId = call.getString("deliveryId"),
              let deviceToken = call.getString("deviceToken") else {
            call.reject("event, deliveryId, and deviceToken are required")
            return
        }
        
        if let metric = Metric(rawValue: event) {
            MessagingPush.shared.trackMetric(deliveryID: deliveryId, event: metric, deviceToken: deviceToken)
        }
        call.resolve()
    }
    
    @objc func handlePushNotification(_ call: CAPPluginCall) {
        guard let data = call.getObject("data") else {
            call.reject("data is required")
            return
        }
        
        // For now, we'll just return a success response as this method
        // requires UNNotificationRequest which is complex to construct from generic data
        // This would need to be handled differently in a real implementation
        call.resolve([
            "handled": true
        ])
    }
}

extension Data {
    init(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var i = hexString.startIndex
        for _ in 0..<len {
            let j = hexString.index(i, offsetBy: 2)
            let bytes = hexString[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                self.init()
                return
            }
            i = j
        }
        self = data
    }
}