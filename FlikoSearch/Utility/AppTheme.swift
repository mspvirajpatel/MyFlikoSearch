

import UIKit

class AppTheme: NSObject {
    
    class func getFont(fontName : String, size : CGFloat) -> UIFont{
        return UIFont(fontString: "\(fontName);\(size)")
    }
    
}

    struct FontStyle{
        static let bold = "AppleSDGothicNeo-Bold"
        static let regular = "AppleSDGothicNeo-Regular"
        static let light = ""
        static let medium = "AppleSDGothicNeo-Medium"
    }
    
    struct ColorStyle{
        
        // Basic Color
        static let white = 0xffffff
        static let black = 0x000000
        static let blue = 0x0000FF
        static let purple = 0x800080
        static let pink = 0xFFC0CB
        static let gray = 0x808080
        static let lightgray = 0xD3D3D3
        static let brown = 0xA52A2A
        static let green = 0x008000
        static let yellow = 0xFFFF00
        static let red = 0xFF0000
        
        
        // App Background Color
        static let appBG = 0x202020
        static let appSecondBG = 0x333333
        static let lightBG = 0xeeeeee
        
        static let KAppBackgroundColor = 0xf0544f // app background ..light pink
        
        // sidebarmenu
        static let sidebarmaincolor = 0x2D3238
        static let equacolorsidebar = 0x04DFD8
        static let btnheadercolor = 0x404040
        static let textcolor = 0xE9E0D6
        
        // Text Color
        static let primaryText = 0xffffff
        static let textRed = 0xc1272d
        
        // Bar Button
        static let barButtonText = 0x000000
        
        // TextField,Textview
        static let txtBorderAlpha : CGFloat = 0.5
        static let txtBorder  = 0xffffff
        static let txtInputText = 0x000000
        static let txtPlaceholder = 0x555555
        static let KTextFieldToolbarBorderAlpha : CGFloat = 0.5
        static let KPrimaryTextInputColor = 0xffffff
        static let KPrimaryTextInputFontColor = 0x000000
        static let KPrimaryTextPlaceholderColor = 0x555555
        
        // Button
        static let btnPrimaryBG =  0xECAE47
        static let btnSecondaryBG = 0x4C4C4C
        static let btnTertiarBG = 0xFF0017
        
        
        static let KPrimaryButtonColor = 0x04DFD8
        static let KPrimaryButtonFontColor = 0x000000
        static let KSecondaryButtonColor = 0x4C4C4C
        static let KSecondaryButtonFontColor = 0xffffff
        static let KTertiaryButtonColor = 0xFF0017
        static let KTertiaryButtonFontColor = 0xffffff
        static let KTransparentButtonFontColor = 0xc1272d 
        
        
        static let btnPrimaryText =  0x000000
        static let btnSecondText = 0xffffff
        static let btnTertiaryText = 0xffffff
        static let btnTransparentText = 0xc1272d
        
        // Label
        static let KPrimaryLabelFontColor = 0xffffff
        static let KSecondryLabelFontColor = 0x696969 

        
        // Facebook Text
        static let fbApp = 0x3A5B95
        static let fbText = 0xffffff
        
        //Extra
        static let KSecondaryBackgroundColor = 0x333333 // progresshud .black
        static let KAppFontColor = 0xfafafa // light white
        static let KAppFontColorAlpha : CGFloat = 0.8 // eror msg
        //static let KTextRedColor = 0x04DFD8
        static let KTextRedColor = 0xc1272d // whisper alert
        static let KLightColor = 0xeeeeee
        
        //photocollectioncel
        static let kimgUsercolor = 0xffffff
        
    }

