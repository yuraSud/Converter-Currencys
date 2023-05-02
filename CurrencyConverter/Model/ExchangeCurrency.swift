import Foundation

// MARK: - Exchange
struct Exchange: Codable {
    let date: String
    let bank: String
    let baseCurrency: Int
    let baseCurrencyLit: BaseCurrency
    let exchangeRate: [Currency]
}

enum BaseCurrency: String, Codable {
    case uah = "UAH"
}

// MARK: - Currency
struct Currency: Codable {
    let baseCurrency: BaseCurrency?
    let currency: String
    let saleRateNB: Double?
    let purchaseRateNB: Double?
    let saleRate: Double?
    let purchaseRate: Double?
    var textFieldDoubleValue: Double?
    
    var fullDescription: String {
        return currency + " - " + (currencyDictionary[currency] ?? "")
    }
    var firstLetter: String {
        return currency[currency.startIndex].uppercased()
    }
}
