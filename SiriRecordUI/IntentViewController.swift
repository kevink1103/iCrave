//
//  IntentViewController.swift
//  SiriRecordUI
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        guard let intent = interaction.intent as? RecordIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        var desiredSize = self.view.frame.size
        desiredSize.height = 50
        
        let category = intent.category!
        let amount = decimalToString(intent.amount!.decimalValue)
        let currency = SharedUserDefaults.shared.getCurrency()
        
        categoryLabel.text = category
        amountLabel.text = "\(amount) \(currency)"
        // if let bgColor = Category.getObject(title: category)!.color {
        //     print(bgColor)
        //     view.backgroundColor = bgColor.getUIColor()
        // }
        
        completion(true, parameters, desiredSize)
    }
    
    // var desiredSize: CGSize {
    //     // return self.extensionContext!.hostedViewMinimumAllowedSize
    //     return CGSize.zero
    // }
    
}
