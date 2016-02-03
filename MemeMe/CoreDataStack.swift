//
//  CoreDataStack.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/2/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack : NSObject {
	static let moduleName = "myMemes"
	
	//save managed context if changes exist
	func saveMainContext() {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				print("There was an error saving main managed object context! \(error)")
			}
		}
	}
	
	//retrieves the data model file from the NSBundle and returns NSManagedObjectModel
	lazy var managedObjectModel: NSManagedObjectModel = {
		let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
	}()
	
	//application document directory location is used to store the persistent store
	lazy var applicationDocumentsDirectory: NSURL = {
		return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
	}()
	
	lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		
		let persistentStoreURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
		
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
				configuration: nil,
				URL: persistentStoreURL,
				options: [NSMigratePersistentStoresAutomaticallyOption: true,
					NSInferMappingModelAutomaticallyOption : true])
		} catch {
			fatalError("Persistent store error! \(error)")
		}
		
		return coordinator
		
	}()
	
	lazy var managedObjectContext:NSManagedObjectContext = {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
		return managedObjectContext
	}()
	
	lazy var memeEntity:NSEntityDescription = {
		guard let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: self.managedObjectContext) else {
			fatalError("Entity could not be found!")
		}
		
		return entity
	}()
}