import Foundation
import Capacitor
import CioTracking
import CioMessagingPush
import CioMessagingInApp

@objc(CustomerIoPlugin)
public class CustomerIoPlugin: CAPPlugin {
    private var customerIO: CustomerIO?
    
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
        
        do {
            let cioRegion: Region = region == "EU" ? .EU : .US
            
            customerIO = CustomerIO.initialize(
                siteId: siteId,
                apiKey: apiKey,
                region: cioRegion
            ) { config in
                config.autoTrackScreenViews = autoTrackScreens
                config.backgroundQueueMinNumberOfTasks = backgroundQueueMinNumberOfTasks
                config.backgroundQueueSecondsDelay = backgroundQueueSecondsDelay
            }
            
            // Initialize push messaging
            if autoTrackPushEvents {
                MessagingPush.initialize(withConfig: MessagingPushConfigBuilder().build())
            }
            
            // Initialize in-app messaging
            MessagingInApp.initialize(
                withConfig: MessagingInAppConfigBuilder().build()
            )
            
            call.resolve()
        } catch {
            call.reject("Failed to initialize Customer.io: \(error.localizedDescription)")
        }
    }
    
    @objc func identify(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let userId = call.getString("userId") else {
            call.reject("userId is required")
            return
        }
        
        let attributes = call.getObject("attributes")
        
        if let attributes = attributes {
            customerIO.identify(userId: userId, traits: attributes)
        } else {
            customerIO.identify(userId: userId)
        }
        
        call.resolve()
    }
    
    @objc func clearIdentify(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        customerIO.clearIdentify()
        call.resolve()
    }
    
    @objc func track(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let name = call.getString("name") else {
            call.reject("name is required")
            return
        }
        
        let properties = call.getObject("properties")
        
        if let properties = properties {
            customerIO.track(name: name, properties: properties)
        } else {
            customerIO.track(name: name)
        }
        
        call.resolve()
    }
    
    @objc func screen(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let name = call.getString("name") else {
            call.reject("name is required")
            return
        }
        
        let properties = call.getObject("properties")
        
        if let properties = properties {
            customerIO.screen(name: name, properties: properties)
        } else {
            customerIO.screen(name: name)
        }
        
        call.resolve()
    }
    
    @objc func setDeviceAttributes(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let attributes = call.getObject("attributes") else {
            call.reject("attributes is required")
            return
        }
        
        customerIO.setDeviceAttributes(attributes)
        call.resolve()
    }
    
    @objc func setProfileAttributes(_ call: CAPPluginCall) {
        guard let customerIO = customerIO else {
            call.reject("Customer.io not initialized")
            return
        }
        
        guard let attributes = call.getObject("attributes") else {
            call.reject("attributes is required")
            return
        }
        
        customerIO.setProfileAttributes(attributes)
        call.resolve()
    }
    
    @objc func registerDeviceToken(_ call: CAPPluginCall) {
        guard let token = call.getString("token") else {
            call.reject("token is required")
            return
        }
        
        // Convert hex string to Data
        let tokenData = Data(hexString: token)
        MessagingPush.shared.registerDeviceToken(tokenData)
        call.resolve()
    }
    
    @objc func trackPushEvent(_ call: CAPPluginCall) {
        guard let event = call.getString("event"),
              let deliveryId = call.getString("deliveryId"),
              let deviceToken = call.getString("deviceToken") else {
            call.reject("event, deliveryId, and deviceToken are required")
            return
        }
        
        MessagingPush.shared.trackMetric(deliveryID: deliveryId, event: event, deviceToken: deviceToken)
        call.resolve()
    }
    
    @objc func handlePushNotification(_ call: CAPPluginCall) {
        guard let data = call.getObject("data") else {
            call.reject("data is required")
            return
        }
        
        let handled = MessagingPush.shared.handleNotificationReceived(userInfo: data)
        
        call.resolve([
            "handled": handled
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