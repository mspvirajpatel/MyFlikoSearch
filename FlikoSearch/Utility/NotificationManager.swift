
import Foundation
import SystemConfiguration
import UserNotifications

struct PushNotificationType : OptionSet {
    
    let rawValue: Int
    
    static let InvalidNotificationType = PushNotificationType(rawValue: -1)
    static let HomeNotificationType = PushNotificationType(rawValue: 1)
    static let OtherNotificationType = PushNotificationType(rawValue: 2)
    
}

open class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Attributes -
    
    var KReloadKeyboard:String = "KReloadKeyboard"
    var KSuccessGoogleLogin:String = "KSuccessGoogleLogin"
    var KunSuccessGoogleLogin:String = "KunSuccessGoogleLogin"

    let reachability = Reachability()!
    
   // MARK: - Lifecycle -
    
    static let sharedInstance : NotificationManager = {
        
        let instance = NotificationManager()
        return instance
        
    }()
    
    deinit{
        
    }
    
    // MARK: - Public Interface -
    
    open func isNetworkAvailableWithBlock(_ completion: @escaping (_ wasSuccessful: Bool) -> Void) {
        
  //      reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
  //          DispatchQueue.main.async {
   //             if reachability.isReachableViaWiFi {
//                 completion(true)
  //                  print("Reachable via WiFi")
  //              } else {
  //                  completion(true)
  //                  print("Reachable via Cellular")
   //             }
   //
  //          }
  //      }
   //     reachability.whenUnreachable = { reachability in
   //         // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
   //         DispatchQueue.main.async {
   //             completion(false)
   //             print("Not reachable")
   //         }
   //     }
        
   //     do {
   //         try reachability.startNotifier()
   //        completion(true)
   //     } catch {
   //         completion(false)
   //         print("Unable to start notifier")
   //     }
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            completion(false)
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        completion(isReachable && !needsConnection )
        
    }
    
    
    // MARK: - Internal Helpers -

    open func reloadKeyboard(_ isSet: Bool) {
        
        var userInfo: [String: Bool]? = nil
        
        userInfo = ["user": isSet]
        
        let notification = Notification.init(name: Notification.Name(rawValue: KReloadKeyboard), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func successfullyGoogleLogin(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["googleUserData": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: KSuccessGoogleLogin), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    open func unSucessGoogleLogin(_ isSet: Bool) {
        
        var userInfo: [String: Bool]? = nil
        
        userInfo = ["user": isSet]
        
        let notification = Notification.init(name: Notification.Name(rawValue: KunSuccessGoogleLogin), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    func setPushNotificationEnabled(_ isEnabled: Bool) {
        
        let application = UIApplication.shared
        
        if isEnabled {
            
            if #available(iOS 10, *) {
                
                //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
                
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    
                    guard error == nil else {
                        //Display Error.. Handle Error.. etc..
                        return
                    }
                    
                    if granted {
                        //Do stuff here..
                    }
                    else {
                        //Handle user denying permissions..
                    }
                }
                
            }
            else {
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }
            
            
//            if application.responds(to: #selector(UIApplication.registerUserNotificationSettings)) {
//
//                var userNotificationTypes: UIUserNotificationType
//                var settings: UIUserNotificationSettings?
//                userNotificationTypes = ([UIUserNotificationType.alert, UIUserNotificationType.sound,UIUserNotificationType.badge])
//                settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
//                application.registerUserNotificationSettings(settings!)
//            }
          
            //push notitification connection
            NSLog("Connected.")
        }
        else {
            if application.isRegisteredForRemoteNotifications {
                application.unregisterForRemoteNotifications()
                
            }
            //push notitification connection disconnect Code
            NSLog("Disconnected.")
            
        }
    }
    
//    func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
//       
//        var notificationStatusType = PushNotificationType.InvalidNotificationType
//     
//        var alertMessage: String? = nil
//        var statusCode: String? = nil
//     
//        if  let data = (userInfo as NSDictionary).object(forKey: "aps") as? NSDictionary
//        {
//            alertMessage = (data as NSDictionary).object(forKey: "alert") as? String
//            
//        }
//        
//        if  let data = (userInfo as NSDictionary).object(forKey: "statusCode") as? String
//        {
//            statusCode = data
//        }
//        
//        let detailsDictionary = [AnyHashable: Any]()
//        let appDelegate = AppUtility.getAppDelegate()
//        let appState = UIApplication.shared.applicationState
//        
//        if statusCode != nil {
//            
//            if (statusCode! == "1") {
//                notificationStatusType = PushNotificationType.HomeNotificationType
//                if appState == .inactive {
//                    NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//                }
//                else if appState == .active && alertMessage != nil {
//                    
//                    appDelegate.displayPushNotificationWithTitle("Home", message: alertMessage!, callback: {() -> Void in
//                        NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//                    })
//                }
//            }
//            else if (statusCode! == "2") {
//                notificationStatusType = PushNotificationType.OtherNotificationType
//                if appState == .inactive {
//                    NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//                }
//                else if appState == .active && alertMessage != nil {
//                    
//                    appDelegate.displayPushNotificationWithTitle("Other", message: alertMessage!, callback: {() -> Void in
//                        NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//                    })
//                }
//            }
//          
//            
//        }
//        else
//        {
//            notificationStatusType = PushNotificationType.HomeNotificationType
//            if appState == .inactive {
//                NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//            }
//            else if appState == .active && alertMessage != nil {
//                
//                appDelegate.displayPushNotificationWithTitle("New", message: alertMessage!, callback: {() -> Void in
//                    NotificationManager().displayControllerFromPushNotificationStatusType(notificationStatusType, withDetails: detailsDictionary as AnyObject)
//                })
//            }
//            
//        }
//    }
//    
//    func displayControllerFromPushNotificationStatusType(_ iType: PushNotificationType, withDetails details: AnyObject) {
//        
//        let appDelegate = AppUtility.getAppDelegate()
//        
//        if(appDelegate.navigationController != nil){
//            
//            appDelegate.displayControllerFromPushNotificationType(iType, withDetails: details)
//            
//        }
//    }
    
//    func setSelectedMenuViewType(_ selectedMenuViewType: LeftMenu.RawValue) {
//        let appDelegate = AppUtility.getAppDelegate()
//        if appDelegate.slidemenuController != nil {
//            let mainMenuViewController:LeftMenuController = (appDelegate.slidemenuController?.menuViewController as! LeftMenuController)
//            mainMenuViewController.displaySelectedMenuItem(selectedMenuViewType)
//       
//        }
//    }
    
//    In case if you need to know the permissions granted
//    
//    UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
//    
//    switch setttings.soundSetting{
//    case .enabled:
//    
//    print("enabled sound setting")
//    
//    case .disabled:
//    
//    print("setting has been disabled")
//    
//    case .notSupported:
//    print("something vital went wrong here")
//    }
//    }
    
}
