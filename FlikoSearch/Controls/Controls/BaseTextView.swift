
import UIKit

class BaseTextView: UITextView, UITextViewDelegate, UIScrollViewDelegate {

    
    // MARK: - Attributes -
    
    var placeholder : String!
    
    var placeHolderLabel : UILabel!
    var borderView : UIView!
    
    var leftArrowButton : BaseBarButtonItem!
    var rightArrowButton : BaseBarButtonItem!
    
    var isMultiLinesSupported : Bool = false
    
    // MARK: - Lifecycle -
    
    init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero, textContainer: nil)
        
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
            self.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
//    override func draw(_ rect: CGRect) {
//        superview?.draw(rect)
//        
//        if(self.placeholder.characters.count > 0){
//            
//            if(placeHolderLabel == nil){
//                
//                placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 6, width: self.bounds.size.width - 16, height: 0))
//                
//                placeHolderLabel.lineBreakMode = .byWordWrapping
//                placeHolderLabel.numberOfLines = 0
//                
//                placeHolderLabel.font = self.font
//                placeHolderLabel.backgroundColor = UIColor.clear
//                
//                placeHolderLabel.textColor = UIColor(rgbValue: ColorStyle.KPrimaryTextPlaceholderColor, alpha: 0.45)
//                placeHolderLabel.alpha = 0.0
//                
//                placeHolderLabel.tag = 999
//                self.addSubview(placeHolderLabel)
//            }
//            
//            placeHolderLabel.text = self.placeholder
//            placeHolderLabel.sizeToFit()
//            
//            self.sendSubview(toBack: placeHolderLabel)
//            
//        }
//        
//        if(self.text!.characters.count == 0 && self.placeholder.characters.count > 0){
//            self.viewWithTag(999)?.alpha = 1
//        }
//        
//    }
    
