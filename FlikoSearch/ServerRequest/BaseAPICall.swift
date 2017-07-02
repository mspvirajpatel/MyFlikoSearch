
import UIKit
import Alamofire

// MARK: - API Task Constant -
enum APITask : String
{
    case Login = "Login"
    case Register = "Register"
    case Logout = "Logout"
    case Footer = "Footer"
    case GetAllVehicle = "Get All Vehicle"
    case GetAllImages = "Photo List"
    case DeleteAllImages = "Delete Photo List"
    case UploadAllImages = "Upload Image"
}

class BaseAPICall: NSObject
{
    class var sharedAPICall: BaseAPICall
    {
        struct Static
        {
            static var instance: BaseAPICall?
        }
        
        let _onceToken = NSUUID().uuidString
        
        DispatchQueue.once(token: _onceToken) {
            Static.instance = BaseAPICall()
        }
       
        return Static.instance!
    }
    

    
    private func initializeRequest(apiURL : String) -> String
    {
        let urlStringWithDetails: String = apiURL
        
      //  let urlStringWithDetails: String = ServerConstants.getFullAPIPath(apiURL)
        
        return urlStringWithDetails
    }
    
    func callApiUsingPost(urlPath : String , RequestParam parameter : NSDictionary , TaskType apiType : APITask, SuccessBlock completion: @escaping (_ wasSuccessful: Bool, _ object: AnyObject) -> ()) -> Void
    {
        
        let requestURL:String = self.initializeRequest(apiURL: urlPath)
        
        let headers = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/x-www-form-urlencoded"
        ]
        
        
//      requestData.setValue(postLength, forHTTPHeaderField: "Content-Length")
//        requestData.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        
        print("---------------------");
        print("\(apiType.rawValue) request :- \(parameter .JSONString())")
        print("Request URL :- \(requestURL)")
        print("---------------------");
   
        Alamofire.request(requestURL, method:.post, parameters: parameter as? Parameters, encoding: URLEncoding(destination: .httpBody), headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result
            {
            case .success(let responseJSON):
                
                let dicResponse = responseJSON as! NSDictionary
                print("Response : \((dicResponse) .JSONString())")
               
                completion(true, dicResponse)
            
                break
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
                completion(false, error as AnyObject)
                break
            }
        })
    }
    
    func callApiUsingGet(urlPath : String , RequestParam parameter : NSDictionary , TaskType apiType : APITask, SuccessBlock completion: @escaping (_ wasSuccessful: Bool, _ object: AnyObject) -> ()) -> Void
    {
        let requestURL = self.initializeRequest(apiURL: urlPath)
        print("---------------------");
        print("\(apiType.rawValue) request :- \(parameter .JSONString())")
        print("Request URL :- \(requestURL)")
        print("---------------------");
      
        Alamofire.request(requestURL, method:.get, parameters: parameter as? Parameters, encoding: URLEncoding(destination: .httpBody), headers: [:]).responseJSON(completionHandler: { (response) in
            
            switch response.result
            {
            case .success(let responseJSON):
                
                let dicResponse = responseJSON as! NSDictionary
                print("Response : \((dicResponse) .JSONString())")
                
                completion(true, dicResponse)
            break
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
                completion(false, error as AnyObject)
                break
            }
        })
    }
    
    func callApiUsingPOST_Image (urlPath: String, RequestParam parameter : NSDictionary, withImages arrImage: NSArray, TaskType apiType : APITask , SuccessBlock completion: @escaping (_ wasSuccessful: Bool, _ object: AnyObject) -> ()) -> Void
    {
        
        let requestURL = self.initializeRequest(apiURL: urlPath)
        print("---------------------");
        print("\(apiType.rawValue) request :- \(parameter .JSONString())")
        print("Request URL :- \(requestURL)")
        print("---------------------");
        
        
        Alamofire.upload(multipartFormData: { (data) in
            
            for (key, value) in parameter {
                data.append((value as! String).data(using: .utf8)!, withName: key as! String)
                
            }
            
            for imageInfo in arrImage
            {
                let dicInfo : NSDictionary = imageInfo as! NSDictionary
                
                data.append(dicInfo["data"] as! Data, withName: dicInfo["name"] as! String, fileName: dicInfo["fileName"] as! String, mimeType: dicInfo["type"] as! String)
            }

            }, to: requestURL, method: .post , headers:nil, encodingCompletion: { (encodeResult) in
                switch encodeResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON(completionHandler: { (response) in
                        
                        switch response.result
                        {
                        case .success(let resposeData):
                            let dicResponse = resposeData as! NSDictionary
                            print("Response : \((dicResponse ) .JSONString())")
                            completion(true, dicResponse)
                            
                            break
                        case .failure(let error):
                            print(error)
                            completion(false, error as AnyObject)
                            break
                        }
                        
                    })
                    
                case .failure(let error):
                    print(error)
                    break
                }
        })
    }
}
