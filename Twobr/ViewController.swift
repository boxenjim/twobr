//
//  ViewController.swift
//  Twobr
//
//  Created by Jim Schultz on 2/9/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = []
    
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
    
    @IBAction func handleRefresh(sender : AnyObject?) {
        reloadTweets()
        refreshControl!.endRefreshing()
    }
    
    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
            (granted: Bool, error: NSError!) -> Void in
            if !granted {
                println("account access not granted")
            } else {
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                if twitterAccounts.count == 0 {
                    println("no twitter accounts configured")
                } else {
                    let twitterParams = ["count":"100"]
                    let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                                            requestMethod: SLRequestMethod.GET,
                                            URL: twitterAPIURL,
                                            parameters: twitterParams)
                    request.account = twitterAccounts.first as ACAccount
                    request.performRequestWithHandler({
                        (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                        self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                    })
                }
            }
        })
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            
            if let jsonArray = jsonObject as? [[String:AnyObject]] {
                self.parsedTweets.removeAll(keepCapacity: true)
                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetText = tweetDict["text"] as? String
                    parsedTweet.createdAt = tweetDict["created_at"] as? String
                    let userDict = tweetDict["user"] as NSDictionary
                    parsedTweet.userName = userDict["name"] as? String
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as String!)
                    self.parsedTweets.append(parsedTweet)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        } else {
            println("handleTwitterData recieved no data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDelegate UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParsedTweetCell") as ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        if parsedTweet.userAvatarURL != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let imageData = NSData(contentsOfURL: parsedTweet.userAvatarURL!) {
                    let avatarImage = UIImage(data: imageData)
                    dispatch_async(dispatch_get_main_queue(), {
                        if cell.userNameLabel.text == parsedTweet.userName {
                            cell.avatarImageView.image = avatarImage
                        } else {
                            println("oops, wrong cell, never mind")
                        }
                    })
                }
            })
        }
        return cell
    }
}

