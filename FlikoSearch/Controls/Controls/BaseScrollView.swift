

import UIKit

enum BaseScrollViewType : Int {
    
    case baseVerticalScrollViewType = 1
    case baseHorizontalScrollViewType
    
}

class BaseScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Attributes -
    
    var container : UIView!
    var baseLayout : MyViewBaseLayout!
    
    var lastViewConstraint : NSLayoutConstraint!
    var viewType : BaseScrollViewType = .baseVerticalScrollViewType
    
    var didScrollEvent : ScrollViewDidScrollEvent!
    
    // MARK: - Lifecycle -
    
    init() {
        super.init(frame: CGRect.zero)
        
        viewType = .baseVerticalScrollViewType
        self.loadViewControls()
        self.setLayout()
        
    }
    
    init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        viewType = .baseVerticalScrollViewType
        self.loadViewControls()
        self.setLayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
        }
    }
    
    init(iViewType : BaseScrollViewType, iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        viewType = iViewType
        self.loadViewControls()
        self.setLayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        var iContentSize : CGSize? = CGSize.zero
        
        switch viewType {
        case .baseVerticalScrollViewType:
            
            iContentSize = CGSize(width: 0, height: container.frame.size.height);
            self.contentSize = iContentSize!
            
            break
            
        case .baseHorizontalScrollViewType:
            
            break
            
        }
    }
    
    deinit{
        container = nil
        baseLayout = nil
        lastViewConstraint = nil
    }
    
    // MARK: - Layout -
    
    func loadViewControls(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        /*  container Allocation   */
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
        
    }
    
    func setLayout(){
        
        if(SystemConstants.KHidelayoutArea){
            container.backgroundColor = UIColor.black
        }
        
        baseLayout = MyViewBaseLayout()
        baseLayout.viewDictionary = ["container" : container,
                                 "self" : self]
        
        /*     container Layout     */
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container(==self)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
    }
    
    // MARK: - Public Interface -
    
    func clearErrorBorder(){
        
        for view : UIView in container.subviews {
            
            if(view.isKind(of: UITextField.self) ||
                view.isKind(of: UITextView.self)){
                
            }
            
        }
        
    }
    
    func setScrollViewContentSize(){
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            
            if(self.lastViewConstraint != nil){
                self.removeConstraint(self.lastViewConstraint)
            }
            
            var visibleSubView : UIView? = nil
            let subViewCount : Int = (self.container.subviews.count)
            
            for i in stride(from: (subViewCount - 1), to: 0, by: -1){
                
                visibleSubView = self.container.subviews[i]
                if(visibleSubView?.isHidden == false){
                    break
                }
                
            }
            
            self.lastViewConstraint = NSLayoutConstraint.init(item: self.container, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: visibleSubView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
            self.addConstraint(self.lastViewConstraint)
            
            self.layoutSubviews()
            self.baseLayout = nil
            
        }
        
    }
    
    // MARK: - User Interaction -
    
    private func setScrollViewDidScrollEvent(_ event : @escaping ScrollViewDidScrollEvent){
        didScrollEvent = event
    }
    
    // MARK: - Internal Helpers -
    
    
    
    // MARK: - UIScrollViewDelegate Methods -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if(didScrollEvent != nil){
            setScrollViewDidScrollEvent({ (scrollView, nil) in
                
            })
        }
        
    }
    
}
