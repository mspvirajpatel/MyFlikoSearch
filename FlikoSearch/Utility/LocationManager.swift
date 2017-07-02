
import UIKit
import CoreLocation
import Whisper

class LocationManager: NSObject, CLLocationManagerDelegate {

        enum Result {
            case Success(LocationManager)
            case Failure(Error)
        }
        
        static let shared: LocationManager = LocationManager()
        
        typealias Callback = (Result) -> Void
        
        var requests: Array <Callback> = Array <Callback>()
        
        var location: CLLocation? { return sharedLocationManager.location  }
        
        lazy var sharedLocationManager: CLLocationManager = {
            let newLocationmanager = CLLocationManager()
            newLocationmanager.delegate = self
            newLocationmanager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;  //new
            newLocationmanager.distanceFilter = 10; // meters  //new
            newLocationmanager.startMonitoringSignificantLocationChanges()
            // ...
            return newLocationmanager
        }()
        
        // MARK: - Authorization
        
        class func authorize() { shared.authorize() }
        func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
        
        // MARK: - Helpers
        
        func locate(callback: @escaping Callback) {
            self.requests.append(callback)
            sharedLocationManager.startUpdatingLocation()
        }
        
        func reset() {
            self.requests = Array <Callback>()
            //sharedLocationManager.stopUpdatingLocation()
        }
        
        // MARK: - Delegate
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            for request in self.requests { request(.Failure(error)) }
         
            AppUtility.showWhisperAlert(message: InfoErrorMessageConstants.KNoCurrentLocation, duration: 1.0)
            self.reset()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
            for request in self.requests { request(.Success(self)) }
           
            let location :CLLocation  = locations.last!
            let eventDate :NSDate = location.timestamp as NSDate
            
            let howRecent:TimeInterval = eventDate.timeIntervalSinceNow
            
            if (abs(howRecent) < 15.0) {
                // If the event is recent, do something with it.
                NSLog("latitude %+.6f, longitude %+.6f\n",
                       location.coordinate.latitude,
                       location.coordinate.longitude);
//                let cord = "\(location.coordinate.latitude);\(location.coordinate.longitude)"

//                let notification = UILocalNotification()
//                notification.alertBody = "Significant new location \(cord)"
//                notification.fireDate = NSDate(timeIntervalSinceNow: 10)
//                notification.timeZone = NSTimeZone.defaultTimeZone()
//                notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//                UIApplication.sharedApplication().scheduleLocalNotification(notification)

            }
            self.reset()
        }
    
    
}
