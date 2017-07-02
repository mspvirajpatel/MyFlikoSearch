
import UIKit

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    // MARK: - Interface
    @IBInspectable open var clearBackTitle: Bool = true
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultParameters()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Layout - 
    
    
    
    // MARK: - Public Interface -
    
    func setDefaultParameters(){
        
       // self.edgesForExtendedLayout = UIRectEdge.none
        self.navigationBar.isTranslucent = false
        
        if(self.responds(to: (#selector(getter: UINavigationController.interactivePopGestureRecognizer)))){
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        let navigationBarFont: UIFont! = UIFont(fontString: "AppleSDGothicNeo-Medium;17")
        
        let navigationAttributeDictionary = [NSForegroundColorAttributeName: UIColor(rgbValue: ColorStyle.KAppFontColor, alpha: 1.0),
                                             NSFontAttributeName: navigationBarFont] as [String : Any];
        
        UINavigationBar.appearance().titleTextAttributes = navigationAttributeDictionary
        self.navigationBar.tintColor = UIColor(rgbValue: ColorStyle.KAppFontColor, alpha: 1.0)
        
        self.navigationBar.barTintColor = UIColor(rgbValue: ColorStyle.KAppBackgroundColor)
        self.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.clear
        
       // self.navigationBar.setBottomBorder(UIColor(rgbValue: ColorConstants.KPrimaryButtonColor, alpha: 1.0), width: 1.0)
      
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    func setPopOverParameters(){
        
    }
    
    // MARK: - User Interaction -
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        controlClearBackTitle()
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func show(_ vc: UIViewController, sender: Any?) {
        controlClearBackTitle()
        super.show(vc, sender: sender)
    }
    
    // MARK: - Internal Helpers -
}

extension BaseNavigationController {
    
    func controlClearBackTitle() {
        if self.clearBackTitle {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
}
