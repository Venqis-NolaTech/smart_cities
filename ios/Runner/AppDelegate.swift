import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey(getGoogleAPIKey())
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }

    func getGoogleAPIKey() -> String {
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
