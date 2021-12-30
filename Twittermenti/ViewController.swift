//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

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
    
    private lazy var tweetSentimentClassifier: TweetSentimentClassifier? = {
        
        guard let result = try? TweetSentimentClassifier(contentsOf: TweetSentimentClassifier.urlOfModelInThisBundle) else {
            fatalError("Error create classifier")
        }
        
        return result
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let result = try! tweetSentimentClassifier?.prediction(text: "@Apple is amzing")
        
        print(result?.label)
        
        swifter?.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended, success: {
            (result, metadata) in
            print(result)
        }, failure: { error in
            print("Error: \(error.localizedDescription)")
        })
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

