//
//  TwitterAPIRequest.swift
//  Twobr
//
//  Created by Jim Schultz on 2/10/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import Social
import Accounts
import Swifties

class TwitterAPIRequest: NSObject {
    func sendTwitterRequest(requestURL: NSURL!, params: [String:String], delegate: TwitterAPIRequestDelegate?) {
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
                    return
                } else {
                    UIApplication.sharedApplication().pushNetworkActivity()
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: params)
                    request.account = twitterAccounts.first as ACAccount
                    request.performRequestWithHandler({
                        (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                        UIApplication.sharedApplication().popNetworkActivity()
                        delegate!.handleTwitterData(data, urlResponse: urlResponse, error: error, fromRequest: self)
                    })
                }
            }
        })
    }
}
