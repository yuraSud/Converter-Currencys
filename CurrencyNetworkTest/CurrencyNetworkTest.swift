//
//  CurrencyNetworkTest.swift
//  CurrencyConverterTests
//
//  Created by YURA																			 on 31.05.2023.
//

import XCTest
@testable import CurrencyConverter


final class CurrencyNetworkTest: XCTestCase {

    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
    }
    
    func testFetchCurrencyData()  {
        let expectation = expectation(description: "Currency data fetch from server")
       
        networkManager.fetchCurrency(for: Date()) { data, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testParseCurrencyDataToCurrencyModel() {
        let expectation = expectation(description: "Parse Json data to CurrencyModel ")
        var currencyData: Data?
        var currencyModels: CurrencyModel?
        
        networkManager.fetchCurrency(for: Date()) { data, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            currencyData = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
        XCTAssertNotNil(currencyData)
        
        networkManager.parseCurrency(currencyData) { currencyModel in
            guard currencyModel != nil else {
                XCTAssertNil(currencyModel)
                return
            }
            currencyModels = currencyModel
            XCTAssertNotNil(currencyModels)
        }
        
        XCTAssertTrue((currencyModels?.currencys.count)! > 10)
        XCTAssertFalse(currencyModels?.currencys.count == 0)
    }
}
