//
//  HistoryTableViewCell.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-06.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit

protocol HistoryTableViewCellDelegate {
    func showImages(session: MSession)
    func showMap(session: MSession)
}

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionNameLabel: UILabel!
    let HistoryTableViewCellIdentifier = "HistoryTableViewCell"
    var delegate: HistoryTableViewCellDelegate!

    var session: MSession!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(session: MSession, historyViewController: HistoryViewController) {
        self.session = session
        self.delegate = historyViewController
        sessionNameLabel.text = historyViewController.formatter.stringFromDate(session.rStartTime)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func imagesTapped(sender: AnyObject) {
        delegate.showMap(session)
    }
    
    @IBAction func mapTapped(sender: AnyObject) {
        delegate.showImages(session)
    }
}
