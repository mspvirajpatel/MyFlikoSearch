
import UIKit
import Foundation
import Kingfisher

import CoreLocation
import FlickrKit

class FlickrUsrListView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSourcePrefetching{
    
    
    // MARK : - Attributes -
    
    var collectionView : UICollectionView!
    var layout : MyViewBaseLayout!
    var photo : [Photo]!
    var arrResponse : NSMutableArray!
    var curlat : Double? = nil
    var curlng : Double? = nil
    var markerIndex : Int!
    var swipeAd : Int = 0
    var lastContentOffset : CGFloat!
    var isRequestLoding : Bool = false
    
    var isLoadingNewpage : Bool = false
    var btnwallpaper : BaseButton!
    var previewView : UIView!
    var btnlock : BaseButton!
    var btndownload : BaseButton!
    var btnshare : BaseButton!
    var lblflicker : BaseLabel!
    var lbluser : BaseLabel!
    var lblPhotoBy : BaseLabel!
    var lineView : UIView!
    var imglock : BaseImageView!
    var imgwallpaper : BaseImageView!
    var photosmodel : Photos!
    var imageIndex : Int!
    var imageUrl : URL? = nil
    var isFromFavourite : Bool!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    var btnTouchupshareInside : ControlTouchUpInsideEvent!
    var arrFavoriteKey : [String] = [String]()
    var imgheart : BaseImageView!
    var lblviews : BaseLabel!
    var lbldistance : BaseLabel!
    var lbltime : BaseLabel!
    var btnpreviewtopbottom : BaseButton!
    private var isupaerrow : Bool = true
    var previewviewconstraint : NSLayoutConstraint!
    var desctiptiontextView : UITextView!
    var strcurlat : String!
    var strcurlng : String!
    var strperpage : Int!
    var strpageCount : Int!
    
    var  minimum : CGFloat = 1
    var maximum : CGFloat = 5
    var cell5 : UserImagesCollectionViewCell!
  
