package com.sebastianperez.ioniccustomerio;

import com.getcapacitor.Bridge;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import io.customer.sdk.CustomerIO;
import io.customer.sdk.CustomerIOConfig;
import io.customer.sdk.Region;
import io.customer.messaginginapp.MessagingInApp;
import io.customer.messagingpush.MessagingPush;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.app.Application;
import android.util.Log;

@CapacitorPlugin(name = "CustomerIo")
public class CustomerIoPlugin extends Plugin {
    
    private static final String TAG = "CustomerIoPlugin";
    private CustomerIO customerIO;
    
    @Override
    public void load() {
        super.load();
        Log.d(TAG, "CustomerIo plugin loaded");
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        String siteId = call.getString("siteId");
        String apiKey = call.getString("apiKey");
        String region = call.getString("region", "US");
        Boolean autoTrackScreens = call.getBoolean("autoTrackScreens", false);
        Boolean autoTrackPushEvents = call.getBoolean("autoTrackPushEvents", true);
        Integer backgroundQueueMinNumberOfTasks = call.getInt("backgroundQueueMinNumberOfTasks", 10);
        Integer backgroundQueueSecondsDelay = call.getInt("backgroundQueueSecondsDelay", 30);

        if (siteId == null || apiKey == null) {
            call.reject("siteId and apiKey are required");
            return;
        }

        try {
            Application application = getActivity().getApplication();
            
            CustomerIOConfig.Builder configBuilder = new CustomerIOConfig.Builder(siteId, apiKey)
                .region(region.equals("EU") ? Region.EU : Region.US)
                .autoTrackScreenViews(autoTrackScreens)
                .backgroundQueueMinNumberOfTasks(backgroundQueueMinNumberOfTasks)
                .backgroundQueueSecondsDelay(backgroundQueueSecondsDelay);

            CustomerIO.initialize(application, configBuilder.build());
            
            // Initialize push messaging
            if (autoTrackPushEvents) {
                MessagingPush.INSTANCE.initialize(application, true);
            }
            
            // Initialize in-app messaging
            MessagingInApp.INSTANCE.initialize(application);
            
            customerIO = CustomerIO.instance();
            
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error initializing Customer.io", e);
            call.reject("Failed to initialize Customer.io: " + e.getMessage());
        }
    }

    @PluginMethod
    public void identify(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        String userId = call.getString("userId");
        JSObject attributes = call.getObject("attributes");

        if (userId == null) {
            call.reject("userId is required");
            return;
        }

        try {
            if (attributes != null) {
                Map<String, Object> attributeMap = jsObjectToMap(attributes);
                customerIO.identify(userId, attributeMap);
            } else {
                customerIO.identify(userId);
            }
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error identifying user", e);
            call.reject("Failed to identify user: " + e.getMessage());
        }
    }

    @PluginMethod
    public void clearIdentify(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        try {
            customerIO.clearIdentify();
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error clearing identify", e);
            call.reject("Failed to clear identify: " + e.getMessage());
        }
    }

    @PluginMethod
    public void track(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        String name = call.getString("name");
        JSObject properties = call.getObject("properties");

        if (name == null) {
            call.reject("name is required");
            return;
        }

        try {
            if (properties != null) {
                Map<String, Object> propertiesMap = jsObjectToMap(properties);
                customerIO.track(name, propertiesMap);
            } else {
                customerIO.track(name);
            }
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error tracking event", e);
            call.reject("Failed to track event: " + e.getMessage());
        }
    }

    @PluginMethod
    public void screen(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        String name = call.getString("name");
        JSObject properties = call.getObject("properties");

        if (name == null) {
            call.reject("name is required");
            return;
        }

        try {
            if (properties != null) {
                Map<String, Object> propertiesMap = jsObjectToMap(properties);
                customerIO.screen(name, propertiesMap);
            } else {
                customerIO.screen(name);
            }
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error tracking screen", e);
            call.reject("Failed to track screen: " + e.getMessage());
        }
    }

    @PluginMethod
    public void setDeviceAttributes(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        JSObject attributes = call.getObject("attributes");

        if (attributes == null) {
            call.reject("attributes is required");
            return;
        }

        try {
            Map<String, Object> attributesMap = jsObjectToMap(attributes);
            customerIO.setDeviceAttributes(attributesMap);
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error setting device attributes", e);
            call.reject("Failed to set device attributes: " + e.getMessage());
        }
    }

    @PluginMethod
    public void setProfileAttributes(PluginCall call) {
        if (customerIO == null) {
            call.reject("Customer.io not initialized");
            return;
        }

        JSObject attributes = call.getObject("attributes");

        if (attributes == null) {
            call.reject("attributes is required");
            return;
        }

        try {
            Map<String, Object> attributesMap = jsObjectToMap(attributes);
            customerIO.setProfileAttributes(attributesMap);
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error setting profile attributes", e);
            call.reject("Failed to set profile attributes: " + e.getMessage());
        }
    }

    @PluginMethod
    public void registerDeviceToken(PluginCall call) {
        String token = call.getString("token");

        if (token == null) {
            call.reject("token is required");
            return;
        }

        try {
            MessagingPush.INSTANCE.registerDeviceToken(token);
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error registering device token", e);
            call.reject("Failed to register device token: " + e.getMessage());
        }
    }

    @PluginMethod
    public void trackPushEvent(PluginCall call) {
        String event = call.getString("event");
        String deliveryId = call.getString("deliveryId");
        String deviceToken = call.getString("deviceToken");

        if (event == null || deliveryId == null || deviceToken == null) {
            call.reject("event, deliveryId, and deviceToken are required");
            return;
        }

        try {
            MessagingPush.INSTANCE.trackMetric(deliveryId, event, deviceToken);
            call.resolve();
        } catch (Exception e) {
            Log.e(TAG, "Error tracking push event", e);
            call.reject("Failed to track push event: " + e.getMessage());
        }
    }

    @PluginMethod
    public void handlePushNotification(PluginCall call) {
        JSObject data = call.getObject("data");

        if (data == null) {
            call.reject("data is required");
            return;
        }

        try {
            Map<String, String> dataMap = new HashMap<>();
            Iterator<String> keys = data.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                dataMap.put(key, data.getString(key));
            }

            boolean handled = MessagingPush.INSTANCE.handleNotificationTrigger(dataMap);
            
            JSObject result = new JSObject();
            result.put("handled", handled);
            call.resolve(result);
        } catch (Exception e) {
            Log.e(TAG, "Error handling push notification", e);
            call.reject("Failed to handle push notification: " + e.getMessage());
        }
    }

    private Map<String, Object> jsObjectToMap(JSObject jsObject) throws JSONException {
        Map<String, Object> map = new HashMap<>();
        Iterator<String> keys = jsObject.keys();
        
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = jsObject.get(key);
            
            if (value instanceof JSONObject) {
                value = jsObjectToMap(new JSObject((JSONObject) value));
            }
            
            map.put(key, value);
        }
        
        return map;
    }
}