//
//  IntentHandler.swift
//  SiriRecord
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Intents
import UIKit

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        guard intent is RecordIntent else {
            fatalError("Unhandled Intent error : \(intent)")
        }
        return RecordIntentHandler()
    }
    
}
