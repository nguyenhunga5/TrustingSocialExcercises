//
//  TSNetwork.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ObjectMapper

class TSNetwork: NSObject {
    private static let instance = TSNetwork()
    static var sharred: TSNetwork {
        return TSNetwork.instance
    }
    
    var index = 0
    
    func getJsonPath(fileName: String) -> String? {
        let filePath = Bundle.main.path(forResource: fileName, ofType: nil, inDirectory: "MockData")
        return filePath
    }
    
    func getProvinces(complete: (_ provicens: TSProvinces?) -> Void) {
        
        if let filePath = self.getJsonPath(fileName: "provinces.json"),
            let jsonString = try? String(contentsOfFile: filePath) {
            let provicens: TSProvinces? = Mapper<TSProvinces>().map(JSONString: jsonString)
            complete(provicens)
        } else {
            complete(nil)
        }
    }
    
    func getLoanProvider(complete: (_ loanProvider: TSLoanProvider?) -> Void) {
        
        if let filePath = self.getJsonPath(fileName: "loan_providers.json"),
            let jsonString = try? String(contentsOfFile: filePath) {
            let loanProvider: TSLoanProvider? = Mapper<TSLoanProvider>().map(JSONString: jsonString)
            complete(loanProvider)
        } else {
            complete(nil)
        }
    }
    
    func makeLoan(loan: TSLoan, complete: (_ loan: TSLoan?) -> Void) {
        var resultJson = loan.toJSON()
        index += 1
        resultJson[TSLoan.CodingKeys.id.rawValue] = index
        let result: TSLoan? = Mapper<TSLoan>().map(JSON: resultJson)
        complete(result)
    }
    
    func loadBankLogo(url: URL, complete: @escaping (_ logo: UIImage?) -> Void) {
        Alamofire.request(url).responseImage { response in
            complete(response.value)
        }
    }
}