    var lblphotoby : BaseLabel!
    
    
    init(model: [Any])
    {
        super.init(withBack: false, titleString:NSLocalizedString("list", comment: ""))
        
        markerIndex = model.first as! Int!
        imageIndex = model.first as! Int!
        self.loadViewControls()
        self.setViewlayout()
        photosmodel = model.last as! Photos!
        print(markerIndex)
        
        curlat = UserDefaults.standard.object(forKey: "curLat") as! Double?
        curlng = UserDefaults.standard.object(forKey: "curLng") as! Double?
        
        
        strperpage = UserDefaults.standard.object(forKey: "pagenum") as! Int!
        strpageCount = 100
        
        self.strcurlat = String(describing: self.curlat!)
        self.strcurlng = String(describing: self.curlng!)
        
        print(curlat)
        print(curlng)
        
        let tapgesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapClick))
        self.addGestureRecognizer(tapgesture)
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        AppUtility.executeTaskInMainQueueWithCompletion {
            
            print(self.imageIndex)
            
            self.markerIndex = self.imageIndex
            if let indexPath : NSIndexPath = NSIndexPath(row:self.markerIndex, section: 0) as NSIndexPath! {
                self.layoutIfNeeded()
                self.lblviews.text = self.photosmodel.photo[self.markerIndex].views
                
                
                let lng : String = self.photosmodel.photo[self.markerIndex].longitude
                let lat : String = self.photosmodel.photo[self.markerIndex].latitude
                let latitude : Double = Double(lat)!
                let longitude : Double = Double(lng)!
                let userCordinate = CLLocation(latitude:latitude, longitude:longitude)
                let currentCordinate = CLLocation(latitude: self.curlat!, longitude: self.curlng!)
                
                let distanceInMeters = userCordinate.distance(from: currentCordinate)
                
                if (distanceInMeters < 500)
                {
                    let strformat  = String(format: "%.2f", distanceInMeters)
                    self.lbldistance.text = "\(strformat) m"
                }
                else
                {
                    let strformat  = String(format: "%.2f", (distanceInMeters/1000))
                    self.lbldistance.text = "\(strformat) km"
                    
                }
                
                let timestamp = Double(self.photosmodel.photo[self.markerIndex].dateupload)
                
                print(timestamp)
                
                let date : NSDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp!))
                let ago = self.timeAgoSinceDate(date: date, numericDates: true)
                print("Output is: \"\(ago)\"")
                self.navigationView.lblTitle.textColor = UIColor(rgbValue: ColorStyle.white)
                self.lbltime.text = ago
                //self.bringSubview(toFront: self.navigationView)
                self.navigationView.lblTitle.text = self.photosmodel.photo[self.markerIndex].ownername
                
                 self.lblphotoby.text = "Photo by:\(self.photosmodel.photo[self.markerIndex].ownername)"
                self.lbluser.text = self.photosmodel.photo[self.markerIndex].title
                let dictdist : NSDictionary = self.photosmodel.photo[self.markerIndex].descriptionn
                
                if dictdist["_content"] != nil {
                    self.desctiptiontextView.text = dictdist.object(forKey: "_content") as! String!
                    
                }
                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
        self.backgroundColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        let collectionViewLayout :UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 00, bottom: 0, right: 00)
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.register(UserImagesCollectionViewCell.self, forCellWithReuseIdentifier:CellIdentifierConstants.userimagescell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.flashScrollIndicators()
       // zoomscroll.isPagingEnabled = true
        //collectionView.bounces = false
        
        previewView = UIView()
        previewView.backgroundColor = UIColor(rgbValue:ColorStyle.gray, alpha: 0.7)
        self.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        self.bringSubview(toFront: previewView)
        
        btnpreviewtopbottom = BaseButton(ibuttonType:.baseCloseButtonType, iSuperView: self)
        //btnpreviewtopbottom.setBackgroundImage((UIImage(named: "upaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
        btnpreviewtopbottom.setImage((UIImage(named: "upaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
        btnpreviewtopbottom.contentHorizontalAlignment = .center
        btnpreviewtopbottom.addTarget(self, action: #selector(onbtnpreviewtopbottomClick), for: .touchUpInside)
        btnpreviewtopbottom.layer.cornerRadius = 15
        btnpreviewtopbottom.imageEdgeInsets = SystemConstants.IS_IPAD ? UIEdgeInsets (top: 4, left: 4, bottom: 4, right: 4) : UIEdgeInsets (top: 8, left:8, bottom: 8, right: 8)
        //btnpreviewtopbottom.backgroundColor = UIColor.red
        //btnpreviewtopbottom.isEnabled = false
        
        
        lbluser = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: previewView)
        lbluser.textAlignment = .left
        lbluser.textColor = UIColor(rgbValue: ColorStyle.white)
        lbluser.numberOfLines = 0
        lbluser.sizeToFit()
        
        lblphotoby = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: previewView)
        lblphotoby.textAlignment = .left
        lblphotoby.textColor = UIColor(rgbValue: ColorStyle.white)
        lblphotoby.numberOfLines = 0
        lblphotoby.sizeToFit()
        
        imgheart = BaseImageView(iImageViewType: .baseDefaultImageViewType, iSuperView: previewView)
        imgheart.image = (UIImage(named: "heart")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white)))
        
        lblviews = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: previewView)
        lblviews.textAlignment = .left
        lblviews.textColor = UIColor(rgbValue: ColorStyle.white)
        
        lbldistance = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: previewView)
        lbldistance.textAlignment = .center
        lbldistance.textColor = UIColor(rgbValue: ColorStyle.white)
        
        lbltime = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: previewView)
        lbltime.textAlignment = .right
        lbltime.textColor = UIColor(rgbValue: ColorStyle.white)
        
        
        lineView = UIView()
        lineView.backgroundColor = UIColor(rgbValue: ColorStyle.equacolorsidebar)
        previewView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.bringSubview(toFront: lineView)
        
        
        desctiptiontextView = UITextView()
        desctiptiontextView.backgroundColor = UIColor.clear
        desctiptiontextView.translatesAutoresizingMaskIntoConstraints = false
        desctiptiontextView.isEditable = false
        desctiptiontextView.textColor = UIColor(rgbValue: ColorStyle.white)
        previewView.addSubview(desctiptiontextView)
        
        self.backgroundColor = UIColor(rgbValue: ColorStyle.white)
        
        
        self.bringSubview(toFront: self.navigationView)
        self.navigationView.btnMenu.isHidden = true
        self.navigationView.btnpopup.isHidden = true
        self.navigationView.btnsidebar.isHidden = true
        self.navigationView.btnfav.isHidden = false
        self.navigationView.btnBack.isHidden = false
        self.navigationView.btnshare.isHidden = false
        self.navigationView.btndownload.isHidden = false
        self.navigationView.btnBack.imageForNormal((UIImage(named: "BackArraow")?.maskWithColor(color: .white))!)
        self.navigationView.backgroundColor = UIColor(rgbValue:ColorStyle.gray, alpha: 0.7)
       // self.navigationView.btnimguser.isHidden = true
        //self.navigationView.lblTitle.isHidden = false
        //self.navigationView.backgroundColor = UIColor(rgbValue:ColorStyle.white, alpha: 0.4)
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["previewView" : previewView,
                                     "lineView" : lineView,
        ]
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlTopBottomSecondaryPadding : CGFloat = layoutTimeConstants.KControlTopBottomSecondaryPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        let controlLeftRightSecondaryPadding : CGFloat = layoutTimeConstants.KControlLeftRightSecondaryPadding
        
        let KpreviewViewHeight : CGFloat = CGFloat(SystemConstants.IS_IPAD ? 130: layoutTimeConstants.kpreviewviewiphoneheight)
        let KButtonHeightWidth : CGFloat = CGFloat(SystemConstants.IS_IPAD ? layoutTimeConstants.kpreviewbtnheightipad : layoutTimeConstants.kpreviewbtnheightiphone)
        
        let displaypreviewView : CGFloat = 45
        let imgherattoppading : CGFloat = 5
        let imghertleftrightpading : CGFloat = 10
        let imgheratwidthheight : CGFloat = 20
        let lblviewswidthheight : CGFloat = 40
        let lbldustancewidth : CGFloat = 100
        let lbltimewidth : CGFloat = 120
        let btnpreviewtop : CGFloat = 2
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlTopBottomSecondaryPadding" : controlTopBottomSecondaryPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding,
                              "controlLeftRightSecondaryPadding" : controlLeftRightSecondaryPadding,
                              "KpreviewViewHeight" : KpreviewViewHeight,
                              "KButtonHeightWidth" : KButtonHeightWidth]
        
        
        baseLayout.expandView(collectionView, insideView: self)
        
        //previewView
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[previewView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(1)][previewView(KpreviewViewHeight)]", options: [.alignAllLeft, .alignAllRight], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        self.previewviewconstraint = NSLayoutConstraint(item: previewView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:-displaypreviewView)
        self.addConstraint(self.previewviewconstraint)
        
        
        baseLayout.position_Top = NSLayoutConstraint(item: imgheart, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.top, multiplier: 1, constant:4)
        baseLayout.position_Left = NSLayoutConstraint(item: imgheart, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.left, multiplier: 1, constant:imghertleftrightpading)
        baseLayout.size_Width = NSLayoutConstraint(item: imgheart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant:imgheratwidthheight)
        baseLayout.size_Height = NSLayoutConstraint(item: imgheart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:imgheratwidthheight)
        
        previewView.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])
        
        baseLayout.position_Top = NSLayoutConstraint(item: lblviews, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.top, multiplier: 1, constant:imgherattoppading)
        baseLayout.position_Left = NSLayoutConstraint(item: lblviews, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: imgheart, attribute: NSLayoutAttribute.right, multiplier: 1, constant:imgherattoppading)
        baseLayout.size_Width = NSLayoutConstraint(item: lblviews, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant:lblviewswidthheight)
        baseLayout.size_Height = NSLayoutConstraint(item: lblviews, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:imgheratwidthheight)
        
        previewView.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])
        
        baseLayout.position_Top = NSLayoutConstraint(item: lbldistance, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        baseLayout.position_Left = NSLayoutConstraint(item: lbldistance, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: lblviews, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant:0)
        baseLayout.size_Width = NSLayoutConstraint(item: lbldistance, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant:lbldustancewidth)
        baseLayout.size_Height = NSLayoutConstraint(item: lbldistance, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:imgheratwidthheight)
        
        previewView.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])
        
        baseLayout.position_Top = NSLayoutConstraint(item: lbltime, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.top, multiplier: 1, constant:imgherattoppading)
        baseLayout.position_Left = NSLayoutConstraint(item: lbltime, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: previewView, attribute: NSLayoutAttribute.right, multiplier: 1, constant:-imghertleftrightpading)
        baseLayout.size_Width = NSLayoutConstraint(item: lbltime, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant:lbltimewidth)
        baseLayout.size_Height = NSLayoutConstraint(item: lbltime, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:imgheratwidthheight)
        
        previewView.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])
        
        
        
        baseLayout.position_Top = NSLayoutConstraint(item:lbluser, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imgheart, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:-8)
        baseLayout.position_Left = NSLayoutConstraint(item: lbluser, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: NSLayoutAttribute.left, multiplier: 1, constant:imghertleftrightpading)
        baseLayout.size_Width = NSLayoutConstraint(item: lbluser, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -imghertleftrightpading)
        baseLayout.size_Height = NSLayoutConstraint(item: lbluser, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:lblviewswidthheight)
        
        self.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])
        
        
        baseLayout.position_Top = NSLayoutConstraint(item:lblphotoby, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: lbluser, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:-2)
        baseLayout.position_Left = NSLayoutConstraint(item: lblphotoby, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: NSLayoutAttribute.left, multiplier: 1, constant:imghertleftrightpading)
        baseLayout.size_Width = NSLayoutConstraint(item: lblphotoby, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -imghertleftrightpading)
        baseLayout.size_Height = NSLayoutConstraint(item: lblphotoby, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:15)
        
        self.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.size_Width,baseLayout.size_Height])

        
        baseLayout.position_Top = NSLayoutConstraint(item:desctiptiontextView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: lblphotoby, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:0)
        baseLayout.position_Left = NSLayoutConstraint(item: desctiptiontextView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: NSLayoutAttribute.left, multiplier: 1, constant:7)
        baseLayout.position_Right = NSLayoutConstraint(item: desctiptiontextView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem:self.previewView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -imghertleftrightpading)
        baseLayout.position_Bottom = NSLayoutConstraint(item: desctiptiontextView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem:self.previewView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -imghertleftrightpading)
        
        self.addConstraints([baseLayout.position_Top, baseLayout.position_Left,baseLayout.position_Right,baseLayout.position_Bottom])
        
        
        baseLayout.position_Bottom = NSLayoutConstraint(item: btnpreviewtopbottom, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: lineView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -btnpreviewtop)
        baseLayout.position_CenterX = NSLayoutConstraint(item: btnpreviewtopbottom, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: lineView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        baseLayout.size_Width = NSLayoutConstraint(item: btnpreviewtopbottom, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant:displaypreviewView)
        baseLayout.size_Height = NSLayoutConstraint(item: btnpreviewtopbottom, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant:displaypreviewView)
        self.addConstraints([baseLayout.position_Bottom,baseLayout.position_CenterX,baseLayout.size_Width,baseLayout.size_Height])
        
        

    }
    
    // MARK: - Internal Helpers -
    
    
    /**
     This Method Is used for get image for 50*50 scale size for marker
     */
    
    func scale(_ originalImage: UIImage, scaledTo size: CGSize) -> UIImage {
        if originalImage.size.equalTo(size) {
            return originalImage
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        originalImage.draw(in: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(size.width), height: CGFloat(size.height)))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /**
     This Method Is used for Cretae time stamp
     */
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    func geturlarrayfrommodel(photomodel:Photo) -> NSMutableArray {
        
        let arrmain :NSMutableArray = []
        
        if let url : URL = URL(string: photomodel.url_o) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_o) x \(photomodel.height_o)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        if let url : URL = URL(string: photomodel.url_l) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_l) x \(photomodel.height_l)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_c) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_c) x \(photomodel.height_c)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_z) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_z) x \(photomodel.height_z)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_n) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_n) x \(photomodel.height_n)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_m) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_m) x \(photomodel.height_m)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_q) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_q) x \(photomodel.height_q)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_s) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_s) x \(photomodel.height_s)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_t) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_t) x \(photomodel.height_t)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        if let url : URL = URL(string: photomodel.url_sq) {
            
            let dictrespo : NSMutableDictionary = NSMutableDictionary()
            let strsize : String = "\(photomodel.width_sq) x \(photomodel.height_sq)"
            dictrespo.setObject(strsize, forKey: "size" as NSCopying)
            dictrespo.setObject(url, forKey: "URL" as NSCopying)
            arrmain.add(dictrespo)
            
            
        }
        
        return arrmain
    }
    
    func getURLforCollection(photo : Photo) -> String {
        
        if SystemConstants.IS_IPAD {
            
            if let _ : URL = URL(string: photo.url_l) {
                return photo.url_l
            }
            else if let _ : URL = URL(string: photo.url_o) {
                return photo.url_o
            }
            else if let _ : URL = URL(string: photo.url_z) {
                return photo.url_z
            }
        }
        else {
            if let _ : URL = URL(string: photo.url_z) {
                return photo.url_z
            }
            else if let _ : URL = URL(string: photo.url_l) {
                return photo.url_l
            }
            else if let _ : URL = URL(string: photo.url_o) {
                return photo.url_o
            }
            else if let _ : URL = URL(string: photo.url_m) {
                return photo.url_m
            }
        }
        return ""
    }
    
    
    //MARK: - User Intercation  -
    
    
    func btnTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    func btnsharetapped(event: @escaping ControlTouchUpInsideEvent)
    {
        btnTouchupshareInside = event
        
    }
    
    
    func onpreviewhideshowclick()
    {
        
        if self.navigationView.isHidden == true
        {
            
            UIView.animate(withDuration: 0.5) {
              //  self.constantBannerBottom.constant = 66
                
                //             self.colectiontopconstraint = NSLayoutConstraint(item: self.photoCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:self.bannerView, attribute: NSLayoutAttribute.bottom, multiplier: 1,constant: 10)
                
                self.layoutSubviews()
                self.layoutIfNeeded()
            }
            
        }
        else
        {
            
            UIView.animate(withDuration: 0.5) {
               // self.constantBannerBottom.constant = 0
                
                //             self.colectiontopconstraint = NSLayoutConstraint(item: self.photoCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:self.bannerView, attribute: NSLayoutAttribute.bottom, multiplier: 1,constant: 10)
                
                self.layoutSubviews()
                self.layoutIfNeeded()
            }
            
            
        }

        
        
    }
    
    
    func onTapClick()
    {
        if self.navigationView.isHidden == true
        {
            
            UIView.animate(withDuration: 0.5) {
             //   self.constantBannerBottom.constant = 66
                
                //             self.colectiontopconstraint = NSLayoutConstraint(item: self.photoCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:self.bannerView, attribute: NSLayoutAttribute.bottom, multiplier: 1,constant: 10)
                
                self.layoutSubviews()
                self.layoutIfNeeded()
            }
            
            self.previewView.isHidden = false
            self.navigationView.isHidden = false
            self.btnpreviewtopbottom.isHidden = false
            
        }
        else
        {
            
            UIView.animate(withDuration: 0.5) {
                
                //             self.colectiontopconstraint = NSLayoutConstraint(item: self.photoCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:self.bannerView, attribute: NSLayoutAttribute.bottom, multiplier: 1,constant: 10)
                
                self.layoutSubviews()
                self.layoutIfNeeded()
            }

            
            
            self.previewView.isHidden = true
            self.navigationView.isHidden = true
            self.btnpreviewtopbottom.isHidden = true
        }
        
        
        
    }
    
    func onbtnpreviewtopbottomClick()
    {
        if isupaerrow == true
        {
            self.removeConstraint(self.previewviewconstraint)
            self.setViewlayout()
            //self.updateConstraints()
            self.isupaerrow = false
            
            //self.onTapClick()
            
            //self.onpreviewhideshowclick()
           
//            
//            constantBannerBottom = NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: SystemConstants.IS_IPAD ? 66 : 66)
//            self.addConstraint(constantBannerBottom)
//            
            
            //self.constantBannerBottom.constant = 116
            self.previewviewconstraint = NSLayoutConstraint(item: self.previewView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:-130)
            self.addConstraint(self.previewviewconstraint)
            //self.updateConstraints()
            UIView.animate(withDuration:0.7) {
                
//                 self.removeConstraint(self.constantBannerBottom)
//                
//                self.constantBannerBottom = NSLayoutConstraint(item: self.bannerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: SystemConstants.IS_IPAD ? 66 : 66)
//                self.addConstraint(self.constantBannerBottom)
                 //self.constantBannerBottom.constant = 66
                self.layoutIfNeeded()
                //self.layoutSubviews()
                //self.updateConstraints()
                //self.btnpreviewtopbottom.setBackgroundImage((UIImage(named: "downaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
                 self.btnpreviewtopbottom.setImage((UIImage(named: "downaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
            }
            
            self.layoutSubviews()
            self.layoutIfNeeded()
        }
        else
        {
            self.isupaerrow = true
             //self.onpreviewhideshowclick()
            //self.onTapClick()
            self.removeConstraint(self.previewviewconstraint)
            //self.constantBannerBottom.constant = 66
            self.previewviewconstraint = NSLayoutConstraint(item: self.previewView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:-45)
            self.addConstraint(self.previewviewconstraint)
            
            UIView.animate(withDuration:0.7) {
//                
//                self.removeConstraint(self.constantBannerBottom)
//                
//                self.constantBannerBottom = NSLayoutConstraint(item: self.bannerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: SystemConstants.IS_IPAD ? 66 : 66)
//                self.addConstraint(self.constantBannerBottom)

                 //self.constantBannerBottom.constant = 116
                self.layoutIfNeeded()
                //self.btnpreviewtopbottom.setBackgroundImage((UIImage(named: "upaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
                self.btnpreviewtopbottom.setImage((UIImage(named: "upaerrow")?.maskWithColor(color: UIColor(rgbValue: ColorStyle.white))), for: .normal)
                
            }
        }
        
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func onbtnshareClick(sender : UIButton)
    {
        self.navigationView.btnshare.backgroundColor = UIColor.clear
        
        let arrmain : NSMutableArray = self.geturlarrayfrommodel(photomodel: self.photosmodel.photo[self.imageIndex])
        self.btnTouchupshareInside(sender,arrmain)
        
        
    }
    
    func onbtndownloadClick(sender : UIButton)
    {
        self.navigationView.btndownload.backgroundColor = .clear
        
        var imageURL : URL? = nil
        
        let arrmain : NSMutableArray = self.geturlarrayfrommodel(photomodel: self.photosmodel.photo[self.imageIndex])
        
        print(arrmain)
        
        if let url : URL = URL(string: self.photosmodel.photo[self.imageIndex].url_o) {
            imageURL = url
        }
        else if let url : URL = URL(string: self.photosmodel.photo[self.imageIndex].url_l) {
            imageURL = url
        }
        else if let url : URL = URL(string: self.photosmodel.photo[self.imageIndex].url_z) {
            imageURL = url
        }
        
        if imageURL != nil {
            self.btnTouchUpInside!(sender,arrmain)
        }
    }

    
    
    //MARK: - UICollectionView DataSource -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.photosmodel.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        var cell : UserImagesCollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifierConstants.userimagescell, for: indexPath as IndexPath) as? UserImagesCollectionViewCell
        
        //if cell == nil {
            //cell = UserImagesCollectionViewCell(frame: CGRect.zero)
        //}
        
        let newScale : CGFloat = 1
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        self.collectionView.transform = transform
        
        //cell.zoomscroll.contentSize = CGSize(width:self.frame.size.width*CGFloat(self.photosmodel.photo.count), height: self.frame.size.height)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomImage))
        cell.imageClick.gestureRecognizers = [pinch]
        //cell.imageClick.sizeToFit()
        cell.imageClick.isUserInteractionEnabled = true
        //cell.setup()
        cell.btnFavourite.isHidden = true
        cell.btnFavourite.tag = indexPath.row
        
        self.navigationView.setMenuButtonAction1 { (Sender, object) in
            
            self.onbtnshareClick(sender : Sender as! UIButton)
        }
        self.navigationView.setMenuButtonAction { (Sender, object) in
            self.onbtndownloadClick(sender: Sender as! UIButton)
        }
        
        let controler : BaseViewController = self.getViewControllerFromSubView() as! BaseViewController
        swipeAd += 1
        
        if self.swipeAd == 12 {
            self.swipeAd = 0
          //  self.interstitial.present(fromRootViewController: controler)
        }
        return  cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        _ = (cell as! UserImagesCollectionViewCell).imageClick.displayImageFromURLWithPlaceHolder(URL(string: self.getURLforCollection(photo: self.photosmodel.photo[indexPath.row])), self.photosmodel.photo[indexPath.row].placeholderImage)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.flatMap {
            URL(string : self.getURLforCollection(photo: self.photosmodel.photo[$0.row]))
        }
        ImagePrefetcher(urls: urls).start()
    }
    
    
//    func setup() {
//        
//        
//        //self.zoomscroll.delegate = self
//    }
    
    func zoomImage(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .ended || gesture.state == .changed {
            print("gesture.scale = \(gesture.scale)")
            
            var currentScale: CGFloat = self.frame.size.width / self.bounds.size.width
            print(currentScale)
            
            
            var newScale: CGFloat = currentScale * gesture.scale
            print(newScale)
            
            if newScale < minimum {
                newScale = minimum
            }
            if newScale > maximum {
                newScale = maximum
            }
            var transform = CGAffineTransform(scaleX: newScale, y: newScale)
            //cell5.imageClick.transform = transform
            self.collectionView.transform = transform
           // self.collectionView.contentSize = CGSize(width: self.frame.size.width * 1.5, height: self.frame.size.height * 1.5)
            
        }
    }
    
}



//func scrollViewDidScroll(_ scrollView: UIScrollView) {
//var offsetY: CGFloat = scrollView.contentOffset.y
//var scrollHeight: CGFloat = scrollView.frame.size.height
//var bottomInset: CGFloat = scrollView.contentInset.bottom
//var bottomScrollY: CGFloat = offsetY + scrollHeight - bottomInset
//var boundary: CGFloat = scrollView.contentSize.height
//if bottomScrollY >= boundary && !scrolledToBottom {
//    scrolledToBottom = true
//    if pagination != nil && pagination.next_id != nil && !(pagination.next_id == "0") {
//        //hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//        //hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
//        self.loadOperationServerRequest()
//    }
//}
//else if bottomScrollY < boundary {
//    scrolledToBottom = false
//}

//let scrollViewHeight : CGFloat? = scrollView.frame.size.height
//let contentSize : CGFloat? = scrollView.contentSize.height
//let offSetY : CGFloat? = scrollView.contentOffset.y
//let bottomInSet : CGFloat? = scrollView.contentInset.bottom
//
//let scrollBottomY : CGFloat? = offSetY! + scrollViewHeight! - bottomInSet!
//
//if (offSetY == 0) {
//    print("At Top of Scroll")
//}
//else if (CGFloat(scrollBottomY!) >= CGFloat(contentSize!) && !isLoadingNextPage) {
//    isLoadingNextPage = true
//    self.setFlickerImageServerRequest()
//}
//else if(CGFloat(scrollBottomY!) < CGFloat(contentSize!)) {
//    isLoadingNextPage = false
//}


//}

extension FlickrUsrListView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        visibleRect.origin = (self.collectionView?.contentOffset)!
        visibleRect.size = (self.collectionView?.bounds.size)!
        let visiblePoint = CGPoint(x: CGFloat(visibleRect.midX), y: CGFloat(visibleRect.midY))
        let visibleIndexPath: IndexPath? = self.collectionView?.indexPathForItem(at: visiblePoint)
        
        self.imageIndex = visibleIndexPath?.row
        self.lblviews.text = self.photosmodel.photo[self.imageIndex].views
        
        let lng : String = self.photosmodel.photo[self.imageIndex].longitude
        let lat : String = self.photosmodel.photo[self.imageIndex].latitude
        let latitude : Double = Double(lat)!
        let longitude : Double = Double(lng)!
        let userCordinate = CLLocation(latitude:latitude, longitude:longitude)
        let currentCordinate = CLLocation(latitude: curlat!, longitude: curlng!)
        
        let distanceInMeters = userCordinate.distance(from: currentCordinate)
        
        if (distanceInMeters < 500)
        {
            let strformat  = String(format: "%.2f", distanceInMeters)
            lbldistance.text = "\(strformat)m"
        }
        else
        {
            let strformat  = String(format: "%.2f", (distanceInMeters/1000))
            lbldistance.text = "\(strformat)km"
            
        }
        
        let timestamp = Double(self.photosmodel.photo[self.imageIndex].dateupload)
        
        let date : NSDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp!))
        let ago = self.timeAgoSinceDate(date: date, numericDates: true)
        print("Output is: \"\(ago)\"")
        
        lbltime.text = ago
        
        
        self.lbluser.text = self.photosmodel.photo[self.imageIndex].title
        let dictdist : NSDictionary = self.photosmodel.photo[self.imageIndex].descriptionn
        
        if dictdist["_content"] != nil {
            self.desctiptiontextView.text = dictdist.object(forKey: "_content") as! String!
            
        }
        self.navigationView.lblTitle.text = self.photosmodel.photo[self.imageIndex].ownername
        
        self.lblphotoby.text = "Photo by:\(self.photosmodel.photo[self.imageIndex].ownername)"
        
        print(imageIndex)
        print(self.photosmodel.photo.count)
        
