//
//  Meme+CoreDataProperties.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/3/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import UIKit
import CoreData

extension MemeModel {

    @NSManaged var bottomText: String?
    @NSManaged var memedImage: UIImage
    @NSManaged var memedImageIcon: UIImage
    @NSManaged var originalImage: UIImage
    @NSManaged var topText: String?

}
