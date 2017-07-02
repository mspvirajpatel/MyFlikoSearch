
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class BaseViewController: UIViewController, UINavigationControllerDelegate {

    var baseLayout : MyViewBaseLayout!
    var aView : BaseView!
    
    private var btnName: UIButton!
    
    var navigationTitleString : String!

    var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
    
    
    // MARK: - Lifecycle -
    
    init(){
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom

    }
    
    init(iView: BaseView){
        
        super.init(nibName: nil, bundle: nil)
        aView = iView
        modalPresentationStyle = .custom
    }
    
    init(iView: BaseView, andNavigationTitle titleString: String){
        
        super.init(nibName: nil, bundle: nil)
        aView = iView
        
        navigationTitleString = titleString
              
        AppUtility.executeTaskInMainQueueWithCompletion { 
            self.navigationItem.title = self.navigationTitleString
        }
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
       
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            self.navigationItem.title = self.navigationTitleString
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setKeyboardObserver()
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            self.navigationItem.title = self.navigationTitleString
           
          
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardObserver()
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            self.navigationItem.title = self.navigationTitleString
            
            self.aView.endEditing(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
        self.removeKeyboardObserver()
    }
    
    deinit{
        
        aView = nil
        navigationTitleString = nil
        
        baseLayout = nil
        
        self.removeNotificationObserver()
        self.removeKeyboardObserver()
    }
    
    // MARK: - Layout - 
    
    func loadViewControls(){
        
        self.view.backgroundColor = UIColor(rgbValue: ColorStyle.KAppBackgroundColor, alpha: 1.0)
        
        self.view.addSubview(aView)
        self.view.isExclusiveTouch = true
        
        self.view.isMultipleTouchEnabled = true
    }
    
    func setViewlayout(){
        
        if SystemConstants.KHidelayoutArea {
            self.view.backgroundColor = UIColor.yellow
        }
        
        /*  baseLayout Allocation   */
        
        baseLayout = MyViewBaseLayout()
        
    }
    
    func expandViewInsideView(){
        baseLayout.expandView(aView, insideView: self.view)
    }
    
    
    // MARK: - Public Interface -
    
    func setNotificationObserver(){
        aView .setNotificationObserver()

    }
    
    func removeNotificationObserver(){
 
    }
    
    func setKeyboardObserver(){
  
    }
    
    func removeKeyboardObserver(){
   
    }
    

    func addGesture() {
        
        guard navigationController?.viewControllers.count > 1 else {
            return
        }
        
    }

    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // Mark - UINavigationControllerDelegate
    
   
}


