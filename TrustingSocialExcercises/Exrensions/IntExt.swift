//
//  IntExt.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/12/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

extension Int {
    var toMonthyIncome: Int {
        let returnValue: Int
        if (3000000...10000000).contains(self) {
            returnValue = 3000001
        } else if (10000001...Int.max).contains(self) {
            returnValue = 10000001
        } else {
            returnValue = 1
        }
        return returnValue
    }
    
    func toString(groupingSeparator: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.none
        numberFormatter.groupingSeparator = groupingSeparator
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
