

import UIKit

class PhotoInfo: NSObject {
    
    // MARK: - Attributes - 
    
    var id : String = ""
    var owner : String = ""
    var secret : String = ""
    var server : String = ""
    var farm : String = ""
    var title : String = ""
    var ispublic : String = ""
    var isfriend : String = ""
    var isfamily : String = ""
    
    
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
                    
                }
                else if value is NSDictionary
                {
                }
            }
        }
    }
    
    // MARK: - Internal Helpers -
    
    // MARK: - Public Method
    func getModelDictionary() -> NSMutableDictionary {
        
        let dicReturn : NSMutableDictionary = [:]
        
        let mirror = Mirror(reflecting: self)
        
        for chiled in mirror.children{
            dicReturn .setValue(AnyHashable(chiled.label!), forKey: chiled.value as! String)
        }
        
        return dicReturn
    }
    
    
    // MARK: - NSCopying Delegate Method -
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return type(of: self).init()
        
    }


    
}
