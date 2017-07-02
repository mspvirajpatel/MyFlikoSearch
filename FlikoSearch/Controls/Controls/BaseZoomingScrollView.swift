

import UIKit

class BaseZoomingScrollView: UIScrollView,UIScrollViewDelegate
{
    var photoImageView : BaseImageView!
    var photo : UIImage!
    init()
    {
        super.init(frame: CGRect.zero)
        photoImageView = BaseImageView(frame: CGRect.zero)
        photoImageView.backgroundColor = UIColor.red
        self .addSubview(photoImageView)
        
        self.backgroundColor = UIColor.yellow
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    
    func setImageHidden(hidden : Bool)
    {
        photoImageView.isHidden = hidden
    }

    
    func prepareForReuse() {
        self.photo = nil
        self.photoImageView.isHidden = false
        self.photoImageView.image = nil
    }
    
    // Image Method
    
    func setImagePhoto(url : URL)
    {
        
        
        //photoImageView.displayImageFromURL(url)
        
        //photoImageView .sd_setShowActivityIndicatorView(true)
        //photoImageView .sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
//        photoImageView.sd_setImage(with: NSURL(string: url), placeholderImage: nil) { (image, error, catchType, imgUrl) in
//            self.photo = image
//            self.displayImage()
//        }
//        photoImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil) { (image, error, catchType, imgUrl) in
//            self.photo = image
//            self.displayImage()
//        }
        
//        AppUtility.executeTaskInMainQueueWithCompletion {
//            self.photoImageView.sd_setImage(with: NSURL(string: url) as URL?)
//            self.displayImage()
//        }
        
       
        
//        photoImageView.sd_setImage(with: NSURL(string: url) as URL?, placeholderImage: nil) { (image, error, catchType, imgUrl) in
//            
//        }
    }
    
    func displayImage()
    {
        if photo != nil && photoImageView.image != nil
        {
            self.maximumZoomScale = 1
            self.minimumZoomScale = 1
            self.zoomScale = 1
            self.contentSize = CGSize(width: 0, height: 0)
            if photo != nil
            {
                self.photoImageView.image = photo
                
                UIView .transition(with: photoImageView, duration: 0.5, options: [.transitionCrossDissolve], animations: { 
                        self.photoImageView.isHidden = false
                    }, completion: { (completed) in
                        
                })
                
                var photoImageViewFrame: CGRect = CGRect.zero
                photoImageViewFrame.origin = CGPoint.zero
                photoImageViewFrame.size = photo.size
                self.photoImageView.frame = photoImageViewFrame
                self.contentSize = photoImageViewFrame.size
                self.setMaxMinZoomScalesForCurrentBounds()
            }
            else {
                
            }
            self.setNeedsLayout()
            self.setZoomScale(self.minimumZoomScale, animated: false)
        }
    }
    
    // SetUp
    
    func initialZoomScaleWithMinScale() -> CGFloat {
        var zoomScale: CGFloat = self.minimumZoomScale
        if photoImageView != nil
        {
            let boundsSize = self.bounds.size
            let imageSize = photoImageView.image!.size
            let boundsAR: CGFloat = boundsSize.width / boundsSize.height
            let imageAR: CGFloat = imageSize.width / imageSize.height
            let xScale: CGFloat = boundsSize.width / imageSize.width
            let yScale: CGFloat = boundsSize.height / imageSize.height
            if abs(boundsAR - imageAR) < 0.17 {
                zoomScale = max(xScale, yScale)
                zoomScale = min(max(self.minimumZoomScale, zoomScale), self.maximumZoomScale)
            }
        }
        return zoomScale
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        self.maximumZoomScale = 1
        self.minimumZoomScale = 1
        self.zoomScale = 1
        if photoImageView.image == nil {
            return
        }
        self.photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: photoImageView.frame.size.height)
        let boundsSize = self.bounds.size
        let imageSize = photoImageView.image!.size
        let xScale: CGFloat = boundsSize.width / imageSize.width
        let yScale: CGFloat = boundsSize.height / imageSize.height
        var minScale: CGFloat = min(xScale, yScale)
        let maxScale: CGFloat = 3
        if xScale >= 1 && yScale >= 1 {
            minScale = 1.0
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
        print("minimum zoom :-",self.minimumZoomScale)
        self.zoomScale = self.initialZoomScaleWithMinScale()
        if self.zoomScale != minScale {
            self.contentOffset = CGPoint(x: (imageSize.width * minScale - boundsSize.width) / 2.0, y: (imageSize.height * minScale - boundsSize.height) / 2.0)
            self.zoomScale = minScale
        }
        self.isScrollEnabled = false
        self.setNeedsLayout()
    }
    

    
    
    // Layout
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let boundsSize = self.bounds.size
        var frameToCenter = photoImageView.frame
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = CGFloat(floorf((Float(boundsSize.width - frameToCenter.size.width)) / 2.0))
        }
        else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = CGFloat(floorf((Float(boundsSize.height - frameToCenter.size.height)) / 2.0))
        }
        else {
            frameToCenter.origin.y = 0
        }
        if !photoImageView.frame.equalTo(frameToCenter) {
            self.photoImageView.frame = frameToCenter
        }
    }
    
    
    // Delegate Method
    private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        self.isScrollEnabled = true
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self .setNeedsDisplay()
        self .layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
