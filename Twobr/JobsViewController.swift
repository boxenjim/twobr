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
import Swifties

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

class JobsViewController: UITableViewController, TwitterAPIRequestDelegate {
    
    var jobDetailsVC: JobDetailsViewController? = nil
    
    var searchRequest: TwitterAPIRequest? = nil
    var feedRequest: TwitterAPIRequest? = nil
    
    var feedSinceID: String? = nil
    var searchSinceID: String? = nil
    var jobsArray: [ParsedTweet] = []
    
    var searchRegex: String = "(?:\\S+\\slooking|looking\\sfor|hiring\\sa?|hire\\s\\S+|\\S+\\shire)"
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("Hey tweoples, i'll looking for a new job, if you know of something give me a shout. #twobr")
            presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("can't send tweet")
        }
    }
    
    @IBAction func handleRefresh(sender : AnyObject?) {
        self.reloadTweets()
    }
    
    func reloadTweets() {
        
        if feedRequest == nil && searchRequest == nil {
            feedRequest = TwitterAPIRequest()
            
            // get home timeline
            var feedParams = ["count":"200"]
            if self.feedSinceID != nil {
                feedParams["since_id"] = self.feedSinceID
            }
            
            let feedAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
            feedRequest!.sendTwitterRequest(feedAPIURL, params: feedParams, delegate: self)
        }
    }
    
    func searchForJobs() {
        searchRequest = TwitterAPIRequest()
        // get search results
        var searchParams = ["count":"20", "q":"job, hire, hiring"]
        if self.searchSinceID != nil {
            searchParams["since_id"] = self.searchSinceID
        }
        
        let searchAPIURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json")
        searchRequest!.sendTwitterRequest(searchAPIURL, params: searchParams, delegate: self)
    }
    
    func regexCheckForMatch(text: NSString) -> Bool {
        var error: NSError?
        var regex = NSRegularExpression(pattern: searchRegex, options: .CaseInsensitive, error: &error)
        
        let matches = regex?.matchesInString(text, options: .allZeros, range: NSMakeRange(0, text.length))
        return matches?.count > 0
    }
    
    func parseFeedRequestResponse(jsonArray: [[String:AnyObject]]) {
        var tempArray: [ParsedTweet] = []
        for tweetDict in jsonArray {
//            let user: AnyObject? = tweetDict["user"]
//            println("user: \(user)")
            //let keywords = ["open", "available", "fill", "work", "job", "hire", "hiring", "career", "look", "need", "position", "search", "find", "help", "grow", "join", "apply", "application", "full-time", "part-time", "full time", "part time", "contractor", "freelance"]
            
//            let primaryKeywords = ["hire", "hiring"]
//            let secondaryKeywords = ["job", "career", "find", "looking", "part-time", "full-time", "freelance", "part time", "full time", "position", "twobr", "post", "build"]
//            
//            var score = 0
//            let scoreToBeat = 1
//            if let text = tweetDict["text"] as? NSString {
//                for keyword in primaryKeywords {
//                    if text.lowercaseString.rangeOfString(keyword) != nil {
//                        score += 2
//                    }
//                    if score > scoreToBeat { break }
//                }
//                
//                if score < scoreToBeat {
//                    for keyword in secondaryKeywords {
//                        if text.lowercaseString.rangeOfString(keyword) != nil {
//                            score += 1
//                        }
//                        if score > scoreToBeat { break }
//                    }
//                }
//            }
//            
//            if score < scoreToBeat {
//                if let retweetedStatus = tweetDict["retweeted_status"] as? NSDictionary {
//                    if let entities = retweetedStatus["entities"] as? NSDictionary {
//                        if let hashtags = entities["hashtags"] as? NSArray {
//                            for hashtag in hashtags {
//                                if let text = hashtag["text"] as? NSString {
//                                    for keyword in primaryKeywords {
//                                        if text.lowercaseString.rangeOfString(keyword) != nil {
//                                            score += 2
//                                        }
//                                        if score > scoreToBeat { break }
//                                    }
//                                    
//                                    if score < scoreToBeat {
//                                        for keyword in secondaryKeywords {
//                                            if text.lowercaseString.rangeOfString(keyword) != nil {
//                                                score += 1
//                                            }
//                                            if score > scoreToBeat { break }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        if let urls = entities["urls"] as? NSArray {
//                            for urlDict in urls {
//                                if let url = urlDict["display_url"] as? NSString {
//                                    for keyword in primaryKeywords {
//                                        if url.lowercaseString.rangeOfString(keyword) != nil {
//                                            score += 2
//                                        }
//                                        if score > scoreToBeat { break }
//                                    }
//                                    
//                                    if score < scoreToBeat {
//                                        for keyword in secondaryKeywords {
//                                            if url.lowercaseString.rangeOfString(keyword) != nil {
//                                                score += 1
//                                            }
//                                            if score > scoreToBeat { break }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
            
            //if score > scoreToBeat {
            if let text = tweetDict["text"] as? NSString {
                if self.regexCheckForMatch(text) {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetIdString = tweetDict["id_str"] as? NSString
                    parsedTweet.tweetText = tweetDict["text"] as? NSString
                    parsedTweet.createdAt = tweetDict["created_at"] as? NSString
                    let userDict = tweetDict["user"] as NSDictionary
                    parsedTweet.userName = userDict["name"] as? NSString
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as NSString!)
                    tempArray.append(parsedTweet)
                }
            }
        }
        if tempArray.count > 0 {
            self.feedSinceID = jsonArray[0]["id_str"] as? NSString
            self.jobsArray[0..<0] = tempArray[0..<tempArray.count]
        } else {
            self.searchForJobs()
        }
        
        self.feedRequest = nil
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
            if tempArray.count > 0 {
                self.refreshControl!.endRefreshing()
            }
        })
    }
    
    func parseSearchRequestResponse(jsonArray: NSArray) {
        var tempArray: [ParsedTweet] = []
        for tweetDict in jsonArray {
            let parsedTweet = ParsedTweet()
            parsedTweet.tweetIdString = tweetDict["id_str"] as? NSString
            parsedTweet.tweetText = tweetDict["text"] as? NSString
            parsedTweet.createdAt = tweetDict["created_at"] as? NSString
            let userDict = tweetDict["user"] as NSDictionary
            parsedTweet.userName = userDict["name"] as? NSString
            parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as NSString!)
            tempArray.append(parsedTweet)
        }
        if tempArray.count > 0 {
            self.searchSinceID = jsonArray[0]["id_str"] as? NSString
            self.jobsArray[0..<0] = tempArray[0..<tempArray.count]
        }
        
        self.searchRequest = nil;
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
            self.refreshControl!.endRefreshing()
        })
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                println("\(jsonObject)")
                return
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                if let jsonArray = jsonObject as? [[String:AnyObject]] {
                    if fromRequest == self.feedRequest {
                        self.parseFeedRequestResponse(jsonArray)
                    } else if fromRequest == self.searchRequest {
                        self.parseSearchRequestResponse(jsonArray)
                    }
                } else if let jsonDict = jsonObject as? [String:AnyObject] {
                    if let jsonArray = jsonDict["statuses"] as? [[String:AnyObject]] {
                        if fromRequest == self.feedRequest {
                            self.parseFeedRequestResponse(jsonArray)
                        } else if fromRequest == self.searchRequest {
                            self.parseSearchRequestResponse(jsonArray)
                        }
                    }
                } else {
                    println("json: \(jsonObject)")
                }
            })
        } else {
            println("handleTwitterData recieved no data")
        }
    }
    
    func retrieveRegex(success: Void -> Void, failure: Void -> Void) {
        let url = NSURL(string: "https://dl.dropboxusercontent.com/u/7188432/regex.html")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: .defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let html = NSString(data: data, encoding: NSUTF8StringEncoding)
            if let reg = html?.substringBetween("<html>", otherString: "</html>") {
                self.searchRegex = reg
                success()
            } else {
                failure()
            }
            self.reloadTweets()
        })
        task.resume()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            jobDetailsVC = controllers[controllers.count-1].topViewController as? JobDetailsViewController
        }
        
        retrieveRegex({}, failure: {})
        
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showJobDetailsSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let parsedTweet = jobsArray[indexPath.row] as ParsedTweet
                let controller = (segue.destinationViewController as UINavigationController).topViewController as JobDetailsViewController
                controller.tweetIdString = parsedTweet.tweetIdString
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // UITableViewDelegate UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParsedTweetCell") as ParsedTweetCell
        let parsedTweet = jobsArray[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
        let date = formatter.dateFromString(parsedTweet.createdAt!)
        let compsFormatter = NSDateComponentsFormatter()
        compsFormatter.maximumUnitCount = 1
        compsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        let comps = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: date!, toDate: NSDate(), options: NSCalendarOptions.allZeros)
        cell.createdAtLabel.text = compsFormatter.stringFromDateComponents(comps)
        
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            jobsArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

