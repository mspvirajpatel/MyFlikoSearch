

import UIKit

class Photo: NSObject {
    
    // MARK: - Attributes -
    
    var id : String = ""
    var ownername : String = ""
    var url_s : String = ""
    var url_q : String = ""
    var url_m : String = ""
    var url_n : String = ""
    var url_z : String = ""
    var url_l : String = ""
    var url_o : String = ""
    var url_sq : String = ""
    var url_t : String = ""
    var url_c : String = ""
    var height_sq : String = ""
    var width_sq : String = ""
    var height_t : String = ""
    var width_t : String = ""
    var height_s : String = ""
    var width_s : String = ""
    var height_q : String = ""
    var width_q : String = ""
    var height_m : String = ""
    var width_m : String = ""
    var height_n : String = ""
    var width_n : String = ""
    var height_z : String = ""
    var width_z : String = ""
    var height_c: String = ""
    var width_c :String = ""
    var height_l : String = ""
    var width_l : String = ""
    var height_o : String = ""
    var width_o : String = ""
    var title : String = ""
    var dateupload : String = ""
    var lastupdate : String = ""
    var datetaken : String = ""
    var views : String = ""
    var tags : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var location : NSDictionary = [:]
    var farm : String = ""
    var owner : String = ""
    var server : String = ""
    var descriptionn : NSDictionary = [:]
    var placeholderImage : UIImage? = nil
    
    
    
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
    private func getValuefromDictionary(responseDictionary : NSDictionary) {
        let mirror = Mirror(reflecting: self)
        let allKey : [String] = mirror.proparty()
        
        for key in allKey {
            //print(allKey)
            
            //self.setValue(value, forKey: "descriptionn")
            
            if let value = responseDictionary.value(forKey: key)
            {
                if value is Int {
                    print(value)
                    self.setValue(String(value as! Int), forKey: key)
                }
                else if value is String {
                    self.setValue(value, forKey: key)
                }
                else if value is NSArray {
                    self.setValue(value, forKey: key)
                }
                else if value is NSDictionary
                {
//                    print(value)
//                    if key == "descriptionn"
//                    {
//                      self.setValue(value, forKey: "description")
//                        
//                    }
                    
                    //self.setValue(value, forKey: key)
                }
                
            }
            
            if let value = responseDictionary.value(forKey:"description")
            {
                self.setValue(value, forKey: "descriptionn")
                print(descriptionn)
                
            }
            
            
        }
        
       
    }
    
    // MARK: - Internal Helpers -
    
    
    
    // MARK: - NSCopying Delegate Method -
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return type(of: self).init()
        
    }
    
    
}
