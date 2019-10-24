//
//  CoreDataManager.swift
//  iCrave
//
//  Created by Kevin Kim on 24/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    private init() {}
}
