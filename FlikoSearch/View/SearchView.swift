
import UIKit
import FlickrKit
import CoreLocation

class SearchView: BaseView,UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate,UITextFieldDelegate {
    
    // MARK: - Attributes -
    
    var txtsearch : BaseTextField!
    var btnsearch : BaseButton!
    var layout : MyViewBaseLayout!
    var txtstatic : BaseLabel!
    var photoCollectionView : UICollectionView!
    var strperpage : Int!
    var strpageCount : Int!
    var isRequestLoding : Bool = false
    private var isLoadingNextPage : Bool = false
    var photoList : Photos = Photos()
    var curlat : Double? = nil
    var curlng : Double? = nil
    var strcurlat : String!
    var strcurlng : String!
    var myLocation : CLLocation? = nil
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect) {
        super.init(withBack: true, titleString:NSLocalizedString("FlikoSearch", comment: "title"))
        
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
    }
    
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
        self.backgroundColor = UIColor(rgbValue:ColorStyle.sidebarmaincolor)
        
        strperpage = 1
        strpageCount = 100
        
//        LocationManager.shared.locate { result in
//            switch result {
//            case .Success(let locator):
//                if let _:CLLocation = locator.location { /* ... */ }
//                self.myLocation = locator.location!
//                
//                
//                
//                    self.curlat = self.myLocation?.coordinate.latitude
//                    self.curlng = self.myLocation?.coordinate.longitude
//                    
//                    UserDefaults.standard.set(self.curlat, forKey: "curLat")
//                    UserDefaults.standard.set(self.curlng, forKey: "curLng")
//                    
//                    
//                    
//                    self.strcurlat = String(describing: self.curlat!)
//                    self.strcurlng = String(describing: self.curlng!)
//                    
//                
//                
//            case .Failure( _):
//                self.strcurlat = String(describing: "23.333333")
//                self.strcurlng = String(describing: "72.444443")
//               
//                
//                UserDefaults.standard.set("23.333333", forKey: "curLat")
//                UserDefaults.standard.set("72.444443", forKey: "curLng")
//                
//                AppUtility.executeTaskInMainQueueWithCompletion({
//                    
//                    //self.hideProgressHUD()
//                    //self.isLoadedRequest = false
//                })
//                break
//                /* ... */
//            }
//        }
        
        
        self.curlat = Double("23.333333")
        self.curlng = Double("72.444443")
        
        UserDefaults.standard.set(self.curlat, forKey: "curLat")
        UserDefaults.standard.set(self.curlng, forKey: "curLng")
        
        
        
        self.strcurlat = String(describing: self.curlat!)
        self.strcurlng = String(describing: self.curlng!)
        
        
        
        self.bringSubview(toFront: self.navigationView)
        self.navigationView.btnMenu.isHidden = true
        self.navigationView.btnpopup.isHidden = true
        self.navigationView.btnsidebar.isHidden = true
        self.navigationView.btnfav.isHidden = true
        self.navigationView.btnBack.isHidden = true
        //self.navigationView.btnimguser.isHidden = true
        self.navigationView.btnshare.isHidden = true
        self.navigationView.btndownload.isHidden = true
        self.navigationView.backgroundColor = UIColor(rgbValue:ColorStyle.gray, alpha: 0.7)
        
        
        txtsearch = BaseTextField(iSuperView: self, TextFieldType: .basePrimaryTextFieldType)
        self.txtsearch.placeholder = NSLocalizedString("searchplaceholder", comment: "placeholder"
        )
        txtsearch.setShowToolbar(true)
        //txtsearch.leftArrowButton.baseButton.titleLabel?.textColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        txtsearch.returnKeyType = .search
        
        txtsearch.autocorrectionType = .no
        txtsearch.delegate = self
        txtsearch.backgroundColor = UIColor(rgbValue: ColorStyle.white)
        
        btnsearch = BaseButton(ibuttonType: .basePrimaryButtonType, iSuperView: self)
        btnsearch.backgroundColor = UIColor(rgbValue: ColorStyle.white)
        btnsearch.imageForNormal((UIImage(named: "search")?.maskWithColor(color: .black))!)
        btnsearch.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btnsearch.addTarget(self, action: #selector(onbtnsearchclick), for: .touchUpInside)
        btnsearch.layer.cornerRadius = 5.0
        
        txtstatic = BaseLabel(iLabelType: .basePrimaryMediumLabelType, iSuperView: self)
        txtstatic.text = NSLocalizedString("staticsearchtext", comment: "statictext")
        txtstatic.textColor = UIColor(rgbValue: ColorStyle.white)
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = CGFloat(10)
        layout.minimumInteritemSpacing = CGFloat(10)
        
        photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.backgroundColor = UIColor(rgbValue: ColorStyle.sidebarmaincolor)
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.isUserInteractionEnabled = false
        
        photoCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier:CellIdentifierConstants.photocolectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.showsVerticalScrollIndicator = false
        self.photoCollectionView.alwaysBounceVertical = true
        self.addSubview(photoCollectionView)
       
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        layout = MyViewBaseLayout()
        
        
        layout.viewDictionary = ["txtsearch" : txtsearch,
                                 "btnsearch" : btnsearch,
                                 "txtstatic" : txtstatic,
                                 "photoCollectionView" : photoCollectionView]
        
        let controlTopBottomPadding : CGFloat = layoutTimeConstants.KControlTopBottomPadding
        let controlLeftRightPadding : CGFloat = layoutTimeConstants.KControlLeftRightPadding
        
        let controlTopBottomSecondaryPadding : CGFloat = layoutTimeConstants.KControlTopBottomSecondaryPadding
        let controlLeftRightSecondaryPadding : CGFloat = layoutTimeConstants.KControlLeftRightSecondaryPadding
        
        layout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                          "controlLeftRightPadding" : controlLeftRightPadding,
                          "controlTopBottomSecondaryPadding" : controlTopBottomSecondaryPadding,
                          "controlLeftRightSecondaryPadding" : controlLeftRightSecondaryPadding]
        
        //Container View
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[txtsearch]-[btnsearch(40)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-70-[txtsearch]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_V)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-70-[btnsearch]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_V)
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[txtstatic]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[txtsearch]-[txtstatic]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_V)
        
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[photoCollectionView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[txtstatic]-[photoCollectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.addConstraints(layout.control_V)
    }
    
    
    
    // MARK: - Internal Helpers -
    

    // MARK: - User Interaction -
    
    func onbtnsearchclick()
    {
        self.txtsearch.resignFirstResponder()
        self.btnsearch.backgroundColor = UIColor(rgbValue: ColorStyle.white)
        var strblock : String = NSLocalizedString("blockstring", comment: "")
        
        if (self.txtsearch.text?.isEmpty)!
        {
            self.makeToast(NSLocalizedString("blanktxtsearch", comment: "KNoInternetMessage"), duration: 2.0, position: .top, title: nil, image: nil, style: self.toastStyle) { (didTap) in
            }
            
        }
        else if strblock .contains(self.txtsearch.text!)
        {
            
            self.makeToast(NSLocalizedString("pornimagesalert", comment: "KNoInternetMessage"), duration: 2.0, position: .top, title: nil, image: nil, style: self.toastStyle) { (didTap) in
            }
        }
        else
        {
            self.photoList = Photos()
            self.photoCollectionView.reloadData()
            
            photoCollectionView.isUserInteractionEnabled = true
            AppUtility.setUserDefaultsObject(self.txtsearch.text as String! as AnyObject, forKey:"searchtag")
            
            self.setFlickerImageServerRequest()
        }
        
        
    }
    
    // MARK: - Internal Helpers -
    
    func getURLforCollection(photo : Photo) -> URL? {
        var imgurl : URL? = nil
        
        if SystemConstants.IS_IPAD {
            
            if let url : URL = URL(string: photo.url_z) {
                imgurl = url
            }
            else if let url : URL = URL(string: photo.url_l) {
                imgurl = url
            }
            else if let url : URL = URL(string: photo.url_o) {
                imgurl = url
            }
            
        }
        else {
            if let url : URL = URL(string: photo.url_m) {
                imgurl = url
            }
            else if let url : URL = URL(string: photo.url_z) {
                imgurl = url
            }
            else if let url : URL = URL(string: photo.url_l) {
                imgurl = url
            }
            else if let url : URL = URL(string: photo.url_o) {
                imgurl = url
            }
        }
        
        return imgurl
    }
    
    
    // MARK: - UICollectionView DataSource -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoList.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : PhotosCollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifierConstants.photocolectionView, for: indexPath as IndexPath) as? PhotosCollectionViewCell
        if cell == nil
        {
            cell = PhotosCollectionViewCell(frame: CGRect.zero)
        }
        
        cell.imgUser.displayImageFromUrmwithComplition(self.getURLforCollection(photo: self.photoList.photo[indexPath.row])) { (completion, image) in
            if completion {
                if self.photoList.photo.count > indexPath.row {
                    self.photoList.photo[indexPath.row].placeholderImage = image
                }
            }
        }
        
        cell.btnFavourite.isHidden = true
        return cell
        
    }
    
    
    // MARK: - UITaextfield Delegate -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onbtnsearchclick()
        self.txtsearch.resignFirstResponder()
        return true
    }
    
    
    
    //(model:)
    // MARK: - UICollectionView Delegate -
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controler : UIViewController  = self.getViewControllerFromSubView()!
        
        UserDefaults.standard.set("111", forKey: "searchnoti")
        
        let userlistViewControler : FlickrUsrlistViewController = FlickrUsrlistViewController(model:[indexPath.row,self.photoList])//(selectedIndex: indexPath.row, isFromFavourite: false, model: self.photoList)
        controler.navigationController?.pushViewController(userlistViewControler, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let lower : UInt32 = UInt32(self.bounds.size.width/1.8)
        let upper : UInt32 = UInt32(self.bounds.size.width/1.2)
        let randomNumber = arc4random_uniform(upper - lower) + lower
        
        return CGSize(width:self.bounds.size.width/2, height: CGFloat(randomNumber))
    }
    
    
    // MARK: - UIScrolView Delegate -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight : CGFloat? = scrollView.frame.size.height
        let contentSize : CGFloat? = scrollView.contentSize.height
        let offSetY : CGFloat? = scrollView.contentOffset.y
        let bottomInSet : CGFloat? = scrollView.contentInset.bottom
        
        let scrollBottomY : CGFloat? = offSetY! + scrollViewHeight! - bottomInSet!
        
        if (offSetY == 0)
        {
            print("At Top of Scroll")
        }
        else if (CGFloat(scrollBottomY!) >= CGFloat(contentSize!) && !isLoadingNextPage) {
            isLoadingNextPage = true
            //strperpage = +strperpage
            self.setFlickerImageServerRequest()
        }
        else if(CGFloat(scrollBottomY!) < CGFloat(contentSize!))
        {
            isLoadingNextPage = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in self.photoCollectionView.visibleCells {
            let indexPath = self.photoCollectionView.indexPath(for: cell)!
            print("\(indexPath)")
        }
    }
    
    // MARK: - Server Request -
    
    func setFlickerImageServerRequest() {
        if !isRequestLoding {
            AppUtility.isNetworkAvailableWithBlock { (isConnected) in
                if isConnected {
                    self.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion({
                        FlickrKit.shared().initialize(withAPIKey: Flicker_Data.KApi_Key, sharedSecret: Flicker_Data.KSecret_key)
                        
                        if let tag : String = AppUtility.getUserDefaultsObjectForKey("searchtag") as? String {
                            
                            print(tag)
                            print(self.strpageCount)
                            
                            self.showProgressHUD(viewController: AppUtility.getAppDelegate().window!, title: NSLocalizedString("KLoding", comment: "KLoding"), subtitle: nil)
                            
                            self.isRequestLoding = true
                            
                            FlickrKit.shared().call("flickr.photos.search", args: ["tags":self.txtsearch.text!, "extras":"description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o", "per_page":String(self.strpageCount),"page":String(self.strperpage)], maxCacheAge: FKDUMaxAge.neverCache,completion: { (response, error) -> Void in
                                
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    self.isRequestLoding = false
                                    self.hideProgressHUD()
                                    
                                    if response != nil {
                                        self.navigationView.navigationTitle = "\(self.txtsearch.text!)"
                                        
                                        
                                        self.hideProgressHUD()
                                        let dictresponse : NSDictionary = response! as NSDictionary
                                        print(dictresponse)
                                        let dictPhotos : NSDictionary = dictresponse.object(forKey: "photos") as! NSDictionary
                                        let responsePhotos : Photos = Photos(responseDictionary: dictPhotos)
                                        
                                        self.photoList.page = responsePhotos.page
                                        self.photoList.pages = responsePhotos.pages
                                        self.photoList.perpage = responsePhotos.perpage
                                        self.photoList.total = responsePhotos.total
                                        self.photoList.photo.append(contentsOf: responsePhotos.photo)
                                        
                                        if responsePhotos.photo.count > 0 {
                                            self.strperpage = self.strperpage + 1
                                        }
                                        
                                        self.photoCollectionView.reloadData()
                                        
                                    }
                                        
                                    else
                                    {
                                        
                                    }
                                })
                            })
                            
                        }
                    })
                }
                else {
                    //                    self.makeToast(NSLocalizedString("KNoInternetMessage", comment: "KNoInternetMessage"), duration: 2.0, position: .bottom, title: nil, image: nil, style: self.toastStyle) { (didTap) in
                    //                    }
                    AppUtility.showWhisperAlert(message:NSLocalizedString("KNoInternetMessage", comment: ""), duration:2)
                }
            }
        }
        else
        {
            AppUtility.showWhisperAlert(message:NSLocalizedString("KNoInternetMessage", comment: ""), duration:2)
        }
    }
    
    
    
}
