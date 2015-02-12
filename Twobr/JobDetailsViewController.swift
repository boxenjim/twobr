//
//  JobDetailsViewController.swift
//  Twobr
//
//  Created by Jim Schultz on 2/10/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit

class JobDetailsViewController: UIViewController, TwitterAPIRequestDelegate {
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var imageURL: NSURL? = nil
    
    @IBAction func unwindToJobDetailsVC(segue: UIStoryboardSegue?){}
    @IBAction func finishedViewingImageDetailVC(segue: UIStoryboardSegue) {}
    
    var tweetIdString: String? {
        didSet {
            reloadJobDetails()
        }
    }
    
    func reloadJobDetails() {
        if tweetIdString == nil {
            return
        }
        
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["id":tweetIdString!]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            
            if let tweetDict = jsonObject as? [String:AnyObject] {
                dispatch_async(dispatch_get_main_queue(), {
                    let userDict = tweetDict["user"] as NSDictionary
                    self.userRealNameLabel.text = userDict["name"] as? String
                    self.userScreenNameLabel.text = userDict["screen_name"] as? String
                    self.tweetTextLabel.text = tweetDict["text"] as? String
                    let userImageURL = NSURL(string: userDict["profile_image_url"] as String!)
                    self.userImageButton.setTitle(nil, forState: UIControlState.Normal)
                    if userImageURL != nil {
                        if let imageData = NSData(contentsOfURL: userImageURL!) {
                            self.userImageButton.setImage(UIImage(data: imageData), forState: UIControlState.Normal)
                        }
                    }
                    if let entities = tweetDict["entities"] as? NSDictionary {
                        if let media = entities["media"] as? NSArray {
                            if let mediaString = media[0]["media_url"] as? String {
                                self.imageURL = NSURL(string: mediaString)
                                if self.imageURL != nil {
                                    if let mediaData = NSData(contentsOfURL: self.imageURL!) {
                                        self.tweetImageView.image = UIImage(data: mediaData)
                                        self.tweetImageView.userInteractionEnabled = true
                                    } else {
                                        self.tweetImageView.userInteractionEnabled = false
                                    }
                                } else {
                                    self.tweetImageView.userInteractionEnabled = false
                                }
                            }
                        }
                    }
                })
            } else {
                println("handleTwitterData received no data")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadJobDetails()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserDetailsSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = userScreenNameLabel.text
            }
        } else if segue.identifier == "showImageDetailSegue" {
            if let imageDetailVC = segue.destinationViewController as? ImageDetailViewController {
                imageDetailVC.imageURL = self.imageURL
            }
        }
    }
}
