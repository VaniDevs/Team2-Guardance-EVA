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

    enum Segues : String {
        case toMapView = "segueToMapView"
    }
    
    var modelManager: ModelMgr!
    
    var formatter: NSDateFormatter {
        let form = NSDateFormatter()
        form.dateFormat = "E, MMM d yyyy hh:mm:ss a"
        return form
    }
    
    private var selectedSession: MSession?
    private var audioPlayer = AudioPlayer()
    
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        return cell
    }

    func sessionForIndexPath(indexPath: NSIndexPath) -> MSession {
        return modelManager.sessions[indexPath.row]
    }
}

extension HistoryViewController: HistoryTableViewCellDelegate {

    func playAudio(session: MSession) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        } else {
            if let path = session.rAudioFilePath {
                audioPlayer.loadFile(path)
                audioPlayer.play { success in
                    print("Finished playing, success=\(success)")
                }
            }
        }
    }

    func showImages(session: MSession) {
        let browser = SKPhotoBrowser(photos: session.images)
        navigationController?.showViewController(browser, sender: nil)
    }
    
    func showMap(session: MSession) {
        selectedSession = session
        performSegueWithIdentifier(Segues.toMapView.rawValue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case Segues.toMapView.rawValue:
            if let mapVC = segue.destinationViewController as? MapViewVC {
                mapVC.session = selectedSession
            }
        default:
            break
        }
    }
}