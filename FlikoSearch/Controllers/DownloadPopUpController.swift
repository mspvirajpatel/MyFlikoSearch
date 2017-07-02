//
//  DownloadPopUpController.swift
//  FlikoSearch
//
//  Created by Viraj on 04/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//


import UIKit
import Foundation
import Photos
import STPopup

class DownloadPopUpController: BaseViewController, URLSessionDownloadDelegate {
    
    
    // Mark: - Attributes -
    
    var downloadPopUpView : DownloadPopUpView!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var url : URL!
    var touchUpInsideEvent : ControlTouchUpInsideEvent!
    
    
    // MARK: - Lifecycle -
    
    init(url : URL) {
        
        let  subView : DownloadPopUpView = DownloadPopUpView(frame:CGRect.zero)
        super.init(iView: subView)
        downloadPopUpView = subView
        
        self.url = url
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.backgroundSession.finishTasksAndInvalidate()
        
    }
    
    func setButtonTouchUpInsideEvent(_ event : @escaping ControlTouchUpInsideEvent) {
        
        touchUpInsideEvent = event
        
    }
    
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
        self.contentSizeInPopup = downloadPopUpView.container.frame.size
        self.contentSizeInPopup.width = self.view.frame.size.width - 40
        self.landscapeContentSizeInPopup = downloadPopUpView.container.frame.size
        self.landscapeContentSizeInPopup.width = self.view.frame.size.width - 50
        
        
        self.downloadPopUpView.progressView.setProgress(0.0, animated: false)
        self.downloadPopUpView.btnRunAsBackground.addTarget(self, action: #selector(onbackgroudClick), for: .touchUpInside)
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSessionConfiguration.httpMaximumConnectionsPerHost = 10
        
        backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.current)
        
        self.downloadTask = self.backgroundSession.downloadTask(with: url)
        self.downloadTask.resume()
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
        
    }
    
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    func onbackgroudClick()
    {
        //self.viewDidDisappear(true)
        self.dismiss(animated: true) {
            self.backgroundSession.finishTasksAndInvalidate()
        }
        
    }
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
    //MARK: - Session Delegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        
        self.dismiss(animated: true, completion: nil)
        self.downloadPopUpView.lblProgressCounterSize.text = ""
        
        self.downloadPopUpView.progressView.setProgress(0.0, animated: false)
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            //self.displayActionSheet()
            print("The task finished transferring data successfully")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
        if let data = NSData(contentsOf: location) {
            let imgPic : UIImage = UIImage(data: data as Data)!
            
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                
                CustomPhotoAlbum.sharedInstance.saveImage(image:imgPic)
                if(self.touchUpInsideEvent != nil)
                {
                    self.touchUpInsideEvent(nil,imgPic)
                }
                self.backgroundSession.finishTasksAndInvalidate()
                
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
                
                CustomPhotoAlbum.sharedInstance.saveImage(image:imgPic)
                PHPhotoLibrary.requestAuthorization() { status in
                    switch status {
                    case .authorized:
                        
                        if(self.touchUpInsideEvent != nil)
                        {
                            self.touchUpInsideEvent(nil,imgPic)
                        }
                        self.backgroundSession.finishTasksAndInvalidate()
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
            
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        self.downloadPopUpView.progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        self.downloadPopUpView.lblProgressCounterSize.text = "Downloaded \((Float(totalBytesWritten / 1024))) / \(Float(totalBytesExpectedToWrite / 1024)) KB"
        
        let downloadpercantage = ((Float(totalBytesWritten / 1024)) / Float(totalBytesExpectedToWrite / 1024)*100)
        let strformat  = String(format: "%.0f", downloadpercantage)
        self.downloadPopUpView.lblProgressCounterPersentage.text = "\(strformat)%"
        
        
    }
    
    
}
