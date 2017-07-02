
import UIKit
import Font_Awesome_Swift

enum BaseBarButtonItemType : Int {
    
    case baseBarUnknownButtonItemType = -1
    
    case baseBarLeftButtonItemType = 1
    case baseBarRightButtonItemType
    
    case baseBarSelectButtonItemType
    case baseBarCopyButtonItemType
    
    case baseBarPasteButtonItemType
    case baseBarDoneButtonItemType
}

class BaseBarButtonItem: UIBarButtonItem {

    // MARK: - Attributes -
    
    var buttonType : BaseBarButtonItemType = .baseBarUnknownButtonItemType
    var iconFontSize : CGFloat = 23.0
    
    var icon : FAType!
    var buttonTintColor : UIColor!
    
    var buttonEnabledTextColor : UIColor!
    var buttonDisabledTextColor : UIColor!
    
    var baseButton : BaseButton!
    
    // MARK: - Lifecycle -
    
    init(itemType : BaseBarButtonItemType) {
        super.init()
        
        buttonType = itemType
        self.setCommonProperties()
        self.setlayout()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    override var isEnabled: Bool {
        didSet {
            
            if(baseButton != nil){
             
                AppUtility.executeTaskInMainQueueWithCompletion {
                    
                    self.baseButton.titleLabel?.text = ""
                    
                    if(self.isEnabled){
                        self.baseButton.titleLabel?.textColor = self.buttonEnabledTextColor
                        
                    }else{
                        self.baseButton.titleLabel?.textColor = self.buttonDisabledTextColor
                        
                    }
                }
                
            }
            
        }
    }

    
    deinit{
        
        buttonTintColor = nil
        
        buttonEnabledTextColor = nil
        buttonDisabledTextColor = nil
        
        baseButton = nil
    }

    
    // MARK: - Layout - 
    
    func setCommonProperties(){
        
        baseButton = BaseButton(type: .custom)
        baseButton.titleLabel?.text = ""
        
        baseButton.backgroundColor = UIColor.clear
        
        buttonEnabledTextColor = UIColor(rgbValue: ColorStyle.KPrimaryButtonColor, alpha: 0.9)
        buttonDisabledTextColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
        
        baseButton.titleLabel?.textColor = buttonEnabledTextColor
        baseButton.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
        
        iconFontSize = 23.0
        
        switch buttonType {
        case .baseBarLeftButtonItemType:
            
            icon = FAType.FAChevronCircleUp
            baseButton.setFAIcon(icon: icon, iconSize: iconFontSize, forState: .normal)
             //baseButton.backgroundColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)
            
           // baseButton.setIcon(icon, iconFontSize: iconFontSize, seperator: 0)
            
            break
            
        case .baseBarRightButtonItemType:
            
            icon = FAType.FAChevronCircleDown
            baseButton.setFAIcon(icon: icon, iconSize: iconFontSize, forState: .normal)
             //baseButton.backgroundColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)

            
           // baseButton.setIcon(icon, iconFontSize: iconFontSize, seperator: 0)
            
            break
            
        case .baseBarSelectButtonItemType:
            
            icon = FAType.FAICursor
            baseButton.setIcon(icon, iconFontSize: iconFontSize, seperator: 0)
            
            break
            
        case .baseBarCopyButtonItemType:
            
            icon = FAType.FACopy
            baseButton.setIcon(icon, iconFontSize: iconFontSize - 3, seperator: 0)
            
            break
            
        case .baseBarPasteButtonItemType:
            
            icon = FAType.FAPaste
            baseButton.setIcon(icon, iconFontSize: iconFontSize - 3, seperator: 0)
            
            break
            
        case .baseBarDoneButtonItemType:
            
            baseButton.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;14")
            baseButton.backgroundColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)
            
            baseButton.setTitleColor(UIColor(rgbValue: 0x000000, alpha: 1.0), for: UIControlState())
            
            baseButton.setTitle("  Done  ", for: UIControlState())
            baseButton.setBorder(UIColor(rgbValue: ColorStyle.sidebarmaincolor), width: layoutTimeConstants.KTextControlBorderWidth, radius: 8.0)
            
            break
            
        default:
            break
        }
        
        baseButton.sizeToFit()
        self.customView = baseButton
        
//        baseButton.setButtonTouchUpInsideEvent { (sender, object) in
//            
//        }
    }
    
    func setlayout(){
        
    }
    
    
    // MARK: - Public Interface -
    
    func setTarget(_ target : AnyObject?, action: Selector){
        baseButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
