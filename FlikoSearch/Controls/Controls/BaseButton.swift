
import UIKit
import Font_Awesome_Swift

enum BaseButtonType : Int {
    
    case baseUnknownButtonType = -1
    
    case basePrimaryButtonType = 1
    case baseSecondaryButtonType
    case baseTertiaryButtonType
    case baseRadioButtonType
    case baseRoundedCloseButtonType
    case baseCloseButtonType
    
    case baseTransparentButtonType
    case checkBoxButtonType
    case baseDropDownButtonType
    case basePhotoIconButtonType
    case baseCameraButtonType
    case baseGalleryButtonType
    case baseArrowButtonType
    case baseCellButtonType
    case baseImagePickerButtonType
    case baseFullDropButtonType
    
    case btnclearcolorType
    case baseBackButtonType
    
}

class BaseButton: UIButton {
    
    static var KDefaultButtonHeight : CGFloat = 35.0
    static var KCloseButtonWidth : CGFloat = 22.0
    
    // MARK: - Attributes -
    
    var baseButtonType : BaseButtonType = .baseUnknownButtonType
    var baseLayout : MyViewBaseLayout!
    
    var finalAttributedString : NSMutableAttributedString!
    var baseLineOffsetArray : [CGFloat]!
    
    var originalBackgroundColor : UIColor!
    var highlightBackgroundColor : UIColor!
    
    var touchUpInsideEvent : ControlTouchUpInsideEvent!
    
    // MARK: - For Radio Button
    
