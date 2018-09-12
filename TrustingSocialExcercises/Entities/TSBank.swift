//
//  TSBank.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import ObjectMapper

class TSBank: TSBaseEntity {
    var name: String?
    var logo: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case logo = "logo"
    }
    
    override func mapping(map: Map) {
        self.name <- map[CodingKeys.name.rawValue]
        self.logo <- map[CodingKeys.logo.rawValue]
    }
}
