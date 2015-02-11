//
//  UserDetailViewController.swift
//  Twobr
//
//  Created by Jim Schultz on 2/10/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!

    var screenName: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if screenName == nil {
            return
        }
        
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["screen_name":screenName!]
        let twitterAPIURL = NSURL(string: "http://api.twitter.com/1.1/users/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            let jsonString = NSString(data: dataValue, encoding: NSUTF8StringEncoding)
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            if let tweetDict = jsonObject as? [String:AnyObject] {
                dispatch_async(dispatch_get_main_queue(), {
                    self.userRealNameLabel.text = tweetDict["name"] as? NSString
                    self.userScreenNameLabel.text = tweetDict["screen_name"] as? NSString
                    self.userLocationLabel.text = tweetDict["location"] as? NSString
                    self.userDescriptionLabel.text = tweetDict["description"] as? NSString
                    if let userImageURL = NSURL(string: tweetDict["profile_image_url"] as NSString) {
                        if let userImageData = NSData(contentsOfURL: userImageURL) {
                            self.userImageView.image = UIImage(data: userImageData)
                        }
                    }
                })
            }
        }
    }
}
