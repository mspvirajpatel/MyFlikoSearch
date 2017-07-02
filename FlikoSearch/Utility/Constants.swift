

import Foundation
import UIKit

//  MARK: - System Oriented Constants -

struct SystemConstants {
    
    static let KShowlayoutArea = true
    static let KHidelayoutArea = false
    static let KShowVersionNumber = 1
    
    static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    static let IS_DEBUG = false
}

//  MARK: - APIKey Constants -

struct APIKeyConstants {
    
    
}

//  MARK: - Server Constants -

struct ServerConstants {
    
    
}

struct PlistName {
    static let sidbarlist = "MainMenu"
     static let favlist = "FavPlace"
}

//  MARK: - layoutTime Constants -

struct layoutTimeConstants {
    
    static let KControlName : String = "ControlName" // baseview
    static let KControlBorderRadius : CGFloat = 3.0 // button,textfield,textview
    
    static let KTextControlBorderWidth : CGFloat = 1.5 // barbutton,textfield,textview
    static let KTextControlBorderRadius : CGFloat = 2.5 // textfield,textview
    
    static let KTextLeftPaddingFromControl : CGFloat = 10.0 // textfield
    
    
    static let KControlLeftRightPadding : CGFloat = 10.0
    static let KControlTopBottomPadding : CGFloat = 10.0
    static let KControlLeftRightSecondaryPadding : CGFloat = 15.0
    static let KControlTopBottomSecondaryPadding : CGFloat = 15.0
    
    
    static let kpreviewviewipadheight = 70
    static let kpreviewviewiphoneheight = 130
    static let kpreviewbtnheightipad = 45
    static let kpreviewbtnheightiphone = 35
    
    //previewcell
    
    static let kpreviewbuttonheightwidthipad = 55
    static let kpreviewbuttonheightwidthiphone = 45


    
    
    //sidebar
    static let ksidebaruserimagecornerradius = 30
    static let KtopPading : CGFloat = 20
    static let Kleftpading : CGFloat = 20
    static let KheaderWidthheight : CGFloat = 70
    static let klblToppading : CGFloat = 10
    static let Klblheight : CGFloat = 30
    static let Klblwidth : CGFloat = 150
    static let KtblViewcellheight : CGFloat = 48
    static let KleftCellImgWidthheight : CGFloat = 15
    static let KleftcellTopbotoompading : CGFloat = 30
    static let kbtnheaderleftrightpadding : CGFloat = 15
    static let kbtnheadertoppading : CGFloat = 5
    static let kbtnheaderhight : CGFloat = 30
    static let kimguserheightwidth : CGFloat = 60
    static let klblusertoppading : CGFloat = 27
    static let kleftcellleftrightpadding : CGFloat = 15
    static let kleftcellheightrow : CGFloat = 40
    static let kleftmenuheaderheight : CGFloat = 30
    
    // search
    
    static let searchtoppading = 70
    static let kbtbnsearchheightwidth = 35
    static let ksearchrightpading = 10
    static let kstaticsearchtop = 5
    
    //photocollectioncell
    
    static let KButtonHeightWidthipad = 45
    static let KButtonHeightWidthiphone = 35
    static let imgUsercornerradius = 10
    
     static let collectionlinespacing = 10
    
    static let KTopBotomPadding : CGFloat = 10
    static let KleftRightpading : CGFloat = 20
    static let KFloatingButtonHeight : CGFloat = 50
    static let KcellimageCornerradius : CGFloat = 30
     static let KleftRightpadinggg : CGFloat = 20
    
    
    // popup
    
    static let kpopupipadheight = 45
    static let kpopupiphoneheight = 40
    static let kpopupiphonewidth = 145

    
    // popover constant
    
    static let favpopoverwidth = 100
    static let favpopoverheight = 40
    static let favpopoveripadwidth = 170
    static let favpopoveripadheight = 45
    
    //mycollection
    static let kmycollectionpreviewheightipad = 80
    static let kmycollectionpreviewheightiphone = 50


    
    
}

