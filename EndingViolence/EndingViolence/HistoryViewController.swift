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
    var modelManager: ModelMgr!
    
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
        return modelManager.sessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewCellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.configureWith(sessionForIndexPath(indexPath), historyViewController: self)
        return cell
    }

    
    func sessionForIndexPath(indexPath: NSIndexPath) -> MSession {
        return modelManager.sessions[indexPath.row]
    }
}

extension HistoryViewController: HistoryTableViewCellDelegate {
    func showImages(session: MSession) {
        let browser = SKPhotoBrowser(photos: session.images)
        navigationController?.showViewController(browser, sender: nil)
    }
    
    func showMap(session: MSession) {
        
    }
}