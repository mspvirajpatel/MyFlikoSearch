//
//  FlickrUsrlistViewController.swift
//  FlikoSearch
//
//  Created by Viraj on 04/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//


import UIKit
import AssetsLibrary
import Photos
import Foundation
import STPopup


class FlickrUsrlistViewController: BaseViewController,WYPopoverControllerDelegate {
    
    // MARK : - Attributes -
    
    var flickrlist : FlickrUsrListView!
    var popUp : STPopupController!
    var popOverController : WYPopoverController!
    var slidepopover : UIPopoverPresentationController!
    
        
    // MARK :- Life Cycle -
    
    init(model : [Any])
    {
        let  subView : FlickrUsrListView = FlickrUsrListView(model: model)
        
        super.init(iView: subView, andNavigationTitle:NSLocalizedString("user", comment: "user"))
        
        flickrlist = subView
        
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK : - Layout
    
    override func loadViewControls() {
        
        super.loadViewControls()
        
        flickrlist.btnsharetapped { (sender, object) in
            
            print(sender)
            let arrmain : NSMutableArray = object as! NSMutableArray
            
            AppUtility.executeTaskInMainQueueWithCompletion {
                AppUtility.isNetworkAvailableWithBlock({ (isAvailable) in
                    if isAvailable {
                        
                        let menuControler : PopdownloadViewController = PopdownloadViewController(urlarray :arrmain)
                        menuControler.preferredContentSize = SystemConstants.IS_IPAD ? CGSize(width:layoutTimeConstants.favpopoveripadwidth, height: layoutTimeConstants.kpopupipadheight*arrmain.count) : CGSize(width:layoutTimeConstants.kpopupiphonewidth, height:layoutTimeConstants.kpopupiphoneheight*arrmain.count)
                        
                        self.popOverController = WYPopoverController(contentViewController:menuControler)
                        self.popOverController.passthroughViews = [sender]
                        self.popOverController.delegate = self
                        self.popOverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
                        self.popOverController.wantsDefaultContentAppearance = false
                        //self.popOverController.presentPopoverAsDialog(animated: true)
                        self.popOverController .presentPopover(from: (sender?.bounds)!, in: sender as! UIView!, permittedArrowDirections:.up, animated: true)
                        
                        
                        menuControler.setMenuCellSelectEvent(event: { (sender, object) in
                            self.popOverController.dismissPopover(animated: true)
                            let imgurl = object
                            
                            
                            let status = PHPhotoLibrary.authorizationStatus()
                            switch status {
                            case .authorized:
                                
                                let downloadPopUpController : DownloadPopUpController = DownloadPopUpController(url: imgurl as! URL)
                                
                                self.popUp = STPopupController.init(rootViewController: downloadPopUpController)
                                self.popUp.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closePoup(sender:))))
                                self.popUp.navigationBarHidden = true
                                self.popUp.hidesCloseButton = true
                                self.popUp.present(in: self)
                                
                                
                                
                                downloadPopUpController.setButtonTouchUpInsideEvent({ (sendor, object) in
                                    
                                    AppUtility.executeTaskAfterDelay(0.25, completion: {
                                        let imgpic : UIImage = object as! UIImage!
                                        print(imgpic)
                                        
                                        self.share(shareImage: imgpic)
                                        
                                    })
                                })

                                
                                break
                                
                            case .denied, .restricted :
                                
                                let alertView : UIAlertController = UIAlertController(title:NSLocalizedString("settingsprompt", comment: ""), message:NSLocalizedString("settingsprompt2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                
                                
                                
                                alertView.addAction(UIAlertAction(title:"Cancel" , style: .destructive, handler: { (action) in
                                    
                                    
                                    
                                }))
                                alertView.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                                    
                                    if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                                        UIApplication.shared.openURL(settingsURL as URL)
                                    }
                                    
                                }))
                                
                                DispatchQueue.main.async(execute: {
                                    self.present(alertView, animated: true, completion: nil)
                                })
                                
                                
                                break
                            case .notDetermined:
                                // ask for permissions
                                
                                PHPhotoLibrary.requestAuthorization() { status in
                                    switch status {
                                    case .authorized:
                                        
                                        let downloadPopUpController : DownloadPopUpController = DownloadPopUpController(url: imgurl as! URL)
                                        
                                        self.popUp = STPopupController.init(rootViewController: downloadPopUpController)
                                        self.popUp.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closePoup(sender:))))
                                        self.popUp.navigationBarHidden = true
                                        self.popUp.hidesCloseButton = true
                                        self.popUp.present(in: self)
                                        
                                        
                                        downloadPopUpController.setButtonTouchUpInsideEvent({ (sendor, object) in
                                            
                                            AppUtility.executeTaskAfterDelay(0.25, completion: {
                                                let imgpic : UIImage = object as! UIImage!
                                                print(imgpic)
                                                
                                                self.share(shareImage: imgpic)
                                                
                                            })
                                        })

                                        break
                                    // as above
                                    case .denied, .restricted:
                                        
                                        let alertView : UIAlertController = UIAlertController(title:NSLocalizedString("settingsprompt", comment: ""), message:NSLocalizedString("settingsprompt2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        
                                        
                                        alertView.addAction(UIAlertAction(title:"Cancel" , style: .destructive, handler: { (action) in
                                            
                                            
                                            
                                        }))
                                        
                                        alertView.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                                            
                                            if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                                                UIApplication.shared.openURL(settingsURL as URL)
                                            }
                                            
                                        }))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.present(alertView, animated: true, completion: nil)
                                        })
                                        
