//
//  TSProvinces.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import ObjectMapper

class TSProvinces: TSBaseEntity {
    var total: Int?
    var provincesList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case provincesList = "provinces_list"
    }
    
    override func mapping(map: Map) {
        self.total <- map[CodingKeys.total.rawValue]
        self.provincesList <- map[CodingKeys.provincesList.rawValue]
    }
    
    subscript(index: Int) -> String? {
        if let provincesList = self.provincesList, index > 0, index < provincesList.count {
            return provincesList[index]
        } else {
            return nil
        }
    }
}
