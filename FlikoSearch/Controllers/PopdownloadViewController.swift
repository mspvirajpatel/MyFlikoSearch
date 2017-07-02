//
//  PopdownloadViewController.swift
//  FlikoSearch
//
//  Created by Viraj on 04/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//


import UIKit

class PopdownloadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    // MARK: - Attributes -
    
    var tblView : UITableView!
    var layout : MyViewBaseLayout!
    var cellSelectEvent : TableCellSelectEvent!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    var arrRerspo : NSMutableArray

    // MARK: -  LifeCycle - 
    
    init (urlarray : NSMutableArray)
    {
        self.arrRerspo = NSMutableArray()
        self.arrRerspo = urlarray
        super.init(nibName: nil, bundle: nil)
        self.loadViewControls()
        self.setViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return arrRerspo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifierConstants.popupmenutableviewcell, for: indexPath)
        if  cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier:CellIdentifierConstants.popupmenutableviewcell)
        }
        
        let arrsizedict :NSDictionary  = arrRerspo[indexPath.row] as! NSDictionary
        let txtsize : String = arrsizedict.object(forKey: "size") as! String!
        
        if indexPath.row == 0
        {
             cell.textLabel?.text = "\(txtsize) HD"
        }
        else if indexPath.row == 1
        {
           cell.textLabel?.text = "\(txtsize) HD"
        }
        else
        {
            
        cell.textLabel?.text = txtsize
        }
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = SystemConstants.IS_IPAD ? UIFont(name:"AppleSDGothicNeo-Medium", size: 17) : UIFont(name:"AppleSDGothicNeo-Medium", size:14)
        return cell
    }
    
    //  TODO:   - UITableViewDelegate -
    
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifierConstants.popupmenutableviewcell, for: indexPath)
        if  cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier:CellIdentifierConstants.popupmenutableviewcell)
        }
        
        let arrsizedict :NSDictionary  = arrRerspo[indexPath.row] as! NSDictionary
        let imgurl : URL = arrsizedict.object(forKey: "URL") as! URL

        self.btnTouchUpInside!("fav" as AnyObject?,imgurl as AnyObject?)
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
