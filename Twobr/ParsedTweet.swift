//
//  ParsedTweet.swift
//  Twobr
//
//  Created by Jim Schultz on 2/9/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
    var tweetIdString: String?
    var tweetText: String?
    var userName: String?
    var createdAt: String?
    var userAvatarURL: NSURL?
    
    override init() {
        super.init()
    }
    
    init(tweetIdString: String?, tweetText: String?, userName: String?, createdAt: String?, userAvatarURL: NSURL?) {
        super.init()
        self.tweetIdString = tweetIdString
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
    }
}
