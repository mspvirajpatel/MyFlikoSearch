

import UIKit

class CustomNavigationView: UIView {
    
    // MARK: - Attribute -
    public var lblTitle   : BaseLabel!
    public var btnBack    : BaseButton!
    public var btnMenu    : BaseButton!
    private var menuButtonAction : ControlTouchUpInsideEvent!
    private var menushareButton : ControlTouchUpInsideEvent!
    public var btnpopup : BaseButton!
    public var btnfav : BaseButton!
    public var btnsidebar : BaseButton!
    public var btndownload : BaseButton!
    public var btnshare : BaseButton!
    
    var navigationTitle : String = "" {
        willSet{
            lblTitle?.text = navigationTitle != "" ? navigationTitle : " "
        }
        didSet{
            lblTitle?.text = navigationTitle != "" ? navigationTitle : " "
        }
    }
    
    // MARK: - Lifecycle -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(titleString : String,SuperView superView : UIView)
    {
        super.init(frame: CGRect.zero)
        superView.addSubview(self)
        self.setCommonProparty()
        self.loadViewControls()
        navigationTitle = titleString
        self.setViewlayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    func loadViewControls()
    {
        lblTitle = BaseLabel(iLabelType: BaseLabelType.basePrimaryLargeLabelType, iSuperView: self)
        lblTitle.layer.setValue("lblTitle", forKey: layoutTimeConstants.KControlName)
        lblTitle.textColor = UIColor(rgbValue: ColorStyle.white)
        lblTitle.backgroundColor = .clear
        
        btnBack = BaseButton(ibuttonType: BaseButtonType.baseBackButtonType, iSuperView: self)
        btnBack.layer .setValue("btnBack", forKey: layoutTimeConstants.KControlName)
        btnBack.imageForNormal((UIImage(named: "BackArraow")?.maskWithColor(color: .white))!)
        btnBack.imageEdgeInsets = UIEdgeInsets(top:10, left:10, bottom:10, right: 10.0)
        btnBack.backgroundColor = .clear
        
        btnMenu = BaseButton(ibuttonType: BaseButtonType.baseBackButtonType, iSuperView: self)
        btnMenu.layer .setValue("btnMenu", forKey: layoutTimeConstants.KControlName)

        
        btnpopup = BaseButton(ibuttonType: BaseButtonType.baseBackButtonType, iSuperView: self)
        btnpopup.layer .setValue("btnBack", forKey: layoutTimeConstants.KControlName)
        btnpopup.imageForNormal((UIImage(named: "BackArraow")?.maskWithColor(color: .black))!)
        btnpopup.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btnpopup.backgroundColor = .clear
        
        btnfav = BaseButton(ibuttonType: BaseButtonType.baseBackButtonType, iSuperView: self)
       btnfav.layer .setValue("btnBack", forKey: layoutTimeConstants.KControlName)
        btnfav.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right:0)
        btnfav.backgroundColor = UIColor.clear
        
        btnsidebar = BaseButton(ibuttonType: BaseButtonType.baseBackButtonType, iSuperView: self)
        btnsidebar.layer .setValue("btnBack", forKey: layoutTimeConstants.KControlName)
        btnsidebar.imageForNormal((UIImage(named: "download")?.maskWithColor(color: .white))!)
        btnsidebar.imageEdgeInsets = UIEdgeInsets(top: 10, left:10, bottom: 10, right:10)
        btnsidebar.backgroundColor = UIColor.clear
        
        btndownload = BaseButton(ibuttonType: .basePrimaryButtonType, iSuperView: self)
        btndownload.backgroundColor = UIColor.clear
        btndownload.layer.borderColor = UIColor.clear.cgColor
        btndownload.imageForNormal((UIImage(named: "download")?.maskWithColor(color: .white))!)
        //btndownload.addTarget(self, action: #selector(onbtndownloadClick), for: .touchUpInside)
        btndownload.imageEdgeInsets = SystemConstants.IS_IPAD ? UIEdgeInsets (top: 2, left: 2, bottom: 2, right: 2) : UIEdgeInsets (top: 5, left: 5, bottom: 5, right: 5)
        
        btnshare = BaseButton(ibuttonType: .basePrimaryButtonType, iSuperView: self)
        btnshare.backgroundColor = UIColor.clear
        btnshare.layer.borderColor = UIColor.clear.cgColor
        btnshare.imageForNormal((UIImage(named: "share")?.maskWithColor(color: .white))!)
        //btnshare.addTarget(self, action: #selector(onbtnshareClick), for: .touchUpInside)
        btnshare.imageEdgeInsets = SystemConstants.IS_IPAD ? UIEdgeInsets (top: 2, left: 2, bottom: 2, right: 2) : UIEdgeInsets (top: 5, left: 5, bottom: 5, right: 5)
        
        btnpopup .setButtonTouchUpInsideEvent { (sendor, object) in
            if self.menuButtonAction != nil{
                self.menuButtonAction(sendor,object)
            }
        }
        btnfav.setButtonTouchUpInsideEvent { (sendor, object) in
            if self.menuButtonAction != nil{
                self.menuButtonAction(sendor,object)
            }
        }
        
        btndownload.setButtonTouchUpInsideEvent { (sendor, object) in
            if self.menuButtonAction != nil{
                self.menuButtonAction(sendor,object)
            }
        }
        btnshare.setButtonTouchUpInsideEvent { (sendor, object) in
            if self.menushareButton != nil{
                self.menushareButton(sendor,object)
            }
        }


        
        btnsidebar.setButtonTouchUpInsideEvent { (sendor, object) in
            self.endEditing(true)
            //InterfaceUtility.getViewControllerForAlertController()?.view.endEditing(true)
            
       
            //AppUtility.getAppDelegate().slidemenuController.setMenuState(MFSideMenuState.init(1)) {
            
        }
        
        btnBack.setButtonTouchUpInsideEvent { (sendor, object) in
            self.getViewControllerFromSubView()!.navigationController!.popViewController(animated: true)
        }
        
    }
    
