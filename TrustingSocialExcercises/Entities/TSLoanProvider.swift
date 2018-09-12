//
//  TSLoanProvider.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import ObjectMapper

class TSLoanProvider: TSBaseEntity {
    var minAmount, maxAmount, minTenor, maxTenor: Int?
    var interestRate: Double?
    var bank: TSBank?
    
    enum CodingKeys: String, CodingKey {
        case minAmount = "min_amount"
        case maxAmount = "max_amount"
        case minTenor = "min_tenor"
        case maxTenor = "max_tenor"
        case interestRate = "interest_rate"
        case bank = "bank"
    }
    
    override func mapping(map: Map) {
        self.minAmount <- map[CodingKeys.minAmount.rawValue]
        self.maxAmount <- map[CodingKeys.maxAmount.rawValue]
        self.minTenor <- map[CodingKeys.minTenor.rawValue]
        self.maxTenor <- map[CodingKeys.maxTenor.rawValue]
        self.interestRate <- map[CodingKeys.interestRate.rawValue]
        self.bank <- map[CodingKeys.bank.rawValue]
    }
}
