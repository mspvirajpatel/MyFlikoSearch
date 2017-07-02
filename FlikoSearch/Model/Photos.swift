
import UIKit

class Photos: NSObject {
    
    // MARK: - Attributes -
    
    var page : String = ""
    var pages : String = ""
    var perpage : String = ""
    var total : String = ""
    var photo : [Photo] = [Photo]()
    
    
    // MARK: - Lifecycle -
    required override init() {
        super.init()
    }
    
    convenience init(responseDictionary : AnyObject)
    {
        self.init()
        self.getValuefromDictionary(responseDictionary: responseDictionary as! NSDictionary)
    }
    
    // MARK: - Public Interface -
    private func getValuefromDictionary(responseDictionary : NSDictionary)
    {
        let mirror = Mirror(reflecting: self)
        let allKey : [String] = mirror.proparty()
        
        
        for key in allKey
        {
            if let value = responseDictionary.value(forKey: key)
            {
                if value is Int
                {
                    self.setValue(String(value as! Int), forKey: key)
                }
                else if value is String
                {
                    self.setValue(value, forKey: key)
                }
                else if value is NSArray
                {
                    switch key
                    {
                    case "photo":
                        
                        for (_, value) in (value as! NSArray).enumerated() {
                            let p : Photo = Photo.init(responseDictionary: value as AnyObject)
                            self.photo.append(p)
                        }
                        break
                        
                    default:
                        break
                    }
                }
                else if value is NSDictionary
                {
                    self.setValue(value, forKey: key)
                }
            }
        }
    }
    
    // MARK: - Internal Helpers -
    
    
    // MARK: - NSCopying Delegate Method -
    func copyWithZone(zone: NSZone) -> AnyObject {
        return type(of: self).init()
    }
}
