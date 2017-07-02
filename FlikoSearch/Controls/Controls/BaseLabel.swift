
import UIKit

enum BaseLabelType : Int {
    
    case baseUnknownLabelType = 0
    
    case basePrimaryLargeLabelType = 1
    case basePrimaryMediumLabelType
    case basePrimarySmallLabelType
    
    case flickrLabelType
    
}

class BaseLabel: UILabel {

    @IBInspectable open var labelty: BaseLabelType = BaseLabelType.init(rawValue: 0)! {
        willSet {
            if let newShape = BaseLabelType(rawValue: labelty.rawValue ) {
                labelType = newShape
            }
        }
    }
    
    // MARK: - Attributes -
    
    var labelType : BaseLabelType = .baseUnknownLabelType
    var edgeInsets : UIEdgeInsets!
    
    
    // MARK: - Lifecycle -
    
    init(iLabelType : BaseLabelType, iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        labelType = iLabelType
        self.setCommonProperties()
        self.setlayout()
        if(iSuperView != nil){
            iSuperView?.addSubview(self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    override var canBecomeFocused : Bool {
        
        let isFirstResponder : Bool = false
        return isFirstResponder
        
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect)
        
        //super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets!))
    }
    
    override var intrinsicContentSize : CGSize {
        
        let size : CGSize = super.intrinsicContentSize
        return size
        
    }
    
    override var text: String? {
        didSet {
            
        }
    }
    
    override var isHidden: Bool {
        didSet {
            
        }
    }
    
    deinit{
        
    }
    
    // MARK: - Layout - 
    
    func setCommonProperties(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch labelType {
            
        case .basePrimaryLargeLabelType:
            
            self.font = UIFont(fontString: "AppleSDGothicNeo-Bold;15.0")
            self.textColor = UIColor(rgbValue: ColorStyle.KSecondryLabelFontColor, alpha: 1.0)
            self.textAlignment = .center
            break
            
        case .basePrimaryMediumLabelType:
            
            self.font = UIFont(fontString: "AppleSDGothicNeo-Medium;13.0")
            self.textColor = UIColor(rgbValue: ColorStyle.KSecondryLabelFontColor, alpha: 1.0)
            self.textAlignment = .center
            
            break
            
        case .basePrimarySmallLabelType:
            
            self.font = UIFont(fontString: "AppleSDGothicNeo-Regular;9.0")
            self.textColor = UIColor(rgbValue: ColorStyle.KPrimaryLabelFontColor, alpha: 1.0)
            self.textAlignment = .center
            
            break
            
        case .flickrLabelType:
            
            self.font = UIFont(fontString: "AppleSDGothicNeo-Regular;15.0")
            // self.textColor = UIColor(rgbValue: ColorConstants.KPrimaryLabelFontColor, alpha: 1.0)
            self.textColor = UIColor.gray

            
            break

        default:
            break
        }
        
    }
    
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    
    func setTextEdgeInsets(_ iEdgeInsets : UIEdgeInsets){
        edgeInsets = iEdgeInsets
    }
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