                                        break
                                        
                                        
                                    default:
                                        break
                                        
                                        
                                        //                    case .notDetermined:
                                        //
                                        //                        let alertView : UIAlertController = UIAlertController(title:NSLocalizedString("settingsprompt", comment: ""), message:NSLocalizedString("settingsprompt2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                        //
                                        //
                                        //
                                        //                        alertView.addAction(UIAlertAction(title:"Cancel" , style: .destructive, handler: { (action) in
                                        //
                                        //
                                        //
                                        //                        }))
                                        //
                                        //                        alertView.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                                        //
                                        //                            if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                                        //                                UIApplication.shared.openURL(settingsURL as URL)
                                        //                            }
                                        //
                                        //                        }))
                                        //
                                        //                        DispatchQueue.main.async(execute: {
                                        //                            self.present(alertView, animated: true, completion: nil)
                                        //                        })
                                        //
                                        //
                                        //                        break
                                        
                                        
                                    }
                                    
                                }
                                
                            }

                            
                            
                            
                            
                            
                        })
                    }
                    else {
                        self.flickrlist.makeToast(NSLocalizedString("KNoInternetMessage", comment: "KNoInternetMessage"), duration: 2.0, position: .bottom, title: nil, image: nil, style: self.flickrlist.toastStyle) { (didTap) in
                        }
                    }
                })
            }
            
        }
        
        flickrlist.btnTapped { (sender, object) in
            
            print(sender)
            let arrmain : NSMutableArray = object as! NSMutableArray
            
            AppUtility.executeTaskInMainQueueWithCompletion {
                AppUtility.isNetworkAvailableWithBlock({ (isAvailable) in
                    if isAvailable {
                        
                        let menuControler : PopdownloadViewController = PopdownloadViewController(urlarray :arrmain)
                        menuControler.preferredContentSize = SystemConstants.IS_IPAD ? CGSize(width:layoutTimeConstants.favpopoveripadwidth, height: layoutTimeConstants.kpopupipadheight*arrmain.count) : CGSize(width:layoutTimeConstants.kpopupiphonewidth, height:layoutTimeConstants.kpopupiphoneheight*arrmain.count)
                        // menuControler.preferredContentSize = SystemConstants.IS_IPAD ? CGSize(width:layoutTimeConstants.favpopoveripadwidth, height: 45*arrmain.count) : CGSize(width:130, height:40*arrmain.count)
                        
                        self.popOverController = WYPopoverController(contentViewController:menuControler)
                        self.popOverController.passthroughViews = [sender]
                        self.popOverController.delegate = self
                        self.popOverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
                        self.popOverController.wantsDefaultContentAppearance = false
                        //self.popOverController.presentPopoverAsDialog(animated: true)
                        self.popOverController .presentPopover(from: (sender?.bounds)!, in: sender as! UIView!, permittedArrowDirections:.up, animated: true)
                        
                        
                        menuControler.setMenuCellSelectEvent(event: { (sender, object) in
                            self.popOverController.dismissPopover(animated: true)
                            let imgurl = object
                            
                            let downloadPopUpController : DownloadPopUpController = DownloadPopUpController(url: imgurl as! URL)
                            
                            self.popUp = STPopupController.init(rootViewController: downloadPopUpController)
                            self.popUp.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closePoup(sender:))))
                            self.popUp.navigationBarHidden = true
                            self.popUp.hidesCloseButton = true
                            self.popUp.present(in: self)
                            
                            downloadPopUpController.setButtonTouchUpInsideEvent({ (sendor, object) in
                                
                                self.flickrlist.makeToast(NSLocalizedString("imagedownload", comment: "KNoInternetMessage"), duration: 2.0, position: .center, title: nil, image: nil, style: self.flickrlist.toastStyle) { (didTap) in
                                }
                                AppUtility.executeTaskAfterDelay(0.25, completion: {
                                    
                                    //self.displayActionSheet()
                                    //self.previewScreenView.btndownload.isEnabled = true
                                })
                                
                            })
                            
                        })
                    }
                    else {
                        self.flickrlist.makeToast(NSLocalizedString("KNoInternetMessage", comment: "KNoInternetMessage"), duration: 2.0, position: .bottom, title: nil, image: nil, style: self.flickrlist.toastStyle) { (didTap) in
                        }
                    }
                })
            }
            //}
            //}
        }

        
        
        
        

    }
    
    override func setViewlayout() {
        
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    
    func share(shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if  shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            if (is_Device._iPad)
            {
                
                //activityViewController.modalPresentationStyle =
                activityViewController.modalPresentationStyle = .popover
                activityViewController.popoverPresentationController?.sourceView = self.flickrlist.navigationView.btnshare
                self.present(activityViewController, animated: true, completion: { _ in })
            }
            else
            {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }else{
            print("There is nothing to share")
        }
    }
    
    
    @objc func closePoup(sender: UITapGestureRecognizer? = nil)
    {
        popUp.dismiss()
    }
    
//    func displayActionSheet() {
//        
//        let actionSheetController : UIAlertController = UIAlertController(title: KappName, message: NSLocalizedString("actionsheetMassage", comment: "actionsheetMassage"), preferredStyle: .actionSheet)
//        
//        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("actionCancel", comment: "actionCancel"), style: .cancel) { action -> Void in
//        }
//        actionSheetController.addAction(cancelAction)
//        
//        
//        let watchTutorial: UIAlertAction = UIAlertAction(title: NSLocalizedString("actionWatchTutorial", comment: "actionWatchTutorial"), style: .`default`) { action -> Void in
//            
//            if SystemConstants.IS_IPAD {
//                let pagingiPadViewController : PagingiPadViewController = PagingiPadViewController()
//                self.navigationController?.pushViewController(pagingiPadViewController, animated: true)
//            }
//            else {
//                let pagingViewController : PagingViewController = PagingViewController()
//                self.navigationController?.pushViewController(pagingViewController, animated: true)
//            }
//        }
//        actionSheetController.addAction(watchTutorial)
//        
//        if SystemConstants.IS_IPAD {
//            actionSheetController.popoverPresentationController?.sourceView = self.flickrlist.navigationView.btndownload
//            actionSheetController.popoverPresentationController?.sourceRect = self.flickrlist.navigationView.btndownload.bounds
//        }
//        
//        AppUtility.executeTaskInMainQueueWithCompletion {
//            self.navigationController?.present(actionSheetController, animated: true, completion: nil)
//            return
//        }
//    }

    
}
