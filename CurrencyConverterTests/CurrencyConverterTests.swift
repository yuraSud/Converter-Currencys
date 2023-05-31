
import XCTest
import CoreData
@testable import CurrencyConverter

final class CurrencyConverterTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    var coreDataTestStack: CoreDataTestStack!

    override func setUp() {
        super.setUp()
        coreDataTestStack = CoreDataTestStack()
        coreDataManager = CoreDataManager(coreDataTestStack.mainContext)
    }

    func testCreateCurrencyCoreFromString() {
        coreDataManager.newCurrencyCoreFromString("Euro")
        let currencyEuro = coreDataManager.getCurrencyFromCore()
        
        XCTAssertEqual("Euro", currencyEuro[0])
    }
        
    func testDeleteCurrencyCore() {
        coreDataManager.newCurrencyCoreFromString("Euro")
        coreDataManager.newCurrencyCoreFromString("US Dollar")
        coreDataManager.newCurrencyCoreFromString("Hryvnia")
        
        var currencyArrayInCore = coreDataManager.getCurrencyFromCore()
        XCTAssertEqual(currencyArrayInCore.count, 3)
        
        let currencyEuro = Currency(baseCurrency: nil, currency: "Euro", saleRateNB: nil, purchaseRateNB: nil, saleRate: nil, purchaseRate: nil)
        
        coreDataManager.deleteCurrencyCore(currencyToDelete: currencyEuro)
        currencyArrayInCore = coreDataManager.getCurrencyFromCore()
        
        XCTAssertEqual(currencyArrayInCore.count, 2)
        XCTAssertTrue(currencyArrayInCore.contains(where: {$0 == "Hryvnia"}))
        XCTAssertFalse(currencyArrayInCore.contains(where: {$0 == "Euro"}))
        XCTAssertTrue(currencyArrayInCore.contains(where: {$0 == "US Dollar"}))
    }
    
    func testCreateCurrencyCore() {
        let currencyCZK = Currency(baseCurrency: nil, currency: "CZK", saleRateNB: nil, purchaseRateNB: nil, saleRate: nil, purchaseRate: nil)
        coreDataManager.newCurrencyCore(currencyCZK)
        
        let currencyEuro = coreDataManager.getCurrencyFromCore()
        
        XCTAssertEqual("CZK", currencyEuro[0])
    }
    
    func testCreateAndGetJsonCurrencies() {
        let dataForTest = Data("Test String".utf8)
        //Create JsonCurrency
        coreDataManager.newjsonCurrencys(jsonCurrencyData: dataForTest, date: Date())
        
        //Create Date
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 4
        dateComponents.day = 15
        let dateTest = Calendar.current.date(from: dateComponents)!
        
        let jsonCurrencyNil = coreDataManager.getJsonCurrencysForDate(date: dateTest)
        XCTAssertNil(jsonCurrencyNil)
        
        let jsonCurrency = coreDataManager.getJsonCurrencysForDate(date: Date())
        XCTAssertNotNil(jsonCurrency)
        XCTAssertNotNil(jsonCurrency?.jsonData)
        
        let stringFromData = String(decoding: (jsonCurrency?.jsonData)!, as: UTF8.self)
        XCTAssertEqual(stringFromData, "Test String")
        XCTAssertNotEqual(stringFromData, "USD")
    }

}
