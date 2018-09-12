//
//  TSLoan.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import ObjectMapper

class TSLoan: TSBaseEntity {
    var id: Int?
    var phoneNumber: String?
    var fullName: String?
    var nationalIDNumber: String?
    var monthlyIncome: Int?
    var province: String?
    var income: Int? {
        didSet {
            if let income = self.income {
                self.monthlyIncome = income.toMonthyIncome
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case phoneNumber = "phone_number"
        case fullName = "full_name"
        case nationalIDNumber = "national_id_number"
        case monthlyIncome = "monthly_income"
        case province = "province"
    }
    
    override func mapping(map: Map) {
        self.id <- map[CodingKeys.id.rawValue]
        self.phoneNumber <- map[CodingKeys.phoneNumber.rawValue]
        self.fullName <- map[CodingKeys.fullName.rawValue]
        self.nationalIDNumber <- map[CodingKeys.nationalIDNumber.rawValue]
        self.monthlyIncome <- map[CodingKeys.monthlyIncome.rawValue]
        self.province <- map[CodingKeys.province.rawValue]
    }
}
