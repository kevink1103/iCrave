//
//  NSCustomPersistentContainer.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kevinkim.iCrave")
        storeURL = storeURL?.appendingPathComponent("iCrave.sqlite")
        return storeURL!
    }

}
