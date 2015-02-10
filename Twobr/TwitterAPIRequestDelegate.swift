//
//  TwitterAPIRequestDelegate.swift
//  Twobr
//
//  Created by Jim Schultz on 2/10/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!)
}