// import UIKit
// import Flutter
// import GoogleMaps
// import FirebaseCore
// import FirebaseMessaging

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GMSServices.provideAPIKey("AIzaSyBVQT7eyV_TW_ZxLvkK1tfpej8UmJct3GI")
//     GeneratedPluginRegistrant.register(with: self)

//      if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//     }
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
//     override func application(_ application: UIApplication,
//                               didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
//         Messaging.messaging().apnsToken = deviceToken
//       return  super.application(application, didRegisterForRemoteNotificationsWithDeviceToken : deviceToken)
//     }
// }

import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBVQT7eyV_TW_ZxLvkK1tfpej8UmJct3GI")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      // if FirebaseApp.app() == nil {
      //     FirebaseApp.configure()
      // }

      
  if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication,
   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

   Messaging.messaging().apnsToken = deviceToken
   print("Token: \(deviceToken)")
   super.application(application,
   didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
   }
}
