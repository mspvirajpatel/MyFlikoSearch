

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Attributes -
    
    var imgUser : BaseImageView!
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
    
    
    // MARK: - Layout -
    
    func loadViewControls()
    {
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        imgUser = BaseImageView(iImageViewType: .baseProfileImageViewType, iSuperView:self.contentView)
        imgUser.isUserInteractionEnabled = true
        imgUser.layer.masksToBounds = true
        imgUser.clipsToBounds = true
        imgUser.layer.cornerRadius = CGFloat(layoutTimeConstants.imgUsercornerradius)
        imgUser.contentMode = .scaleAspectFill
        imgUser.backgroundColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        
        btnFavourite = UIButton(frame: CGRect.zero)
        btnFavourite.translatesAutoresizingMaskIntoConstraints = false
        btnFavourite.backgroundColor = .clear
        btnFavourite.imageForNormal((UIImage(named: "lock")?.maskWithColor(color: .white))!)
        self.contentView.addSubview(btnFavourite)
        
        
    }
    
    func setViewControlsLayout()
    {
        layout = MyViewBaseLayout()
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        
        let KButtonHeightWidth : CGFloat = CGFloat(SystemConstants.IS_IPAD ? layoutTimeConstants.KButtonHeightWidthipad : layoutTimeConstants.KButtonHeightWidthiphone)
        
        layout.position_Top = NSLayoutConstraint(item: imgUser, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant:0)
        
        layout.position_Left = NSLayoutConstraint(item: imgUser, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.left, multiplier: 1, constant:0)
        
        layout.position_Right = NSLayoutConstraint(item: imgUser, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.right, multiplier: 1, constant:0)
        
        layout.size_Height = NSLayoutConstraint(item: imgUser, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:self.contentView, attribute: NSLayoutAttribute.height, multiplier: 1, constant:0)
        
        self.contentView.addConstraints([layout.position_Top, layout.position_Left, layout.position_Right,layout.size_Height])
        
        layout.position_Top = NSLayoutConstraint(item: btnFavourite, attribute: .top, relatedBy: .equal, toItem: imgUser, attribute: .top, multiplier: 1.0, constant: controlTopBottomPadding)
        self.contentView.addConstraint(layout.position_Top)
        
        layout.position_Right = NSLayoutConstraint(item: btnFavourite, attribute: .trailing, relatedBy: .equal, toItem: imgUser, attribute: .trailing, multiplier: 1.0, constant: (-1 * controlLeftRightPadding))
        self.contentView.addConstraint(layout.position_Right)
        
        layout.size_Height = NSLayoutConstraint(item: btnFavourite, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: KButtonHeightWidth)
        self.contentView.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: btnFavourite, attribute: .width, relatedBy: .equal, toItem: btnFavourite, attribute: .height, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(layout.size_Width)
        
    }
}
