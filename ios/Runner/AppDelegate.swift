import UIKit
import Flutter
import Firebase
import GoogleMaps
import UserNotifications
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // push Notifications
        setupPushNotification(application)
           
        // Google Api
        GMSServices.provideAPIKey(getGoogleAPIKey())

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken

        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

// Push Notifications
extension AppDelegate {
    internal func setupPushNotification(_ application: UIApplication) {
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, error in
                guard granted else {
                    return
                }
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
     
    }
}

// Google Api
extension AppDelegate {
    internal func getGoogleAPIKey() -> String {
        var dictRoot: NSDictionary?
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            dictRoot = NSDictionary(contentsOfFile: path)
        }

        if dictRoot != nil {
            let apiKey:String = dictRoot?["API_KEY"] as! String
            return apiKey;
        }

        return "";
    }
}