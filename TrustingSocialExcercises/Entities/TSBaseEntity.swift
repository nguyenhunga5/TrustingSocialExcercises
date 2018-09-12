//
//  TSBaseEntity.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import ObjectMapper

class TSBaseEntity: NSObject, Mappable {
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
    }
}
