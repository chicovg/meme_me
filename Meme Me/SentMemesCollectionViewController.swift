//
//  SentMemesCollectionViewController.swift
//  Meme Me
//
//  Created by Victor Guthrie on 10/10/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let kCellIdentifier = "sentMemesCollectionViewCell"
    let kSegueToEditIdentifier = "memeCollectionToEditMemeSegue"
    let kSegueToDetailIdentifier = "memeCollectionToMemeDetailSegue"
    
    var selectedMeme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register custom cell class
        collectionView!.registerClass(MemeCollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        
        // set up layout
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }

    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier(kSegueToEditIdentifier, sender: nil)
    }
    

    @IBAction func unwindToCollectionView(unwindSeque: UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == kSegueToDetailIdentifier {
                if let selectedMeme = selectedMeme {
                    let detailVC = segue.destinationViewController as! MemeDetailViewController
                    detailVC.meme = selectedMeme
                }
            } else if segueIdentifier == kSegueToEditIdentifier {
                let editVC = (segue.destinationViewController as! UINavigationController).topViewController as! EditMemeViewController
                editVC.unwindSeque = kUnwindToCollectionSeque
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = meme.combinedImage
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes[indexPath.row]
        performSegueWithIdentifier(kSegueToDetailIdentifier, sender: nil)
    }
}
