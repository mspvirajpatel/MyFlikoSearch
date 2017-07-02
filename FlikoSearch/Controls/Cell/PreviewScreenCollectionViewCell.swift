

import UIKit

class PreviewScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Attributes -
    
    var imageClick : BaseImageView!
    var btnFavourite : UIButton!
    var layout : MyViewBaseLayout!

    
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
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        imageClick = BaseImageView(iImageViewType: .baseProfileImageViewType, iSuperView:self.contentView)
        imageClick.isUserInteractionEnabled = true
        imageClick.contentMode = .scaleAspectFill
        imageClick.backgroundColor = UIColor.clear
        
        
        btnFavourite = UIButton(frame: CGRect.zero)
        btnFavourite.imageForNormal((UIImage(named: "starFavourite")?.maskWithColor(color: .white))!)
        
        btnFavourite.translatesAutoresizingMaskIntoConstraints = false
        btnFavourite.backgroundColor = .clear
        self.contentView.addSubview(btnFavourite)
        
        
        
    }
    
    
    func setViewControlsLayout() {
        
        layout = MyViewBaseLayout()
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        
        let KButtonHeightWidth : CGFloat = CGFloat(SystemConstants.IS_IPAD ? layoutTimeConstants.kpreviewbuttonheightwidthipad : layoutTimeConstants.kpreviewbuttonheightwidthipad)
        
        
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
    
    
}
