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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addMeme")
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//deleteData()
		
		reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	//MARK: Functions
	func deleteData() {
		let memeFetchRequest = NSFetchRequest(entityName: "Meme")
		let memeDeleteRequest = NSBatchDeleteRequest(fetchRequest: memeFetchRequest)
		memeDeleteRequest.resultType = .ResultTypeCount
		
		do {
			let memeResult = try coreDataStack.managedObjectContext.executeRequest(memeDeleteRequest) as! NSBatchDeleteResult
			
			let alert = UIAlertController(title: "Batch Delete Succeeded", message: "\(memeResult.result!) meme records deleted.", preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			presentViewController(alert, animated: true, completion: nil)
		} catch {
			let alert = UIAlertController(title: "Batch Delete Failed", message: "There was an error with the batch delete.", preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	func resizeImageForViews(image: UIImage, newWidth:CGFloat) -> UIImage {
		//let scale = newWidth/image.size.width
		//let newHeight = image.size.height * scale
		UIGraphicsBeginImageContext(CGSizeMake(150, 150))
		let context = UIGraphicsGetCurrentContext()
		CGContextSetInterpolationQuality(context, .High)
		image.drawInRect(CGRect(x: 0, y: 0, width: 150, height: 150))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	func reloadData() {
		let fetchRequest = NSFetchRequest(entityName: "Meme")
		
		do {
			if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Meme] {
				memes = results
				//coreDataStack.managedObjectContext.deletedObjects(Set(memes))
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
	
	

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell

		let meme = memes[indexPath.row]
		
		cell.memeImage.image = meme.memedImage
		
		let topText = meme.topText ?? ""
		let bottomText = meme.bottomText ?? ""
		
		var text = [String]()
		text.append((topText.characters.count < 8 && topText.characters.count > 0) ? topText : (topText as NSString).substringFromIndex(8))
		text.append((topText != String.Empty() && bottomText != String.Empty()) ? "..." : "")
		text.append((bottomText.characters.count < 8 && bottomText.characters.count > 0) ? bottomText : (bottomText as NSString).substringFromIndex(8))
		
		cell.memeTextLabel.text = (text.count > 0) ? text.joinWithSeparator("") : ""

        return cell
    }
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
