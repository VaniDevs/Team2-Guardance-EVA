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
    func playAudio(session: MSession)
}

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionNameLabel: UILabel!
    let HistoryTableViewCellIdentifier = "HistoryTableViewCell"
    var delegate: HistoryTableViewCellDelegate!

    @IBOutlet weak var gpsButton: UIButton!
    var session: MSession!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(session: MSession, historyViewController: HistoryViewController) {
        self.session = session
        self.delegate = historyViewController
        let date: NSDate = session.rStartTime
        let string = historyViewController.formatter.stringFromDate(date)
        sessionNameLabel.text = string
        gpsButton.tintColor = .evaYellowDull()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func imagesTapped(sender: AnyObject) {
        delegate.showImages(session)
    }
    
    @IBAction func mapTapped(sender: AnyObject) {
        delegate.showMap(session)
    }

    @IBAction func audioTapped(sender: AnyObject) {
        delegate.playAudio(session)
    }
}
