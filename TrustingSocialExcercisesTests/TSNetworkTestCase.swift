//
//  TSNetworkTestCase.swift
//  TrustingSocialExcercisesTests
//
//  Created by Hung Nguyen Thanh on 9/12/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import XCTest
@testable import TrustingSocialExcercises

class TSNetworkTestCase: XCTestCase {
    
    var provinces: TSProvinces?
    var loanProvider: TSLoanProvider?
    
    override func setUp() {
        super.setUp()
        
        TSNetwork.sharred.getProvinces { (provinces) in
            self.provinces = provinces
        }
        
        TSNetwork.sharred.getLoanProvider { (loanProvider) in
            self.loanProvider = loanProvider
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.provinces = nil
        self.loanProvider = nil
    }
    
    func testNetworkResponse() {
        XCTAssertNotNil(self.provinces)
        XCTAssertNotNil(self.loanProvider)
        XCTAssertNotNil(self.loanProvider?.bank)
        XCTAssertNotNil(self.loanProvider?.bank?.logo)
    }
    
    func testLoadLogo() {
        let url = URL(string: (self.loanProvider?.bank?.logo)!)
        XCTAssertNotNil(url)
        TSNetwork.sharred.loadBankLogo(url: url!) { (image) in
            XCTAssertNotNil(image)
        }
    }
    
    func testRequestLoan() {
        let loan = TSLoan()
        loan.fullName = "Nguyen Hung"
        loan.nationalIDNumber = "123456789"
        loan.income = 3000000
        loan.province = self.provinces![0]
        loan.phoneNumber = "01647199339"
        
        TSNetwork.sharred.makeLoan(loan: loan) { (loan) in
            XCTAssertNotNil(loan)
        }
    }
}
