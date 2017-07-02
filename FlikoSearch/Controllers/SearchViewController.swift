//
//  SearchViewController.swift
//  FlikoSearch
//
//  Created by Viraj on 04/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//


import UIKit

class SearchViewController: BaseViewController {
    
    //MARK: - Attributes -
    
    var txtsearch : BaseTextField!
    var btnsearch : BaseButton!
    var searchview : SearchView!
    
    
    // MARK: - Life Cycle -
    
    override init()
    {
        let subView : SearchView = SearchView(frame: CGRect.zero)
        super.init(iView: subView)
        
        searchview = subView
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
        
    }
    
}