struct InstaLayout
{
    
}

struct Flicker_Data
{
    static let KBaseUrl = " https://api.flickr.com/services/rest/?"
    //static let KApi_Key = "dc1e01af4b9b3b58b1d9ec1cdf036350"
    //static let KSecret_key = "ec9a40ba40b1cdb1"
    //static let KApi_Key = "ab38704cd4319e9a01df29fcbbb07f33"
    //static let KSecret_key = "d69f3658655b4666"
    static let KApi_Key = "bac876a44fc161391bcbc7c951c21cca"
    static let KSecret_key = "8d43b6603f13f7d4"
    static let KBasemethod = "flickr.photos.search"
    static let KEndBaseUrl = "format=json&nojsoncallback=1"
    
    //static let buddyiconuser = "http://farm{icon-farm}.staticflickr.com/{icon-server}/buddyicons/{nsid}.jpg"
    
}

struct plistfilename {
   
}


//  MARK: - Cell Identifier Constants -

struct CellIdentifierConstants {
    
    static let kleftmenucell = "LeftMenuCell"
    static let userimagescell = "UserimagesCell"
    static let photocolectionView = "Photocollectioncell"
    static let KLiveFeedcellIdentifier = "LivefeedCollectioncell"
    static let aboutcellIdentifier = "AboutusCell"
    static let popupmenutableviewcell = "popupCell"
    static let PreviewColectionView = "PreviewCell"
    
}

struct InAddvertise
{
    
    //    static let KAddFullscreen = "ca6"
    //    static let KAddBannerViewhome = "c11"
    //    static let KAddbannerViewDetail = "ca1"
    //    static let KAddBannerViewfav = "ca-11"
    //    static let KgoogleaddId = "ca-a613"
    
    static let KAddFullscreen = "ca-app-pub-7409730219034199/4700929012"        //...///
    static let KAddBannerViewhome = "ca-app-pub-7409730219034199/3750526611"
    static let KAddbannerViewDetail = "ca-app-pub-7409730219034199/8320327011"
    static let KAddBannerViewfav = "ca-app-pub-7409730219034199/9797060211"
    static let KgoogleaddId = "ca-app-pub-7409730219034199~9689531816"
    static let kaddbannerlivefeed = "ca-app-pub-7409730219034199/1747462611"   ////
    static let kaddbanersearch = "ca-app-pub-7409730219034199/3224195810"     /////
    static let kaddbannerfavplace = "ca-app-pub-7409730219034199/9410330219"   //....//
    static let kaddbanermaplist = "ca-app-pub-7409730219034199/9549931013"
    static let kaddphotodetail = "ca-app-pub-7409730219034199/8073197816"
    
}

//  MARK: - Info / Error Message Constants -

struct InfoErrorMessageConstants {
    
    static let KNoInternetMessage = "⚠️ Internet connection is not available."
    static let KNoCurrentLocation = "⚠️ Unable to find current location."
    static let KNoCameraAvailable = "⚠️ Camera is not available in device."
    
}
struct UserDefaultKey
{
    static let KRegisterOtp             = "registerOtp"
    static let KAccessToken             = "token"
    static let KUserId                  = "userId"
    static let KEmailId                 = "emailId"
    static let KPassword                = "password"
    static let KMobileNo                = "mobileNo"
    static let KFirstName               = "firstName"
    static let KpictureUrl              = "pictureUrl"
    static let KIsLinkedIn              = "IsLinkedIn"
    static let KFirebaseToken     =   "FirebaseToken"
    
}

struct ControlerName
{
    static let home = "Home"
    
}
struct is_Device {
    static let _iPhone = (UIDevice.current.model as NSString).isEqual(to: "iPhone") ? true : false
    static let _iPad = (UIDevice.current.model as NSString).isEqual(to: "iPad") ? true : false
    static let _iPod = (UIDevice.current.model as NSString).isEqual(to: "iPod touch") ? true : false
}

