

import UIKit
import Kingfisher

enum BaseImageViewType : Int {
    
    case baseUnknownImageViewType = -1
    case baseProfileImageViewType = 1
    case baseLogoImageViewType = 2
    case baseDefaultImageViewType = 3
}

class BaseImageView: UIImageView {

    // MARK: - Attributes -
    
    var imageViewType : BaseImageViewType = .baseUnknownImageViewType
    let progressIndicatorView = CircularLoaderView(frame: CGRect.zero)
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(iImageViewType : BaseImageViewType, iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        imageViewType = iImageViewType
        
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView?.addSubview(self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        switch imageViewType {
        case .baseDefaultImageViewType:
            self.progressIndicatorView.frame.origin = self.center
            self.progressIndicatorView.backgroundColor = UIColor(rgbValue: ColorStyle.white)
            break
        default:
            break
        }
    }
    
    deinit{
        
    }
    
    // MARK: - Layout - 
    
    func setCommonProperties(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch imageViewType {
            
        case BaseImageViewType.baseProfileImageViewType:
            
            self.contentMode = .scaleAspectFit
            self.layoutSubviews()
            addSubview(self.progressIndicatorView)
            
            break
        case BaseImageViewType.baseLogoImageViewType:
            
            self.image = UIImage(named: "logo")!
            
            self.contentMode = .scaleAspectFit
            self.setBorder(UIColor(rgbValue: 0xffffff,alpha: 0.5), width: 0.0, radius: 2.0)
            self.clipsToBounds = true
            self.tag = 0
            self.isUserInteractionEnabled = true
            self.translatesAutoresizingMaskIntoConstraints = false
            
            break;
        
        case BaseImageViewType.baseDefaultImageViewType:
            
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            self.translatesAutoresizingMaskIntoConstraints = false
            self.progressIndicatorView.backgroundColor = UIColor(rgbValue: ColorStyle.white)
            addSubview(self.progressIndicatorView)
            break
            
        default:
            break
        }
        
    }
    
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    
    func displayImageFromURL(_ urlString : String)
    {
        //self .kf.indicator?.startAnimatingView()
        //self.kf_indicator = UIColor.red
        let imageURL : URL? = URL(string: urlString)
       
//        progressIndicatorView.layoutSubviews()
//        progressIndicatorView.frame = self.bounds
//        progressIndicatorView.autoresizingMask = UIViewAutoresizing.flexibleWidth
//        self.layoutSubviews()
        
        self.kf.setImage(with: imageURL, placeholder:UIImage(named: "usericon"), options: nil, progressBlock: { (receivedSize, totalSize) in
              print("Download Progress: \(receivedSize)/\(totalSize)")
            self.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(totalSize)
            }, completionHandler: { (image, error, cacheType, imageURL) in
                //print("Downloaded and set!")
               
                self.progressIndicatorView.reveal()
                if(image ==  nil)
                {
                    
                }
                else
                {
                    self.image = image
                }

        })
        
    
        self.layoutSubviews()
        
    }
    
    func displayImageFromURLWithPlaceHolder(_ urlString : URL?, _ image : UIImage?)
    {
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        let imageURL : URL? = urlString
        
        self.kf.setImage(with: imageURL, placeholder: image, options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
            //self.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(totalSize)
            
        }) { (image, error, CacheType, imageURL) in
            if(image ==  nil)
            {
                
            }
            else
            {
                self.image = image
            }
        }
        self.layoutSubviews()
        
    }
    
    func displayImageFromUrmwithComplition(_ UrlString : URL?, completion : @escaping (_ success : Bool, _ image : UIImage?) -> Void) {
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        
        let imageURL : URL? = UrlString
        
        self.kf.setImage(with: imageURL, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
            
        }) { (image, error, CacheType, imageURL) in
            if(image ==  nil) {
                completion(false, nil)
            }
            else
            {
                self.image = image
                completion(true, image)
            }
        }
    }


    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
