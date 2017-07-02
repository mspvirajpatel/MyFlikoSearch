//
//  PopoververViewController.swift
//  FlikoSearch
//
//  Created by Viraj on 04/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//


import UIKit

class PopoververViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Attributes -
    
    var tblView : UITableView!
    var layout : MyViewBaseLayout!
    var cellSelectEvent : TableCellSelectEvent!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    
    //MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViewControls()
        self.setViewLayout()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Layout -
    
    
    func loadViewControls()
    {
        tblView = UITableView(frame: CGRect.zero)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.delegate = self
        tblView.dataSource = self
        tblView.isScrollEnabled = false
        tblView.backgroundColor = UIColor.white
        tblView.separatorStyle = .none
        tblView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tblView.register(UITableViewCell.self, forCellReuseIdentifier:CellIdentifierConstants.popupmenutableviewcell)
        self.view.addSubview(tblView)
        
        
    }
    
    func setViewLayout()
    {
        self.view.backgroundColor = UIColor.green
        
        layout = MyViewBaseLayout()
        
        layout.expandView(tblView, insideView: self.view)
    }
    
    // MARK: -  Internal Helpers -
    
    func setMenuCellSelectEvent(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    
    //  TODO:   - UITableView DataSource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifierConstants.popupmenutableviewcell, for: indexPath)
        if  cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier:CellIdentifierConstants.popupmenutableviewcell)
        }
        
        cell.textLabel?.text = NSLocalizedString("favpopup", comment: "")
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = SystemConstants.IS_IPAD ? UIFont(name:"AppleSDGothicNeo-Medium", size: 17) : UIFont(name:"AppleSDGothicNeo-Medium", size:14)
        return cell
    }
    
    //  TODO:   - UITableViewDelegate -
    
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.btnTouchUpInside!("fav" as AnyObject?,nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(is_Device._iPad)
        {
            return CGFloat(layoutTimeConstants.kpopupipadheight)
        }
        else
        {
            return CGFloat(layoutTimeConstants.kpopupiphoneheight)
        }
    }
    
    
    
    
    
    
    
}