    fileprivate var circleLayer = CAShapeLayer()
    fileprivate var fillCircleLayer = CAShapeLayer()
    override var isSelected: Bool {
        didSet {
            toggleButon()
        }
    }
    /**
     Color of the radio button circle. Default value is UIColor red.
     */
    @IBInspectable var circleColor: UIColor = UIColor.red {
        didSet {
            circleLayer.strokeColor = circleColor.cgColor
            self.toggleButon()
        }
    }
    /**
     Radius of RadioButton circle.
     */
    @IBInspectable var circleRadius: CGFloat = 5.0
    @IBInspectable var cornerRadius2: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = 0 + circleLayer.lineWidth
        circleFrame.origin.y = bounds.height/2 - circleFrame.height/2
        return circleFrame
    }

    
    /**
     Toggles selected state of the button.
     */
    func toggleButon() {
        if self.isSelected {
            fillCircleLayer.fillColor = circleColor.cgColor
        } else {
            fillCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    fileprivate func fillCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: 2, dy: 2))
    }

    
    // MARK: - Lifecycle -
    
    init(type : UIButtonType) {
        super.init(frame: CGRect.zero)
        
    }
    
    init(ibuttonType : BaseButtonType, iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        baseButtonType = ibuttonType
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView?.addSubview(self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    deinit{
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        switch baseButtonType {
            
        case .basePrimaryButtonType:
            
            break
            
        case .baseSecondaryButtonType:
            
            break
            
        case .baseTertiaryButtonType:
            
            break
            
        case .btnclearcolorType:
            
            break
            
        case .baseRadioButtonType:
            circleLayer.frame = bounds
            circleLayer.path = circlePath().cgPath
            fillCircleLayer.frame = bounds
            fillCircleLayer.path = fillCirclePath().cgPath
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
            
            break
        default:
            
            break
            
        }
        
    }
    
    // MARK: - Layout - 
    
    func setCommonProperties() {
        
        self.isExclusiveTouch = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch baseButtonType {
            
        case .basePrimaryButtonType:
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.KPrimaryButtonColor, alpha: 1.0)
            
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KPrimaryButtonFontColor, alpha: 1.0), for: UIControlState())
            
            self.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;14")
            
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            
            self.setBorder(UIColor(rgbValue: ColorStyle.KPrimaryButtonFontColor, alpha: 1.0), width: 1.5, radius: layoutTimeConstants.KControlBorderRadius)
            
            break
            
        case .btnclearcolorType :
            self.backgroundColor = UIColor.clear
            
            break
            
        case .baseSecondaryButtonType:
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.KSecondaryButtonColor, alpha: 1.0)
            
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KSecondaryButtonFontColor, alpha: 1.0), for: UIControlState())
            
            self.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;14")
            
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            
            self.setBorder(UIColor(rgbValue: ColorStyle.KSecondaryButtonColor, alpha: 1.0), width: 1.5, radius: layoutTimeConstants.KControlBorderRadius)
            
            break
            
        case .baseTertiaryButtonType:
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.KTertiaryButtonColor, alpha: 1.0)
            
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KTertiaryButtonFontColor, alpha: 1.0), for: UIControlState())
            
            self.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;14")
            
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            
            self.setBorder(UIColor(rgbValue: ColorStyle.KTertiaryButtonColor, alpha: 1.0), width: 1.5, radius: layoutTimeConstants.KControlBorderRadius)
            
            break
            
        case .baseTransparentButtonType:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KTransparentButtonFontColor, alpha: 1.0), for: .normal)
            self.titleLabel?.font = is_Device._iPad ? UIFont(fontString: "AppleSDGothicNeo-Bold;16.0") : UIFont(fontString: "AppleSDGothicNeo-Bold;14.0")
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            break;
            
    
        case .baseRadioButtonType:
            circleLayer.frame = bounds
            circleLayer.lineWidth = 2
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = circleColor.cgColor
            layer.addSublayer(circleLayer)
            fillCircleLayer.frame = bounds
            fillCircleLayer.lineWidth = 2
            fillCircleLayer.fillColor = UIColor.clear.cgColor
            fillCircleLayer.strokeColor = UIColor.clear.cgColor
            layer.addSublayer(fillCircleLayer)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
            self.toggleButon()
            self.setTitleColor(UIColor(rgbValue: ColorStyle.fbText, alpha: 1.0), for: UIControlState())
            self.circleColor = UIColor(rgbValue: ColorStyle.KPrimaryButtonColor, alpha: 1.0)
            self.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;14")
            self.contentHorizontalAlignment = .left
            self.circleRadius = 10.0
            
            break
            
        case .baseRoundedCloseButtonType:
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.KPrimaryButtonColor, alpha: 1.0)
            
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KPrimaryButtonFontColor, alpha: 1.0), for: .normal)
            
            self.titleLabel?.font = is_Device._iPad ? UIFont(fontString: "AppleSDGothicNeo-Bold;16.0") : UIFont(fontString: "AppleSDGothicNeo-Bold;14.0")
            
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            
            self.setBorder(UIColor(rgbValue: ColorStyle.KPrimaryButtonFontColor, alpha: 1.0), width: 1.0, radius: layoutTimeConstants.KControlBorderRadius)
            
            
            break;
            
        case .checkBoxButtonType:
            self.backgroundColor = UIColor(rgbValue: ColorStyle.fbText, alpha: 1.0)
            self.setImage(UIImage(named: ""), for: UIControlState.normal)
            self.setImage(UIImage(named: ""), for: UIControlState.highlighted)
            self.layer.borderColor = UIColor(rgbValue: ColorStyle.KTransparentButtonFontColor, alpha: 1.0).cgColor
            self.layer.borderWidth = 1.0
            self.setImage(UIImage(named: "CheckMark"), for: UIControlState.selected)
            break;
            
        case .basePhotoIconButtonType:
            
            self.setTitle("Hello", for: UIControlState.normal)
            
            break
            
        case .baseCloseButtonType :
            
            self.backgroundColor = UIColor.clear
            self.setImage(UIImage(named: "Close"), for: UIControlState.normal)
            self.setImage(UIImage(named: "Close"), for: UIControlState.highlighted)
            self.layer.cornerRadius = 20.0
            self.clipsToBounds = true
            break

        case .baseImagePickerButtonType:
            
            self.backgroundColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
            self.setImage(UIImage(named: "ImageIcon"), for: .normal)
            self.setImage(UIImage(named: "ImageIcon"), for: .highlighted)
            
            break
            
        case .baseDropDownButtonType:
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.fbText, alpha: 1.0)
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KPrimaryTextInputFontColor, alpha: 1.0), for: .normal)
            self.titleLabel?.font = UIFont(fontString: "AppleSDGothicNeo-Bold;13")
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 10, 0, 35)
            self.contentHorizontalAlignment = .left
            break
            
        case .baseCameraButtonType:
            
            self.backgroundColor = UIColor.clear
            self.setImage(UIImage(named: "CameraIcon"), for: UIControlState.normal)
            self.setImage(UIImage(named: "CameraIcon"), for: UIControlState.highlighted)
            
            break
            
        case .baseGalleryButtonType:
            
            self.backgroundColor = UIColor.white
            self.setImage(UIImage(named: "GalleryIcon"), for: UIControlState.normal)
            self.setImage(UIImage(named: "GalleryIcon"), for: UIControlState.highlighted)
            self.layer.cornerRadius = 25.0
            self.clipsToBounds = true
            break

        case .baseArrowButtonType :
            
            self.backgroundColor = UIColor.clear
            
            self.setFAIcon(icon: FAType.FAChevronDown, iconSize: 20.0, forState: UIControlState.selected)
            self.setFAIcon(icon: FAType.FAChevronRight, iconSize: 20.0, forState: UIControlState.normal)
            self.setFATitleColor(color: UIColor.black)
            self.clipsToBounds = true
            
            break
            
        case .baseFullDropButtonType :
            
            self.backgroundColor = UIColor(rgbValue: ColorStyle.KPrimaryButtonColor, alpha: 1.0)
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KPrimaryButtonFontColor, alpha: 1.0), for: .normal)
            self.setTitleColor(UIColor(rgbValue: ColorStyle.KSecondaryButtonFontColor, alpha: 1.0), for: .selected)
            self.titleLabel?.font = is_Device._iPad ? UIFont(fontString: "AppleSDGothicNeo-Bold;20.0") : UIFont(fontString: "AppleSDGothicNeo-Bold;25.0")
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            
            break
            
        case .baseBackButtonType :
            
            self.backgroundColor = UIColor.clear
            self.setBackgroundImage(UIImage(named : "crossButton"), for: UIControlState.normal)
            
            break

            
        default:
            
            break
            
        }
        
        originalBackgroundColor = self.backgroundColor
        if originalBackgroundColor != nil
        {
            highlightBackgroundColor = originalBackgroundColor.darkerColorForColor()
        }
        
        self.addTarget(self, action: #selector(buttonTouchUpInsideAction), for: .touchUpInside)
        
        self.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchUpOutside)
        
        self.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchCancel)
        
        self.addTarget(self, action: #selector(buttonTouchDownAction), for: .touchDown)
        
    }
    
    func setlayout(){
        
        baseLayout = MyViewBaseLayout()
        
        baseLayout.viewDictionary = ["button" : self]
        var buttonHeight : CGFloat = 0.0
        
        switch baseButtonType {
            
        case .basePrimaryButtonType,
             .baseSecondaryButtonType,
             .baseTertiaryButtonType,
             .baseDropDownButtonType:
            
            buttonHeight = BaseButton.KDefaultButtonHeight
            
            break
            
        case .baseTransparentButtonType:
            
            buttonHeight = 20.0
            break
        case .checkBoxButtonType :
            
            buttonHeight = 30.0
            break
            
        case .baseRoundedCloseButtonType:
            buttonHeight = 30.0
            break
            
        case .basePhotoIconButtonType :
            buttonHeight = 30.0
            break
            
        case .baseCameraButtonType , .baseGalleryButtonType:
            buttonHeight = 50.0
            break
        case .baseCloseButtonType:
            buttonHeight = is_Device._iPad ? 60.0 : 40.0
            break
            
        case .baseArrowButtonType :
            buttonHeight = 30.0
            break
            
        case .baseRadioButtonType :
            buttonHeight = 40.0
            break
            
        case .baseFullDropButtonType :
            buttonHeight = 60.0
            break
            
        case .baseBackButtonType :
            buttonHeight = 45.0
            break
            
        default:
            break
        }
        
        switch baseButtonType {
            
        case .basePrimaryButtonType,
             .baseSecondaryButtonType,
             .baseTertiaryButtonType,
            .baseFullDropButtonType:
            baseLayout.metrics = ["buttonHeight" : buttonHeight]
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            self.addConstraints(baseLayout.control_H)
            
            break
            
        case .baseDropDownButtonType :
            
            let dropDownIcon : UILabel = UILabel()
            dropDownIcon .font = UIFont(fontString: "AppleSDGothicNeo-Bold;13.0")
            dropDownIcon .setFAIcon(icon: FAType.FAChevronDown, iconSize: 20.0)
            dropDownIcon .setFAColor(color: UIColor(rgbValue: ColorStyle.KPrimaryTextInputFontColor, alpha: 1.0))
            dropDownIcon.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(dropDownIcon)
            
            baseLayout.viewDictionary = ["button" : self , "dropDownIcon" : dropDownIcon]
            baseLayout.metrics = ["buttonHeight" : buttonHeight , "iconSize" : 20.0 ]
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            
            
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[dropDownIcon]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            baseLayout.position_Right = NSLayoutConstraint(item: dropDownIcon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)
            
            baseLayout.size_Width = NSLayoutConstraint(item: dropDownIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 20.0)
            
            self.addConstraint(baseLayout.size_Width)
            self.addConstraints(baseLayout.control_V)
            self.addConstraint(baseLayout.position_Right)
            
            break
            
        case .checkBoxButtonType:
            
            baseLayout.metrics = ["buttonHeight" : buttonHeight]
            
//            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
           // self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            
            break
            
        case .baseRoundedCloseButtonType , .basePhotoIconButtonType , .baseCloseButtonType:
            
            baseLayout.metrics = ["buttonHeight" : buttonHeight]
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            
            break
            
        case .baseCameraButtonType , .baseGalleryButtonType , .baseArrowButtonType,.baseBackButtonType:
            
            baseLayout.metrics = ["buttonHeight" : buttonHeight]
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            
            break
            
            
//        case .baseRadioButtonType:
//            baseLayout.metrics = ["buttonHeight" : buttonHeight as AnyObject]
//            
//            //            baseLayout.control_H = NSLayoutConstraint.constraintsWithVisualFormat("H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//            
//            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//            
//            // self.addConstraints(baseLayout.control_H)
//            self.addConstraints(baseLayout.control_V)
//            
//            break
    
        default:
            
            break
            
        }

    }
    
    // MARK: - Public Interface -
    
    func setButtonTouchUpInsideEvent(_ event : @escaping ControlTouchUpInsideEvent) {
       
        originalBackgroundColor = self.backgroundColor
        touchUpInsideEvent = event
        
    }
    
    func setIcon(_ icon : FAType, iconFontSize : CGFloat, seperator : Int){
        
        if(baseLineOffsetArray == nil){
            baseLineOffsetArray = [0.7, 0.0];
        }
        
        self.setAttributedTitle(nil, for: UIControlState())
        
        var spaceString : String? = ""
        for _ in 0...(seperator) {
            spaceString = spaceString! + " "
        }
        
        finalAttributedString = nil
        finalAttributedString = NSMutableAttributedString()
        
        var textAttributeDictionary : [String : AnyObject]?
        
        var titleAttributedString : NSAttributedString?
        
        var iconStringColor : UIColor? = self.titleLabel!.textColor
        var titleStringColor : UIColor? = self.titleLabel!.textColor
        
//        FontLoader.loadFontIfNeeded()
//        let awesomeFont = UIFont(name: A.FontName, size: iconFontSize)
//        assert(awesomeFont != nil, FAStruct.ErrorAnnounce)
        
        let regularFont : UIFont = (self.titleLabel?.font)!
       // var iconString : String? = icon
        
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        textAttributeDictionary = [NSForegroundColorAttributeName : iconStringColor!,
                                   NSParagraphStyleAttributeName : paragraphStyle,
                                   NSBaselineOffsetAttributeName : 0.7 as AnyObject]
        
//        iconAttributedString = NSAttributedString(string: textString!, attributes: textAttributeDictionary)
//        
//        finalAttributedString.append(iconAttributedString!)
        textAttributeDictionary = nil
        
        textAttributeDictionary = [NSForegroundColorAttributeName : titleStringColor!,
                                   NSFontAttributeName : regularFont,
                                   NSParagraphStyleAttributeName : paragraphStyle,
                                   NSBaselineOffsetAttributeName : 0.0 as AnyObject]
        
        let textString : String = spaceString! + (self.titleLabel?.text)!
        titleAttributedString = NSAttributedString(string: textString, attributes: textAttributeDictionary)
        
        finalAttributedString.append(titleAttributedString!)
        self.setAttributedTitle(finalAttributedString, for: UIControlState())
        
        finalAttributedString = nil
        textAttributeDictionary = nil
        
        titleAttributedString = nil
        titleAttributedString = nil
        
        //textString = nil
        spaceString = nil
        
        iconStringColor = nil
        titleStringColor = nil
        
        self.titleLabel?.text = ""
    }
    
    // MARK: - User Interaction -
    
    func buttonTouchUpInsideAction(_ sender : AnyObject) {
        self.backgroundColor = originalBackgroundColor
        switch baseButtonType
        {
        case .checkBoxButtonType:
            self.isSelected = !self.isSelected
            break
        default:
            break
        }
        if(touchUpInsideEvent != nil){
             touchUpInsideEvent(sender , "" as AnyObject)
        }
        
    }
    
    func buttonTouchUpOutsideAction(_ sender : AnyObject) {
        self.backgroundColor = originalBackgroundColor
        
    }
    
    func buttonTouchDownAction(_ sender : AnyObject) {
        self.backgroundColor = highlightBackgroundColor
        
    }
    
    
    // MARK: - Internal Helpers -
    
    
}
