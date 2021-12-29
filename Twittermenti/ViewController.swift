//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
    private let swifter: Swifter? = {
        
        if let path = Bundle.main.path(forResource: "secrets", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path) as? [String: String]
            
            if let consumerKey = dict?["APIKey"], let consumerSecret = dict?["APIKeySecret"] {
                return Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
            }
        }
        
        return nil
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        swifter?.searchUsers(using: "@Apple", success: { result in
            print(result)
        }, failure: { error in
            print("Error: \(error.localizedDescription)")
        })
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