    func setViewlayout() {
        
        let layout : MyViewBaseLayout = MyViewBaseLayout()
        layout.viewDictionary = ["btnsidebar" : btnsidebar,
                          "lblTitle" : lblTitle,
                          "btnpopup" : btnpopup]
        
        layout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        layout.metrics = ["horizontalSpace" : 10.0]
        
        //layout.size_Width = NSLayoutConstraint(item: self, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[navigationView]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: nil, views: layout.viewDictionary)
        self.superview!.addConstraints(layout.control_H)
        
        layout.position_Top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.superview!.addConstraints([layout.position_Top])
        
        
        layout.margin_Left = NSLayoutConstraint(item: btnsidebar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10)
        self.addConstraint(layout.margin_Left)
        
        
        layout.margin_Left = NSLayoutConstraint(item: lblTitle, attribute: .leading, relatedBy: .equal, toItem: btnsidebar, attribute: .trailing, multiplier: 1.0, constant: 10)
        self.addConstraint(layout.margin_Left)
        
        layout.margin_Right = NSLayoutConstraint(item: lblTitle, attribute: .trailing, relatedBy: .equal, toItem: btndownload, attribute: .leading, multiplier: 1.0, constant: -10)
        self.addConstraint(layout.margin_Right)

        layout.position_CenterY = NSLayoutConstraint(item: lblTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 10.0)
        self.addConstraint(layout.position_CenterY)
        
        layout.position_CenterY = NSLayoutConstraint(item: btnsidebar, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 10.0)
        self.addConstraint(layout.position_CenterY)
        
        
        
        
        layout.position_Top = NSLayoutConstraint(item: btnBack, attribute: .top, relatedBy: .equal, toItem: btnsidebar, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        layout.margin_Left = NSLayoutConstraint(item: btnBack, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5.0)
        
//        layout.margin_Right = NSLayoutConstraint(item: btnBack, attribute: .trailing, relatedBy: .equal, toItem: btnsidebar, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        
        layout.size_Height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 64.0)
        
        self.addConstraints([layout.margin_Left,layout.size_Height,layout.position_Top])
        
        
        layout.size_Width = NSLayoutConstraint(item: btnpopup, attribute: .width, relatedBy: .equal, toItem: btnpopup, attribute: .height, multiplier: 1.0, constant: 0)
        self.addConstraint(layout.size_Width)
        
        layout.position_CenterY = NSLayoutConstraint(item: btnpopup, attribute: .centerY, relatedBy: .equal, toItem: btnsidebar, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(layout.position_CenterY)
        
        layout.margin_Right = NSLayoutConstraint(item: btnpopup, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10)
        self.addConstraint(layout.margin_Right)
       
        layout.position_CenterY = NSLayoutConstraint(item: btnfav, attribute: .centerY, relatedBy: .equal, toItem: btnsidebar, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(layout.position_CenterY)
        
        layout.margin_Right = NSLayoutConstraint(item: btnfav, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -layoutTimeConstants.KControlLeftRightPadding)
        self.addConstraint(layout.margin_Right)
        
        
        layout.position_CenterY = NSLayoutConstraint(item: btnshare, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant:10)
        layout.position_Right = NSLayoutConstraint(item: btnshare, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant:-10)
        layout.size_Width = NSLayoutConstraint(item: btnshare, attribute: .width, relatedBy: .equal, toItem: btnshare, attribute: .height, multiplier: 1, constant: 0)
        
        self.addConstraints([layout.position_CenterY, layout.position_Right, layout.size_Width])

        
        
        
        layout.position_CenterY = NSLayoutConstraint(item: btndownload, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10)
        layout.position_Right = NSLayoutConstraint(item: btndownload, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: btnshare, attribute: NSLayoutAttribute.left, multiplier: 1, constant:-10)
        layout.size_Width = NSLayoutConstraint(item: btndownload, attribute: .width, relatedBy: .equal, toItem: btndownload, attribute: .height, multiplier: 1, constant: 0)
        
        self.addConstraints([layout.position_CenterY, layout.position_Right, layout.size_Width])
        
        
        
        
    }
    
    // MARK: - Public Interface -
    open func showLeftButton()
    {
        if self.getViewControllerFromSubView()?.navigationController != nil{
            btnBack.isHidden = (self.getViewControllerFromSubView()?.navigationController?.viewControllers.count)! < 2 ? true : false
            btnMenu.isHidden = !btnBack.isHidden
        }
    }
    
    open func setMenuButtonAction(event : @escaping ControlTouchUpInsideEvent){
        menuButtonAction = event
    }
    
    open func setMenuButtonAction1(event : @escaping ControlTouchUpInsideEvent)
    {
        menushareButton = event
    }
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    internal func setCommonProparty() -> Void {
        self.backgroundColor = UIColor(rgbValue: 0xfafafa, alpha: 0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer .setValue("navigationView", forKey: layoutTimeConstants.KControlName)
    }
   
    
}
