//
//  SentMemesTableViewController.swift
//  Meme Me
//
//  Created by Victor Guthrie on 10/10/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    let kCellIdentifier = "sentMemesTableViewCell"
    let kSegueToEditIdentifier = "memeTableToEditMemeSegue"
    let kSegueToDetailIdentifier = "memeTableToMemeDetailSegue"
    
    var selectedMeme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addNewMeme(sender: AnyObject) {
        performSegueWithIdentifier(kSegueToEditIdentifier, sender: nil)
    }
    
    @IBAction func unwindToTableView(unwindSeque: UIStoryboardSegue) {
    
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == kSegueToDetailIdentifier {
                if let selectedMeme = selectedMeme {
                    let detailVC = segue.destinationViewController as! MemeDetailViewController
                    detailVC.meme = selectedMeme
                }
            } else if segueIdentifier == kSegueToEditIdentifier {
                let editVC = (segue.destinationViewController as! UINavigationController).topViewController as! EditMemeViewController
                editVC.unwindSeque = kUnwindToTableSeque
            }
        }
    }

    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! MemeTableViewCell
        cell.memeImage.image = meme.combinedImage
        cell.memeText.text = "\(meme.textTop) \(meme.textBottom)"
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes[indexPath.row]
        performSegueWithIdentifier(kSegueToDetailIdentifier, sender: nil)
    }

}
