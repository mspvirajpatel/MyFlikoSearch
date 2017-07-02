
import UIKit

class DownloadPopUpView: BaseView {

    // Mark: - Attributes -
    
    var container : UIView!
    var progressView : UIProgressView!
    var lblHeader : BaseLabel!
    var lblProgressCounterSize : BaseLabel!
    var lblProgressCounterPersentage : BaseLabel!
    var btnRunAsBackground : UIButton!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
        
        container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        self.addSubview(container)
        
        progressView = UIProgressView(frame: .zero)
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = UIColor(rgbValue:ColorStyle.equacolorsidebar)
        progressView.trackTintColor = UIColor.black
        progressView.layer.cornerRadius = 5
        progressView.layer.masksToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(progressView)
        
        lblHeader = BaseLabel(iLabelType: .basePrimaryLargeLabelType, iSuperView: container)
        lblHeader.textAlignment = .left
        lblHeader.textColor = UIColor.black
        lblHeader.text = NSLocalizedString("downloadpopup", comment: "download")
        
        lblProgressCounterSize = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: container)
        lblProgressCounterSize.textAlignment = .right
        lblProgressCounterSize.text = NSLocalizedString("calculating", comment: "calculate")
        
        lblProgressCounterPersentage = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: container)
        lblProgressCounterPersentage.textAlignment = .left
        lblProgressCounterPersentage.text = "0 %"
        
        btnRunAsBackground = UIButton()
        btnRunAsBackground.translatesAutoresizingMaskIntoConstraints = false
        //btnRunAsBackground.backgroundColor = .black
        btnRunAsBackground.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        btnRunAsBackground.setTitle(NSLocalizedString("runinback", comment: "background run"), for: .normal)
        btnRunAsBackground.titleLabel?.textAlignment = .right
        btnRunAsBackground.titleColor(for: .normal)
        btnRunAsBackground.setTitleColor(UIColor.black, for: .normal)
        //btnRunAsBackground.backgroundColor = UIColor.black
        container.addSubview(btnRunAsBackground)
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["container" : container,
                                     "progressView" : progressView,
                                     "lblHeader" : lblHeader,
                                     "lblProgressCounterSize" : lblProgressCounterSize,
                                     "lblProgressCounterPersentage" : lblProgressCounterPersentage,
                                     "btnRunAsBackground" : btnRunAsBackground]
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        
        let controlTopBottomSecondaryPadding : CGFloat = layoutTimeConstants.KControlTopBottomSecondaryPadding
        let controlLeftRightSecondaryPadding : CGFloat = layoutTimeConstants.KControlLeftRightSecondaryPadding
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding,
                              "controlTopBottomSecondaryPadding" : controlTopBottomSecondaryPadding,
                              "controlLeftRightSecondaryPadding" : controlLeftRightSecondaryPadding]
        
        //Container View
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[container]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.position_CenterY = NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(baseLayout.position_CenterY)
        
        //lblHeader 
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[lblHeader]-controlLeftRightPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        container.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[progressView]-controlLeftRightPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        container.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-controlLeftRightPadding-[lblProgressCounterPersentage]-controlLeftRightPadding-[lblProgressCounterSize]-controlLeftRightPadding-|", options: [.alignAllTop], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        container.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[btnRunAsBackground(200)]-controlLeftRightPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        container.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[lblHeader]-controlTopBottomPadding-[progressView(5)]-controlTopBottomPadding-[lblProgressCounterPersentage]-30-[btnRunAsBackground(40)]-controlTopBottomPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        container.addConstraints(baseLayout.control_V)
        
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    func btnTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    // MARK: - Server Request -

}
