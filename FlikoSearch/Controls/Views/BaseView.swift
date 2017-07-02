
import UIKit
import Toast_Swift


typealias ControlTouchUpInsideEvent = (_ sender : AnyObject?, _ object : AnyObject?) -> ()
typealias TableCellSelectEvent = (_ sender : AnyObject?, _ object : AnyObject?) -> ()


typealias ScrollViewDidScrollEvent = (_ scrollView : UIScrollView?, _ object : AnyObject?) -> ()
typealias TaskFinishedEvent = (_ successFlag : Bool?, _ object : AnyObject?) -> ()
typealias SwitchStateChangedEvent = (_ sender : AnyObject?, _ state : Bool?) -> ()


class BaseView: UIView {

    // MARK: - Attributes -
    
    var baseLayout : MyViewBaseLayout!
    
    var backgroundImageView : BaseImageView!
    
    var errorMessageLabel : UILabel!
    var progressHUDView : MBProgressHUD!
    var toastStyle : ToastStyle!
   
    var tableFooterView : UIView!
    var footerIndicatorView : UIActivityIndicatorView!
    
    var isLoadedRequest : Bool = false
    var layoutSubViewEvent : TaskFinishedEvent!
    
    var operationQueue : OperationQueue!
    var tableFooterHeight : CGFloat = 0.0
    
    
    // MARK: - Lifecycle -
    var navigationView : CustomNavigationView!
    
