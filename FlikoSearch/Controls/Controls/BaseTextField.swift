

import UIKit


enum ResponderDirectionType : Int {
    
    case leftResponderDirectionType = 1
    case rightResponderDirectionType = 2
    
}

enum BaseTextFieldType : Int {
    
    case basePrimaryTextFieldType = 0
    case baseNoAutoScrollType
    case baseShowPasswordType
    case baseNoClearButtonTextFieldType
}

class BaseTextField: UITextField, UITextFieldDelegate {

    // MARK: - Attributes -
    
    var leftArrowButton : BaseBarButtonItem!
    var rightArrowButton : BaseBarButtonItem!
    
    var copyButton : BaseBarButtonItem!
    var pasteButton : BaseBarButtonItem!
    
    var inputAccessory : UIView!
    var baseLayout : MyViewBaseLayout!
    var charaterLimit : Int = 9999
    var baseTextFieldType : BaseTextFieldType = BaseTextFieldType.basePrimaryTextFieldType
    
    // MARK: - Lifecycle -
    
    init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
            self.delegate = self
        }
    }
    
    init(iSuperView : UIView? , TextFieldType baseType : BaseTextFieldType)
    {
        super.init(frame : CGRect.zero)
        
        baseTextFieldType = baseType
        
        self.setCommonProperties()
        self.setlayout()
        
        if iSuperView != nil
        {
            iSuperView?.addSubview(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        if(self.placeholder!.responds(to: #selector(NSString.draw(at:withAttributes:)))){
        
            let attributes : [String : AnyObject] = [NSForegroundColorAttributeName : UIColor(rgbValue:ColorStyle.KPrimaryTextPlaceholderColor, alpha: 0.45),
                                           NSFontAttributeName : self.font!]
            
            let boundingRect : CGRect = self.placeholder!.boundingRect(with: rect.size, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil)
            
            switch baseTextFieldType
            {
            case .baseNoClearButtonTextFieldType:
                self.placeholder!.draw(at: CGPoint(x: (rect.size.width / 2) - boundingRect.size.width / 2, y: (rect.size.height / 2) - boundingRect.size.height / 2), withAttributes: attributes)
                break
            default:
                self.placeholder!.draw(at: CGPoint(x: 0, y: (rect.size.height/2) - boundingRect.size.height/2), withAttributes: attributes)
                break
            }
            
        }
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {

        var customBounds : CGRect!
        
        if baseTextFieldType == BaseTextFieldType.baseShowPasswordType
        {
            customBounds = CGRect(x: bounds.origin.x + layoutTimeConstants.KTextLeftPaddingFromControl,y: bounds.origin.y,width: bounds.size.width - 4.8 * layoutTimeConstants.KTextLeftPaddingFromControl , height: bounds.size.height)
        }
        else if baseTextFieldType == .baseNoClearButtonTextFieldType
        {
            customBounds = CGRect(x: bounds.origin.x , y: bounds.origin.y,width : bounds.size.width ,height: bounds.size.height)
        }
        else{
            customBounds = CGRect(x:bounds.origin.x + layoutTimeConstants.KTextLeftPaddingFromControl,y:  bounds.origin.y,width : bounds.size.width - 3.8*layoutTimeConstants.KTextLeftPaddingFromControl,height: bounds.size.height)
        }
        
        return customBounds
        
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        var customBounds : CGRect!
        if baseTextFieldType == BaseTextFieldType.baseShowPasswordType
        {
            customBounds = CGRect(x: bounds.origin.x + layoutTimeConstants.KTextLeftPaddingFromControl, y: bounds.origin.y,width:  bounds.size.width - 4.8 * layoutTimeConstants.KTextLeftPaddingFromControl, height:  bounds.size.height)
        }
        else if baseTextFieldType == .baseNoClearButtonTextFieldType
        {
            customBounds = CGRect(x: bounds.origin.x ,y: bounds.origin.y,width:  bounds.size.width , height:  bounds.size.height)
        }
        else{
            customBounds = CGRect(x: bounds.origin.x + layoutTimeConstants.KTextLeftPaddingFromControl,y: bounds.origin.y,width:  bounds.size.width - 3.8 * layoutTimeConstants.KTextLeftPaddingFromControl, height:  bounds.size.height)
        }
        
        return customBounds!
    }
    
    override var text: String?{
        didSet{
            self.displayClearButton()
        }
    }
    
    deinit{
        
        leftArrowButton = nil
        rightArrowButton = nil
        
        copyButton = nil
        pasteButton = nil
        
        baseLayout = nil
    }
    
    // MARK: - Layout - 
    
    func setCommonProperties(){
        
        switch baseTextFieldType
        {
        case .baseNoAutoScrollType:
            self.setShowToolbar(false)
            self.clearButtonMode = .whileEditing
            self.textAlignment = .left
            break
        case .basePrimaryTextFieldType:
            self.clearButtonMode = .whileEditing
            self.returnKeyType = .default
            self.setShowToolbar(true)
            self.delegate = self
            self.textAlignment = .left
            break
        case .baseShowPasswordType :
            self.isSecureTextEntry = true
            self.returnKeyType = .default
            self.clearButtonMode = .never
            self.setShowToolbar(true)
            self.delegate = self
            self.textAlignment = .left
            break
        case .baseNoClearButtonTextFieldType :
            self.clearButtonMode = .never
            self.setShowToolbar(true)
            self.delegate = self
            self.textAlignment = .center
            break
            
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardAppearance = .dark
        
        self.autocapitalizationType = .none
        self.autocorrectionType = .default
        
        //self.backgroundColor = UIColor(rgbValue: ColorConstants.KPrimaryTextInputColor, alpha: 1.0)
        self.backgroundColor = UIColor(rgbValue: ColorStyle.KLightColor, alpha: 1.0)
        
        self.textColor = UIColor(rgbValue: ColorStyle.KPrimaryTextInputFontColor, alpha: 1.0)
        
        self.font = UIFont(fontString: "AppleSDGothicNeo-Medium;13")
        
        self.setBorder(UIColor(rgbValue: ColorStyle.KPrimaryTextInputColor, alpha: 1.0),
                                        width: 1.5,
                                        radius: layoutTimeConstants.KControlBorderRadius)
        
    }
    
    func setlayout(){
        
        baseLayout = MyViewBaseLayout()
        
        baseLayout.viewDictionary = ["textField" : self]
        
        let textFieldHeight : CGFloat = is_Device._iPad ? 50.0 : 35.0
        let textFieldWidth : CGFloat = is_Device._iPad ? 40.0 : 50.0
        
        baseLayout.metrics = ["textFieldHeight" : textFieldHeight , "textFieldWidth" : textFieldWidth]
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField(textFieldHeight)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_V)
        
        switch baseTextFieldType
        {
        case .baseShowPasswordType:
            
            let btnShowPassword : UIButton = UIButton(type: UIButtonType.custom)
            btnShowPassword.translatesAutoresizingMaskIntoConstraints = false
            btnShowPassword.backgroundColor = self.backgroundColor
            btnShowPassword .setImage(UIImage(named: "ShowPassword"), for: UIControlState.normal)
            btnShowPassword .setImage(UIImage(named: "HidePassword"), for: UIControlState.selected)
            btnShowPassword .addTarget(self, action: #selector(self.btnShowPassword(sender:)), for: .touchUpInside)
            btnShowPassword .isSelected = true
            
            self.addSubview(btnShowPassword)
            
            
            baseLayout.viewDictionary = ["btnShowPassword" : btnShowPassword]
            baseLayout.metrics = ["buttonHeight" : textFieldHeight]
            
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnShowPassword]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            
            baseLayout.position_Right = NSLayoutConstraint(item: btnShowPassword, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)
            
            baseLayout.size_Width = NSLayoutConstraint(item: btnShowPassword, attribute: .width, relatedBy: .equal, toItem: btnShowPassword, attribute: .height, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(baseLayout.size_Width)
            self.addConstraints(baseLayout.control_V)
            self.addConstraint(baseLayout.position_Right)
            
            
            break
            
        case .baseNoClearButtonTextFieldType:
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[textField(textFieldWidth)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            break
            
        default:
            break
        }
        
    }
    
   
    // MARK: - Public Interface -
    
    func setErrorBorder(){
        self.setBorder(UIColor(rgbValue: 0xff0000, alpha: 0.6), width: layoutTimeConstants.KTextControlBorderWidth, radius: layoutTimeConstants.KTextControlBorderRadius)
    }
   
    func clearErrorBorder(){
        self.setBorder(UIColor(rgbValue: 0xffffff, alpha: 0.6), width: layoutTimeConstants.KTextControlBorderWidth, radius: layoutTimeConstants.KTextControlBorderRadius)
    }
    
    func resetScrollView(){
     
        AppUtility.executeTaskInGlobalQueueWithCompletion({
            
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            
            if(scrollView != nil){
              
                AppUtility.executeTaskInMainQueueWithCompletion({
                    
                    let contentOffset : CGPoint = CGPoint.zero
                    scrollView?.setContentOffset(contentOffset, animated: true)
                    
                    self.displayClearButton()
                    
                })
                
            }
        })
        
    }
    
    func setShowToolbar(_ visible : Bool){
        
        if(visible){
            
            let fixedSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedSpace.width = 5.0
            
            leftArrowButton = BaseBarButtonItem(itemType: .baseBarLeftButtonItemType)
            leftArrowButton.setTarget(self, action: #selector(leftArrowButtonAction))
            
            rightArrowButton = BaseBarButtonItem(itemType: .baseBarRightButtonItemType)
            rightArrowButton.setTarget(self, action: #selector(rightArrowButtonAction))
            
            //leftArrowButton.tintColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)
            //rightArrowButton.tintColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)
            
            
/*
            copyButton = BaseBarButtonItem(itemType: .BaseBarCopyButtonItemType)
            copyButton.setTarget(self, action: #selector(copyButtonAction))
            
            pasteButton = BaseBarButtonItem(itemType: .BaseBarPasteButtonItemType)
            pasteButton.setTarget(self, action: #selector(pasteButtonAction))
            
            self.addTarget(self, action: #selector(setCopyPasteEnabled), forControlEvents: .EditingChanged)
*/
            
            let doneButton : BaseBarButtonItem = BaseBarButtonItem(itemType: .baseBarDoneButtonItemType)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            let flexibleSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
            setCopyPasteEnabled()
            
            let numberToolbar : UIToolbar = UIToolbar()
            numberToolbar.barStyle = .black
            numberToolbar.isTranslucent = false
            
            numberToolbar.barTintColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: 1.0)
            
            numberToolbar.tintAdjustmentMode = .normal
            numberToolbar.items = [leftArrowButton, fixedSpace, rightArrowButton, flexibleSpace, doneButton]
            
            numberToolbar.sizeToFit()
            self.inputAccessoryView = numberToolbar
            
            numberToolbar.setTopBorder(UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
            numberToolbar.setBottomBorder(UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
        }else{
            self.inputAccessoryView = nil
        }
        
    }
    
    func setDoneToolbar(_ visible : Bool){
        
        if(visible){
            
            let flexibleSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let doneButton : BaseBarButtonItem = BaseBarButtonItem(itemType: .baseBarDoneButtonItemType)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
            let numberToolbar : UIToolbar = UIToolbar()
            
            numberToolbar.barStyle = .black
            numberToolbar.isTranslucent = false
            
            numberToolbar.barTintColor = UIColor(rgbValue: ColorStyle.equacolorsidebar, alpha: 1.0)
            
            numberToolbar.tintAdjustmentMode = .normal
            numberToolbar.items = [flexibleSpace, doneButton]
            
            numberToolbar.sizeToFit()
            self.inputAccessoryView = numberToolbar
            
            numberToolbar.setTopBorder(UIColor(rgbValue: ColorStyle.equacolorsidebar, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
            numberToolbar.setBottomBorder(UIColor(rgbValue: ColorStyle.equacolorsidebar, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
        }else{
            self.inputAccessoryView = nil
            
        }
        
    }
    
    // MARK: - User Interaction -
    
    func leftArrowButtonAction(){
        self.setResponderToTextControl(.leftResponderDirectionType)
    }
    
    func rightArrowButtonAction(){
        self.setResponderToTextControl(.rightResponderDirectionType)
    }
    
    func copyButtonAction(){
        
        if(self.hasText){
            UIPasteboard.general.string = self.text
        }
    }
    
    func pasteButtonAction(){
        if let string = UIPasteboard.general.string {
            self.insertText(string)
        }
    }
    
    func doneButtonAction(){
        AppUtility.executeTaskInMainQueueWithCompletion { 
            self.resignFirstResponder()
        }
        
        self.resetScrollView()
    }
    
    // MARK: - Internal Helpers -
    
    
    func btnShowPassword(sender : UIButton) -> Void
    {
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.text = self.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let button : UIButton = sender
        button.isSelected = self.isSecureTextEntry
    }
    
    func setCopyPasteEnabled(){
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            
            if(self.pasteButton != nil){
                self.pasteButton.isEnabled = ((UIPasteboard.general.string?.characters.count)! > 0)
            }
            
        }
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            
            if(self.copyButton != nil){
                self.copyButton.isEnabled = self.hasText
            }
            
        }
        
    }
    
    func setScrollViewContentOffsetForView(_ view : UIView){
        
        AppUtility.executeTaskInGlobalQueueWithCompletion({
            
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion({
                    let viewRect : CGRect = view.frame
                    let contentOffset : CGPoint = CGPoint(x: 0.0, y: viewRect.origin.y)
                    
                    scrollView?.setContentOffset(contentOffset, animated: true)
                    self.displayClearButton()
                })
                
            }
        })
    }
    
    func getScrollViewFromView(_ view : UIView?) -> UIScrollView?{
        
        var scrollView : UIScrollView? = nil
        var view : UIView? = view!.superview!
        
        while (view != nil) {
            
            if(view!.isKind(of: UIScrollView.self)){
                scrollView = view as? UIScrollView
                break
            }
            
            if(view!.superview != nil){
                view = view!.superview!
            
            }else{
                view = nil
                
            }
            
        }
        
        return scrollView
    }
    
    func setResponderToTextControl(_ iDirectionType : ResponderDirectionType){
        
        if(self.superview != nil && self.isEnabled){
            
            AppUtility.executeTaskInGlobalQueueWithCompletion({ 
                
                let subViewArray : Array = (self.superview?.subviews)!
                let subViewArrayCount : Int = subViewArray.count
                
                var isNextTextControlAvailable : Bool = false
                let currentTextFieldIndex : Int = subViewArray.index(of: self)!
                
                var textField : UITextField?
                var textView : UITextView?
                
                var view : UIView?
                
                let operatorSign = (iDirectionType == .leftResponderDirectionType) ? -1 : 1
                var i = currentTextFieldIndex + operatorSign
                
                while(i >= 0 && i < subViewArrayCount){
                   
                    view = subViewArray[i]
                    isNextTextControlAvailable = view!.isKind(of: UITextField.self) || view!.isKind(of: UITextView.self)
                    
                    if(isNextTextControlAvailable){
                        
                        if(view!.isKind(of: UITextField.self)){
                            
                            textField = view as? UITextField
                            if(textField!.isEnabled && textField!.delegate != nil){
                                
                                AppUtility.executeTaskInMainQueueWithCompletion({ 
                                    textField?.becomeFirstResponder()
                                })
                                
                                break
                            }else{
                                isNextTextControlAvailable = false
                            }
                        
                        }else if(view!.isKind(of: UITextView.self)){
                            
                            textView = view as? UITextView
                            if(textView!.isEditable && textView!.delegate != nil){
                                
                                AppUtility.executeTaskInMainQueueWithCompletion({
                                    textView?.becomeFirstResponder()
                                })
                                
                                break
                                
                            }else{
                                isNextTextControlAvailable = false
                                
                            }
                        }
                        
                    }
                    
                    i = i + operatorSign
                }
                
                if(isNextTextControlAvailable && view != nil){
                    self.setScrollViewContentOffsetForView(view!)
                }
                
            })
            
        }
    }
    
    func displayClearButton(){
        AppUtility.executeTaskInMainQueueWithCompletion
            {
                if self.baseTextFieldType != BaseTextFieldType.baseShowPasswordType && self.baseTextFieldType != .baseNoClearButtonTextFieldType
                {
                    if self.hasText{
                        self.clearButtonMode = .always
                    }else{
                        self.clearButtonMode = .whileEditing
                    }
                }
        }
    }
    
    // MARK: - UITextField Delegate Methods -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let isEditable = true
        return isEditable
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        self.setCopyPasteEnabled()
        
        self.setScrollViewContentOffsetForView(self)
        AppUtility.executeTaskInGlobalQueueWithCompletion { 
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion({
                    scrollView?.isScrollEnabled = false
                })
                
            }
            
            self.displayClearButton()
            
            if(self.superview != nil){
                
                if(self.leftArrowButton != nil){
                    
                    AppUtility.executeTaskInMainQueueWithCompletion({ 
                        
                        let isEnabled : Bool = !BaseView.isFirstTextControlInSuperview(self.superview, textControl: self)
                        self.leftArrowButton.isEnabled = isEnabled
                        
                    })
                    
                }
                
                if(self.rightArrowButton != nil){
                    
                    AppUtility.executeTaskInMainQueueWithCompletion({
                        
                        let isEnabled : Bool = !BaseView.isLastTextControlInSuperview(self.superview, textControl: self)
                        self.rightArrowButton.isEnabled = isEnabled
                        
                    })
                    
                }
                
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        self.setCopyPasteEnabled()
        
        AppUtility.executeTaskInGlobalQueueWithCompletion {
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion({ 
                    scrollView?.isScrollEnabled = true
                })
                
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        AppUtility.executeTaskInMainQueueWithCompletion { 
            textField.resignFirstResponder()
            self.resetScrollView()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var oldlength : Int = 0
        if textField.text != nil
        {
            oldlength = (textField.text?.characters.count)!
        }
        
        let replaceMentLength : Int = string .characters.count
        let rangeLength : Int = range.length
        
        let newLength : Int = oldlength - rangeLength + replaceMentLength
        
        return newLength <= charaterLimit || false
    }
}


