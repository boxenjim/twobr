//
//  ViewController.swift
//  Twobr
//
//  Created by Jim Schultz on 2/9/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func handleShowMyTweetsButtonTapped(sender: UIButton) {
        reloadTweets()
    }
    
    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in iOS 8 SDK Development")
            presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("can't send tweet")
        }
    }
    
    func reloadTweets() {
        let url = NSURL(string: "http://www.twitter.com/boxenjim")
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