//        if imageIndex == (self.photosmodel.photo.count - 1)
//        {
//            self.strpageCount = self.strpageCount + 1
//            
//            self.setFlickerImageServerRequest()
//            
//        }
        
        
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollWidth: CGFloat = scrollView.frame.size.width
        let rightInset: CGFloat = scrollView.contentInset.right
        let rightScrollX: CGFloat = offsetX + scrollWidth - rightInset
        let boundary: CGFloat = scrollView.contentSize.width
        if rightScrollX >= boundary && !isLoadingNewpage {
            isLoadingNewpage = true
            
            let noticount = UserDefaults.standard.object(forKey: "searchnoti") as! String!
            print(noticount)
            
            if noticount != "111"
            {
                 self.setFlickerImageServerRequest()
            }

            
           
        }
        else if rightScrollX < boundary {
            isLoadingNewpage = false
        }
        
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.imageUrl = URL(string: (self.photosmodel.photo[self.imageIndex].url_o))
    }
    
    
    
    
    
    // MARK: - Server Request -
    
    func setFlickerImageServerRequest() {
        if !isRequestLoding {
            AppUtility.isNetworkAvailableWithBlock { (isConnected) in
                if isConnected {
                    self.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion({
                        FlickrKit.shared().initialize(withAPIKey: Flicker_Data.KApi_Key, sharedSecret: Flicker_Data.KSecret_key)
                        
                        //if let tag : String = //AppUtility.getUserDefaultsObjectForKey("searchtag") as? String {
                            
                          //  print(tag)
                            print(self.strpageCount)
                            
                            self.showProgressHUD(viewController: AppUtility.getAppDelegate().window!, title: NSLocalizedString("KLoding", comment: "KLoding"), subtitle: nil)
                            
                            self.isRequestLoding = true
                            
                            FlickrKit.shared().call("flickr.photos.search", args: ["lat":self.strcurlat!,"lon":self.strcurlng!, "extras":"description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o", "per_page":String(self.strpageCount),"page":String(self.strperpage)], maxCacheAge: FKDUMaxAge.neverCache,completion: { (response, error) -> Void in
                                
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    self.isRequestLoding = false
                                    self.hideProgressHUD()
                                    
                                    if response != nil {
                                    
                                        self.hideProgressHUD()
                                        let dictresponse : NSDictionary = response! as NSDictionary
                                        print(dictresponse)
                                        let dictPhotos : NSDictionary = dictresponse.object(forKey: "photos") as! NSDictionary
                                        let responsePhotos : Photos = Photos(responseDictionary: dictPhotos)
                                        
                                        self.photosmodel.page = responsePhotos.page
                                        self.photosmodel.pages = responsePhotos.pages
                                        self.photosmodel.perpage = responsePhotos.perpage
                                        self.photosmodel.total = responsePhotos.total
                                        self.photosmodel.photo.append(contentsOf: responsePhotos.photo)
                                        
                                        if responsePhotos.photo.count > 0 {
                                            self.strperpage = self.strperpage + 1
                                        }
                                        print(self.photosmodel.photo.count)
                                        
                                       // let respodict : NSDictionary = ["model":self.photosmodel.photo]
                                        
                                        let respo : NSDictionary = NSDictionary(object: self.photosmodel.photo, forKey: "model" as NSCopying)
                                        
                                        print(self.strperpage)
                                        UserDefaults.standard.set(self.strperpage, forKey: "newpage")
                                        
                                        let noticount = UserDefaults.standard.object(forKey: "searchnoti") as! String!
                                         print(noticount)
                                        
                                        if noticount != "111"
                                        {

                                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object:self,userInfo:respo as? [AnyHashable : Any])
                                        }
                                        
                                        
                                        self.collectionView.reloadData()
                                        
                                    }
                                        
                                    else
                                    {
                                        
                                    }
                                })
                            })
                            
                        //}
                    })
                }
                else {
                    self.makeToast(NSLocalizedString("KNoInternetMessage", comment: "KNoInternetMessage"), duration: 2.0, position: .bottom, title: nil, image: nil, style: self.toastStyle) { (didTap) in
                    }
                }
            }
        }
    }

    
    

}