//    override var text: String?{
//        didSet{
//            //self.textViewDidChange(self)
//        }
//    }

    
    deinit{
        
      //  baseLayout = nil
        placeholder = nil
        
        placeHolderLabel = nil
        borderView = nil
        
        leftArrowButton = nil
        rightArrowButton = nil
    }
    
    // MARK: - Layout - 
    
    func setCommonProperties(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        self.autocapitalizationType = .sentences
        
        self.autocorrectionType = .default
        self.keyboardAppearance = .dark
        
        self.textColor = UIColor(rgbValue: ColorStyle.KPrimaryTextInputFontColor, alpha: 1.0)
        self.backgroundColor = UIColor(rgbValue: ColorStyle.KPrimaryTextInputColor, alpha: 1.0)
        
        self.font = UIFont(fontString: "AppleSDGothicNeo-Medium;13")
        
        self.setShowToolbar(true)
        
        self.setBorder(UIColor(rgbValue: ColorStyle.KPrimaryTextInputColor, alpha: 1.0), width: 1.5, radius: layoutTimeConstants.KControlBorderRadius)
        
    }
    
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    
    func setErrorBorder(){
        self.setBorder(UIColor(rgbValue: 0xff0000, alpha: 0.6), width: layoutTimeConstants.KTextControlBorderWidth, radius: layoutTimeConstants.KTextControlBorderRadius)
    }
    
    func resetScrollView(){
        
        AppUtility.executeTaskInGlobalQueueWithCompletion({
            
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion({
                    
                    let contentOffset : CGPoint = CGPoint.zero
                    scrollView?.setContentOffset(contentOffset, animated: true)
                    
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
            
            let doneButton : BaseBarButtonItem = BaseBarButtonItem(itemType: .baseBarDoneButtonItemType)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            let flexibleSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
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
            
            numberToolbar.barTintColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: 1.0)
            
            numberToolbar.tintAdjustmentMode = .normal
            numberToolbar.items = [flexibleSpace, doneButton]
            
            numberToolbar.sizeToFit()
            self.inputAccessoryView = numberToolbar
            
            numberToolbar.setTopBorder(UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
            numberToolbar.setBottomBorder(UIColor(rgbValue: ColorStyle.sidebarmaincolor, alpha: ColorStyle.KTextFieldToolbarBorderAlpha), width: 1.0)
            
        }else{
            self.inputAccessoryView = nil
            
        }
        
    }
    
    func setHideBottomBorder(_ hidden : Bool){
        AppUtility.executeTaskInMainQueueWithCompletion { 
            self.borderView.isHidden = hidden
        }
    }
    
    // MARK: - User Interaction -
    
    func leftArrowButtonAction(){
        self.setResponderToTextControl(.leftResponderDirectionType)
    }
    
    func rightArrowButtonAction(){
        self.setResponderToTextControl(.rightResponderDirectionType)
    }
    
    func doneButtonAction(){
        AppUtility.executeTaskInMainQueueWithCompletion {
            self.resignFirstResponder()
        }
        
        self.resetScrollView()
    }
    
    // MARK: - Internal Helpers -
    
    func setScrollViewContentOffsetForView(_ view : UIView){
        
        AppUtility.executeTaskInGlobalQueueWithCompletion({
            
            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion({
                    let viewRect : CGRect = view.frame
                    let contentOffset : CGPoint = CGPoint(x: 0.0, y: viewRect.origin.y)
                    
                    scrollView?.setContentOffset(contentOffset, animated: true)
                    
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
        
        if(self.superview != nil && self.isEditable){
            
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
    
//    // MARK: - UITextView Delegate Methods -
//    
//    func textViewDidChange(_ textView: UITextView){
//        if(self.placeholder.characters.count == 0){
//            return
//        }
//        
//        AppUtility.executeTaskInMainQueueWithCompletion { 
//            
//            UIView.animate(withDuration: 0.25, animations: { 
//                
//                if(!self.hasText){
//                    self.viewWithTag(999)?.alpha = 1.0
//                    
//                }else{
//                    self.viewWithTag(999)?.alpha = 0.0
//                    
//                }
//                
//            })
//            
//        }
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView){
//        
//        self.setScrollViewContentOffsetForView(self)
//        AppUtility.executeTaskInGlobalQueueWithCompletion {
//            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
//            
//            if(scrollView != nil){
//                
//                AppUtility.executeTaskInMainQueueWithCompletion({
//                    scrollView?.isScrollEnabled = false
//                })
//                
//            }
//            
//            if(self.superview != nil){
//                
//                if(self.leftArrowButton != nil){
//                    
//                    AppUtility.executeTaskInMainQueueWithCompletion({
//                        
//                        let isEnabled : Bool = !BaseView.isFirstTextControlInSuperview(self.superview, textControl: self)
//                        self.leftArrowButton.isEnabled = isEnabled
//                        
//                    })
//                    
//                }
//                
//                if(self.rightArrowButton != nil){
//                    
//                    AppUtility.executeTaskInMainQueueWithCompletion({
//                        
//                        let isEnabled : Bool = !BaseView.isLastTextControlInSuperview(self.superview, textControl: self)
//                        self.rightArrowButton.isEnabled = isEnabled
//                        
//                    })
//                    
//                }
//                
//            }
//        }
//
//        
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView){
//        
//        AppUtility.executeTaskInGlobalQueueWithCompletion {
//            let scrollView : UIScrollView? = self.getScrollViewFromView(self)
//            
//            if(scrollView != nil){
//                
//                AppUtility.executeTaskInMainQueueWithCompletion({
//                    scrollView?.isScrollEnabled = true
//                })
//                
//            }
//            
//        }
//        
//    }
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
//     
//        if(text == "\n" && !self.isMultiLinesSupported){
//            
//            textView.resignFirstResponder()
//            self.resetScrollView()
//            
//            return false
//        }
//        
//        return true
//    }
//    
//    
//    // MARK: - UIScrollView Delegate Methods -
//    
//    func scrollViewDidScroll(_ scrollView : UIScrollView){
//        self.layoutSubviews()
//    }

}
