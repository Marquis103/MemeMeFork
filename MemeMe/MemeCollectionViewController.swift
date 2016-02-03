//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/2/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData


class MemeCollectionViewController: UICollectionViewController {
	var coreDataStack: CoreDataStack!
	
	var memes = [Meme]()

	private let reuseIdentifier = "collectionViewCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()

		collectionView!.backgroundColor = UIColor.whiteColor()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addMeme")
    }
	
	override func viewWillLayoutSubviews() {
		let width = CGRectGetWidth(collectionView!.frame) / 3
		let layout = collectionViewLayout as! UICollectionViewFlowLayout
		
		layout.itemSize = CGSize(width: width, height: width)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		reloadData()
		
		navigationItem.leftBarButtonItem?.enabled = (memes.count > 0)
	}
	
	func reloadData() {
		let fetchRequest = NSFetchRequest(entityName: "Meme")
		
		do {
			if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Meme] {
				memes = results
			}
			
		} catch {
			fatalError("There was an error fetching the list of memes!  Oh no!")
		}
		
		collectionView?.reloadData()
	}
	
	func addMeme() {
		performSegueWithIdentifier("addNewMeme", sender: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showMeme" {
			let destinationVC = segue.destinationViewController as! MemeViewController
			destinationVC.meme = sender as? Meme
		}
	}

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
		
		let meme = memes[indexPath.item]
		
		cell.memeCollImageView.image = meme.memedImageIcon
    
        return cell
    }

    // MARK: UICollectionViewDelegate

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let meme = memes[indexPath.row]
		
		performSegueWithIdentifier("showMeme", sender: meme)
	}
}
