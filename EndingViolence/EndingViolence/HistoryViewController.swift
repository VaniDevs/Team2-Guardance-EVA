//
//  HistoryViewController.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-06.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit

let HistoryTableViewCellIdentifier = "HistoryTableViewCell"

class HistoryViewController: UITableViewController {
    var formatter: NSDateFormatter {
        let form = NSDateFormatter()
        form.dateFormat = "E, MMM d yyyy hh:mm:ss a"
        return form
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: HistoryTableViewCellIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "callDismissOnPresentingController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: ModelMgr sessions.count
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewCellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.configureWith(sessionForIndexPath(indexPath), formatter: formatter)
        return cell
    }

    
    func sessionForIndexPath(indexPath: NSIndexPath) -> MSession {
        return MSession()
    }
}
