//
//  TwobrDataModel.swift
//  Twobr
//
//  Created by Jim Schultz on 2/11/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import Swifties

class TwobrDataModel: BasicDataModel {
    class var sharedStore: TwobrDataModel {
        struct Singleton {
            static let instance = TwobrDataModel()
        }
        return Singleton.instance
    }
}