    init(withBack : Bool,titleString : String)
    {
        super.init(frame: CGRect.zero)
        self.setUpNavigation(withBack: withBack, titleString: titleString)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    
    deinit{
     
        baseLayout = nil
     
        backgroundImageView = nil
        
        errorMessageLabel = nil
        progressHUDView = nil
        
        tableFooterView = nil
        footerIndicatorView = nil
        
        if(operationQueue != nil){
            operationQueue.cancelAllOperations()
        }
        operationQueue = nil
        
    }
    
    // MARK: - Layout - 
    
    func loadViewControls(){
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundColor = UIColor(rgbValue:ColorStyle.sidebarmaincolor, alpha: 1.0)
        
        self.isExclusiveTouch = true
        self.isMultipleTouchEnabled = true
        
        toastStyle = ToastStyle()
        
        toastStyle.messageFont = UIFont(fontString: "AppleSDGothicNeo-Regular;13.0") as UIFont
        toastStyle.messageColor = UIColor(rgbValue:ColorStyle.sidebarmaincolor, alpha: 1.0)
        toastStyle.messageAlignment = .center
        toastStyle.backgroundColor = UIColor(rgbValue: ColorStyle.equacolorsidebar, alpha: 1.0)
        
        toastStyle.cornerRadius = 4.0;
        toastStyle.displayShadow = false;
        
        toastStyle.shadowColor = UIColor(rgbValue:ColorStyle.sidebarmaincolor, alpha: 0.0);
        toastStyle.shadowOpacity = 0.0;
        
        self.loadErrorMessageLabel()
        
        
        
    }
    
    func setViewlayout(){
        
        if(baseLayout == nil){
            baseLayout = MyViewBaseLayout()
            baseLayout.viewDictionary = ["errorMessageLabel" : errorMessageLabel ]
            
            /*     errorLabel Layout     */
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[errorMessageLabel]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            
            self.addConstraints(baseLayout.control_H)
            
            baseLayout.position_Top = NSLayoutConstraint(item: errorMessageLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
            baseLayout.position_Bottom = NSLayoutConstraint(item: errorMessageLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            
            self.addConstraints([baseLayout.position_Top, baseLayout.position_Bottom])
            baseLayout.control_H = nil
            baseLayout.position_Top = nil
            baseLayout.position_Bottom = nil
            baseLayout.viewDictionary = nil
        }
        
        
    }
    
    func loadErrorMessageLabel(){
        
        errorMessageLabel = UILabel(frame: CGRect.zero)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageLabel.font = UIFont(fontString: "AppleSDGothicNeo-Medium;15")
        errorMessageLabel.numberOfLines = 0
        
        errorMessageLabel.preferredMaxLayoutWidth = 200
        errorMessageLabel.textAlignment = .center
        
        errorMessageLabel.backgroundColor = UIColor.clear
        errorMessageLabel.textColor = UIColor(rgbValue: ColorStyle.KAppFontColor, alpha: ColorStyle.KAppFontColorAlpha)
        
        errorMessageLabel.tag = -1
        self.addSubview(errorMessageLabel)
        
        self.displayErrorMessageLabel(nil)
        
    }
    
    func showProgressHUD(viewController from: UIView,
                         title: String?,
                         subtitle: String?
        ) {
        
        progressHUDView = MBProgressHUD(view: from)
        if progressHUDView != nil {
            from.addSubview(self.progressHUDView!)
            
            progressHUDView.labelFont = UIFont(fontString: "AppleSDGothicNeo-Medium;15")
            progressHUDView.detailsLabelFont = UIFont(fontString: "AppleSDGothicNeo-Medium;15")
            progressHUDView.margin = 19.0
            progressHUDView.opacity = 0.8
            progressHUDView.isSquare = false
            
            
            progressHUDView.dimBackground = true
            progressHUDView.animationType = MBProgressHUDAnimation.fade;
            
            progressHUDView.color = UIColor(rgbValue: ColorStyle.KSecondaryBackgroundColor, alpha: 0.98)
            progressHUDView.activityIndicatorColor = UIColor(rgbValue: 0xffffff, alpha: 0.6)
            
            let fontOpacity : CGFloat = 0.9
            
            progressHUDView.labelColor = UIColor(rgbValue: 0xffffff, alpha: fontOpacity)
            progressHUDView.detailsLabelColor = UIColor(rgbValue: 0xffffff, alpha: fontOpacity)
        }
        
        
        if let titleSet = title {
            progressHUDView?.labelText = titleSet
        }
        else
        {
            progressHUDView?.labelText = "Loading..."
        }
        progressHUDView?.detailsLabelText = subtitle == nil ? "" : subtitle
        progressHUDView.bringSubview(toFront: self)
        self.progressHUDView?.show(true)
        
    }
    
    func hideProgressHUD() {
        
        AppUtility.executeTaskInMainQueueWithCompletion{
            if(self.progressHUDView != nil){
                self.progressHUDView.hide(true)
            }
            
        }
        
    }
     
    func loadBackgroundImageViewWithImage(_ image : UIImage?){
        
        if(backgroundImageView == nil){
            
            backgroundImageView = BaseImageView(frame: CGRect.zero)
            
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.contentMode = .scaleToFill
            
            self.addSubview(backgroundImageView)
            
            if(baseLayout == nil){
                baseLayout = MyViewBaseLayout()
            }
            
            baseLayout.expandView(backgroundImageView, insideView: self)
            baseLayout = nil
        }
        
        if(image != nil){
            backgroundImageView.image = image
        }
        
    }
    
    func loadTableFooterView(){
        
        let screenSize : CGSize = InterfaceUtility.getDeviceScreenSize()
        
        footerIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        tableFooterHeight = footerIndicatorView.frame.size.height + 20.0
        
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clear
        
        tableFooterView.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: tableFooterHeight)
        
        let tableHeaderSize : CGSize = tableFooterView.frame.size
        footerIndicatorView.center = CGPoint(x: tableHeaderSize.width/2.0, y: tableHeaderSize.height/2.0)
        
        footerIndicatorView.startAnimating()
        footerIndicatorView.hidesWhenStopped = true
        
        tableFooterView.addSubview(footerIndicatorView)
        
    }
    
    // MARK: - Public Interface -
    
    // MARK: - Public Interface -
    
    override func getDictionaryOfVariableBindings(superView : UIView , viewDic : NSDictionary) -> NSDictionary
    {
        var dicView : NSMutableDictionary = viewDic.mutableCopy() as! NSMutableDictionary
        
        if superView.subviews.count > 0
        {
            if let viewName = superView.layer .value(forKeyPath: layoutTimeConstants.KControlName) as? String
            {
                dicView .setValue(superView, forKey: viewName)
            }
            
            for view in superView.subviews
            {
                if view.subviews.count > 0
                {
                    dicView = self.getDictionaryOfVariableBindings(superView: view , viewDic: dicView) .mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    if let viewName = view.layer .value(forKeyPath: layoutTimeConstants.KControlName) as? String{
                        dicView .setValue(view, forKey: viewName)
                    }
                }
            }
        }
        else
        {
            if let viewName = superView.layer .value(forKeyPath: layoutTimeConstants.KControlName) as? String{
                dicView .setValue(superView, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    func setNotificationObserver(){
        
    }
    
    func removeNotificationObserver(){
        
    }
    
    func setKeyboardObserver(){
        
    }
    
    func removeKeyboardObserver(){
        
    }
    
    func setTitleLabelWithText(_ title: String, borderColor: UIColor){
        
        
    }
    
    func displayErrorMessageLabel(_ errorMessage : String?){
        
        AppUtility.executeTaskInMainQueueWithCompletion { 
            
            if(self.errorMessageLabel != nil){
                
                self.errorMessageLabel.isHidden = true
                self.errorMessageLabel.text = ""
                
                if(self.errorMessageLabel.tag == -1){
                    self.sendSubview(toBack: self.errorMessageLabel)
                }

                if(errorMessage != nil){
                    
                    if(self.errorMessageLabel.tag == -1){
                        self.bringSubview(toFront: self.errorMessageLabel)
                    }
                    
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = errorMessage
    
                }
                
                self.errorMessageLabel.layoutSubviews()
                
            }
        }
    }
    
    class func isFirstTextControlInSuperview(_ superview: UIView?, textControl: UIView) -> Bool{
        
        var isFirstTextControl : Bool = true
        
        var textControlIndex : Int = -1
        var viewControlIndex : Int = -1
        
        if(superview != nil){
            
            if((superview?.subviews.contains(textControl))!){
                textControlIndex = superview!.subviews.index(of: textControl)!
            }
            
            for view in (superview?.subviews)! {
             
                if(view.isTextControl() && textControl != view){
                    
                    viewControlIndex = superview!.subviews.index(of: view)!
                    
                    if(viewControlIndex < textControlIndex){
                        isFirstTextControl = false
                        break
                    }
                }
            }
        }
        
        return isFirstTextControl
        
    }
    
    class func isLastTextControlInSuperview(_ superview: UIView?, textControl: UIView) -> Bool{
        
        var isLastTextControl : Bool = true
        
        var textControlIndex : Int = -1
        var viewControlIndex : Int = -1
        
        if(superview != nil){
            
            if((superview?.subviews.contains(textControl))!){
                textControlIndex = superview!.subviews.index(of: textControl)!
            }
            
            for view in (superview?.subviews)! {
                
                if(view.isTextControl() && textControl != view){
                    
                    viewControlIndex = superview!.subviews.index(of: view)!
                    
                    if(viewControlIndex > textControlIndex){
                        isLastTextControl = false
                        break
                    }
                }
            }
        }
        
        return isLastTextControl
        
    }
    
    
    

    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    internal func setUpNavigation(withBack : Bool,titleString : String)
    {
        navigationView = CustomNavigationView.init(titleString: titleString, SuperView: self)
        navigationView.navigationTitle = titleString
        navigationView.setMenuButtonAction { (sendor, object) in
            
        }
    }

    
    // MARK: - Server Request -
    
    
    func loadOperationServerRequest(){
        
        if(!isLoadedRequest){
            AppUtility.executeTaskInMainQueueWithCompletion{
                if(self.progressHUDView != nil){
                    self.progressHUDView.hide(true)
                    
                }
                
            }
        }
        
    }
    
    func beginServerRequest(){
        isLoadedRequest = true
        
    }

}
