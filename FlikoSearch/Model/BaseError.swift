
import Foundation
import Whisper

class BaseError: NSObject {

    // MARK: - Attributes -

    var errorCode: String = ""
    var serverMessage: String = ""
    var alertMessage: String = ""

    // MARK: - Lifecycle -
    
    deinit{
        
    }
    
    // MARK: - Public Interface -
    
    class func getError(requestObject object: AnyObject, responseObject: AnyObject , task : APITask) -> BaseError{
        
        let error: BaseError = BaseError()
        
        print(responseObject)
        print(responseObject["meta"])
        let dictmeta : NSDictionary = responseObject["meta"] as! NSDictionary!
        
        //print(responseObject["code"])

        if let code = dictmeta["code"] as? Int
        {
            error.errorCode = String(code)
        }
        else{
             error.errorCode = (dictmeta["code"] as? String)!
        }
        
        if(error.errorCode == ""){
            error.errorCode = "1";
        }
        
        if let code = dictmeta["error_message"] as? String
        {
            error.serverMessage = String(code)
        }
        else{
            error.serverMessage = ""
        }
        
        error.alertMessage = error.serverMessage;


        let showerror = Murmur(title: error.serverMessage, backgroundColor: UIColor(rgbValue: ColorStyle.KAppFontColor,alpha: 1.0), titleColor: UIColor(rgbValue: ColorStyle.KTextRedColor, alpha: 1.0), font: UIFont(fontString: "AppleSDGothicNeo-Bold;11.0"))

        if (error.errorCode == "201")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "400")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "401")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "404")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "409")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "500")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "422")
        {
            show(whistle : showerror)
        }
        else if (error.errorCode == "403")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "8")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "7")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "4")
        {
            show(whistle: showerror)

        }
        else if (error.errorCode == "3")
        {
             show(whistle: showerror)
        }
        else if (error.errorCode == "2")
        {
             show(whistle: showerror)
        }
        else if (error.errorCode == "1")
        {
            show(whistle: showerror)
        }
        else if (error.errorCode == "200")
        {
//             show(whistle: showerror)
        }
      
        hide(whistleAfter: 1.0)
      
        print("---------------------");
        print("Request Type: %@", task.rawValue);
        print("Error Code: %@", error.errorCode);
        print("Server Message: %@", error.serverMessage);
        
        print("Alert Message: %@", error.alertMessage);
        print("---------------------");
        
        return error
    }
    
    // MARK: - Internal Helpers -
    
}
