
import XCTest
@testable import CurrencyConverter

final class CurrencyConverterUITests: XCTestCase {
   
    func testPossibilityInputAndDeleteValue() {
          let app = XCUIApplication()
          app.launch()
          let tablesQuery = app.tables
          tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.tap()
          XCTAssert(tablesQuery.buttons["Clear text"].exists)
          tablesQuery.buttons["Clear text"].tap()
          XCTAssertEqual(tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.value as! String, "")
          XCTAssert(app.toolbars["Toolbar"].buttons["Done"].exists)
          tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.typeText("2000")
          XCTAssert(tablesQuery.buttons["Clear text"].exists)
          app.toolbars["Toolbar"].buttons["Done"].tap()
          app/*@START_MENU_TOKEN@*/.buttons["Buy"]/*[[".segmentedControls.buttons[\"Buy\"]",".buttons[\"Buy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
          app/*@START_MENU_TOKEN@*/.buttons["Sell"]/*[[".segmentedControls.buttons[\"Sell\"]",".buttons[\"Sell\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      }
      
    func testExistsCurrenciesListTable() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Currency"]/*[[".buttons[\"Add Currency\"].staticTexts[\"Add Currency\"]",".staticTexts[\"Add Currency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["Currency"].exists)
        app.tables.cells.containing(.staticText, identifier:"AUD - Австралийский доллар").element/*@START_MENU_TOKEN@*/.press(forDuration: 6.1);/*[[".tap()",".press(forDuration: 6.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(app.staticTexts["AUD  "].exists)
        XCTAssertFalse(app.staticTexts["CAD  "].exists)
    }
          
      func testCurrencyTableDeleteCurrency() {
          let app = XCUIApplication()
          app.launch()
          app/*@START_MENU_TOKEN@*/.staticTexts["Add Currency"]/*[[".buttons[\"Add Currency\"].staticTexts[\"Add Currency\"]",".staticTexts[\"Add Currency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
          let tablesQuery = app.tables
          tablesQuery.cells.containing(.staticText, identifier:"CZK - Чешская крона").element/*@START_MENU_TOKEN@*/.press(forDuration: 1.7);/*[[".tap()",".press(forDuration: 1.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
          let czkCell = tablesQuery.cells.containing(.staticText, identifier:"CZK  ").element
          czkCell.swipeLeft()
          tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
          XCTAssertFalse(app.staticTexts["CZK  "].exists)
      }
      
      func testCurrencyTableUsingNationalBankExchangeRate() {
          let app = XCUIApplication()
          app.launch()
          XCTAssert(app.staticTexts["National Bank Exchange Rate"].exists)
          app.staticTexts["National Bank Exchange Rate"].tap()
          app.buttons["OK"].tap()
          XCTAssert(app.staticTexts["Return to course PB"].exists)
          app.staticTexts["Return to course PB"].tap()
      }
      
      func testCurrencyShareText() {
          let app = XCUIApplication()
          app.launch()
          app.buttons["square.and.arrow"].tap()
          XCTAssert(app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Choose what you want to share\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Share text"].exists)
          app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Choose what you want to share\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Share text"].tap()
          XCTAssert(app.buttons["Copy"].exists)
      }
        
      func testCurrencyShareImage() {
          let app = XCUIApplication()
          app.launch()
          app.buttons["square.and.arrow"].tap()
          XCTAssert(app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Choose what you want to share\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Share image"].exists)
          app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Choose what you want to share\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Share image"].tap()
          app/*@START_MENU_TOKEN@*/.collectionViews.containing(.button, identifier:"Copy").element/*[[".otherElements[\"ActivityListView\"]",".collectionViews.containing(.button, identifier:\"XCElementSnapshotPrivilegedValuePlaceholder\").element",".collectionViews.containing(.button, identifier:\"Print\").element",".collectionViews.containing(.button, identifier:\"Assign to Contact\").element",".collectionViews.containing(.button, identifier:\"Copy\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0,1]],[[-1,4],[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
          XCTAssert(app.buttons["square.and.arrow"].exists)
          
      }

}
