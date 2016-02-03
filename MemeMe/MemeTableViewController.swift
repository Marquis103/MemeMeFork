//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/2/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController {
	var coreDataStack: CoreDataStack!
	private let reuseIdentifier = "memeTableCell"
	
	
    var memes = [Meme]()
	
	//MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addMeme")
		
		navigationItem.leftBarButtonItem = editButtonItem()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		reloadData()
		
		navigationItem.leftBarButtonItem?.enabled = (memes.count > 0)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showMeme" {
			let destinationVC = segue.destinationViewController as! MemeViewController
			destinationVC.meme = sender as? Meme
		}
	}
	
	//MARK: Functions
	func deleteMemeObject(meme: Meme) {
		coreDataStack.managedObjectContext.deleteObject(meme)
		
		coreDataStack.saveMainContext()
		
		reloadData()
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
		
		tableView.reloadData()
	}
	
	func addMeme() {
		performSegueWithIdentifier("addNewMeme", sender: nil)
	}

    // MARK: - Table view data source
	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		if editing {
			tableView.setEditing(true, animated: animated)
		} else {
			tableView.setEditing(false, animated: animated)
		}
	}
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count ?? 0
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell

		let meme = memes[indexPath.row]
		
		cell.memeImage.image = meme.memedImageIcon
		
		let topText = meme.topText ?? ""
		let bottomText = meme.bottomText ?? ""
		
		var text = [String]()
		text.append((topText.characters.count < 10 && topText.characters.count >= 0) ? topText : (topText as NSString).substringToIndex(10))
		text.append((topText != String.Empty() && bottomText != String.Empty()) ? "..." : "")
		text.append((bottomText.characters.count < 10 && bottomText.characters.count >= 0) ? bottomText : (bottomText as NSString).substringToIndex(10))
		
		cell.memeTextLabel.text = (text.count > 0) ? text.joinWithSeparator("") : ""
		cell.memeTextLabel.textAlignment = .Center

        return cell
    }
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let meme = memes[indexPath.row]
			memes.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			deleteMemeObject(meme)
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let meme = memes[indexPath.row]
		
		performSegueWithIdentifier("showMeme", sender: meme)
		
	}
}
