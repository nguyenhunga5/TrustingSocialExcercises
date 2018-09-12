//
//  StringExt.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import Foundation
import UIKit

enum InformationType: Int, CustomStringConvertible {
    case phone, fullname, id, address, income
    var description: String {
        let str: String
        switch self {
        case .phone:
            str = "Số điện thoại"
        case .fullname:
            str = "Họ tên"
        case .id:
            str = "CMND"
        case .address:
            str = "Địa chỉ"
        case .income:
            str = "Thu nhập"
        }
        return str
    }
}

fileprivate let firstMobileNumber = ["0120", "0121", "0122", "0123", "0124", "0125", "0126", "0127",
                                     "0128", "0129", "0162", "0163", "0164", "0165", "0166", "0167",
                                     "0168", "0169", "0186", "0188", "0199", "086", "088", "089",
                                     "090", "091", "092", "093", "094", "095", "096", "097", "098",
                                     "099"]

extension String {
    func validate(type: InformationType) -> Bool {
        switch type {
        case .id:
            return self.validateID()
        case .phone:
            return self.validatePhone()
        default:
            return false
        }
    }
    
    private func validatePhone() -> Bool {
        
        if self.count > 0 {
            let begin: String
            let totalNumber: Int
            var endIndex = self.index(self.startIndex, offsetBy: 1)
            if self[...endIndex] == "01" {
                endIndex = self.index(self.startIndex, offsetBy: 3)
                begin = String(self[...endIndex])
                totalNumber = 11
            } else {
                endIndex = self.index(self.startIndex, offsetBy: 2)
                begin = String(self[...endIndex])
                totalNumber = 10
            }
            
            return firstMobileNumber.contains(begin) && self.validateNumberOnly(totalNumber: totalNumber)
        } else {
            return false
        }
    }
    
    private func validateNumberOnly(totalNumber: Int) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\\d{\(count)}$", options: NSRegularExpression.Options.caseInsensitive)  else {
            return false
            
        }
        let matches = regex.matches(in: self,
                                    options: NSRegularExpression.MatchingOptions.anchored,
                                    range: NSRange(location: 0, length: count)
        )
        return matches.count > 0
    }
    
    private func validateID() -> Bool {
        let count = self.count
        if count == 9 || count == 12 {
            return self.validateNumberOnly(totalNumber: count)
        } else {
            return false
        }
    }
}
