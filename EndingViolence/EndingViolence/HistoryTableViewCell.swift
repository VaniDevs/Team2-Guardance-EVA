//
//  HistoryTableViewCell.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-06.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionNameLabel: UILabel!
    
    var session: MSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(session: MSession, formatter: NSDateFormatter) {
        self.session = session
        
        sessionNameLabel.text = formatter.stringFromDate(session.rStartTime)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func imagesTapped(sender: AnyObject) {
    }
    @IBAction func mapTapped(sender: AnyObject) {
    }
}
