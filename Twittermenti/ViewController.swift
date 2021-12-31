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
import SwiftyJSON


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

        request()
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
    fileprivate func prinError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    fileprivate func request() {
        var tweetSentiment = [TweetSentimentClassifierInput]()
        
        swifter?.searchTweet(using: "@Facebook", lang: "en", count: 100, tweetMode: .extended, success: {
            (result, metadata) in
                        
            result.array?.forEach({ json in
                if let description = json["full_text"].string {
                    tweetSentiment.append(TweetSentimentClassifierInput(text: description))
                }
            })
            
            self.obtainPrediction(tweetSentiment)
            
        }, failure: { error in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    fileprivate func obtainPrediction(_ tweetSentiment: [TweetSentimentClassifierInput]) {
        
        var score = 0
        
        do {
            
            guard let predictions = try tweetSentimentClassifier?.predictions(inputs: tweetSentiment) else {
                return
            }
            
            predictions.forEach { tweetSentiment in
                
                if tweetSentiment.label == "Pos" {
                    score+=1
                } else if tweetSentiment.label == "Neg" {
                    score-=1
                }
                
                print("Label: \(tweetSentiment.label) : Score: \(score)")
            }
            
            print("Final Score: \(score)")
            
        } catch  {
            prinError(error)
        }
    }
}

