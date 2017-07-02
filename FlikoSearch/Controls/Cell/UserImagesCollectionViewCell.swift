

import UIKit

class UserImagesCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    
    // MARK: - Attributes -
    
    var imageClick : BaseImageView!
    var btnFavourite : UIButton!
    var layout : MyViewBaseLayout!
    //var zoomscroll : BaseZoomingScrollView!
//    var  minimum : CGFloat = 1
//    var maximum : CGFloat = 10
    
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.loadViewControls()
        self.setViewControlsLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    func loadViewControls()
    {
        self.contentView.backgroundColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        self.contentView.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        
//        zoomscroll = BaseZoomingScrollView()
//        zoomscroll.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(zoomscroll)
//        zoomscroll.backgroundColor = UIColor.red
//        zoomscroll.clipsToBounds = true
        
//        zoomscroll.alwaysBounceVertical = false
//        zoomscroll.alwaysBounceHorizontal = false
//        zoomscroll.showsVerticalScrollIndicator = false
//        zoomscroll.flashScrollIndicators()
//        zoomscroll.isPagingEnabled = true
//        zoomscroll.bounces = false
        
        imageClick = BaseImageView(iImageViewType: .baseProfileImageViewType, iSuperView:self.contentView)
        imageClick.isUserInteractionEnabled = true
        imageClick.backgroundColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        imageClick.contentMode = .scaleAspectFill
        imageClick.backgroundColor = UIColor.clear
        imageClick.clipsToBounds = true
        
        
        btnFavourite = UIButton(frame: CGRect.zero)
        btnFavourite.imageForNormal((UIImage(named: "lock")?.maskWithColor(color: .white))!)
        
        btnFavourite.translatesAutoresizingMaskIntoConstraints = false
        btnFavourite.backgroundColor = .clear
        self.contentView.addSubview(btnFavourite)
        
//        var pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomImage))
//        self.imageClick.gestureRecognizers = [pinch]
//        self.imageClick.isUserInteractionEnabled = true
//        self.zoomscroll.delegate = self
        
        
        
    }
    
    
    func setViewControlsLayout() {
        
        layout = MyViewBaseLayout()
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        
        let KButtonHeightWidth : CGFloat = CGFloat(SystemConstants.IS_IPAD ? layoutTimeConstants.kpreviewbuttonheightwidthipad : layoutTimeConstants.kpreviewbuttonheightwidthipad)
        
        //layout.expandView(zoomscroll, insideView: self.contentView)
        layout.expandView(imageClick, insideView: self.contentView)
        
        layout.position_Top = NSLayoutConstraint(item: btnFavourite, attribute: .top, relatedBy: .equal, toItem: imageClick, attribute: .top, multiplier: 1.0, constant: controlTopBottomPadding)
        self.contentView.addConstraint(layout.position_Top)
        
        layout.position_Right = NSLayoutConstraint(item: btnFavourite, attribute: .trailing, relatedBy: .equal, toItem: imageClick, attribute: .trailing, multiplier: 1.0, constant: (-1 * controlLeftRightPadding))
        self.contentView.addConstraint(layout.position_Right)
        
        layout.size_Height = NSLayoutConstraint(item: btnFavourite, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: KButtonHeightWidth)
        self.contentView.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: btnFavourite, attribute: .width, relatedBy: .equal, toItem: btnFavourite, attribute: .height, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(layout.size_Width)
        
        
    }
    
       
    public func viewForZoomingInScrollView(_scrollView: UIScrollView) -> UIView? {
        return self.imageClick
    }
    
    
    
    
}
