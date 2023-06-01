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
    var baseCurrency: BaseCurrency?
    let currency: String
    var saleRateNB: Double?
    var purchaseRateNB: Double?
    var saleRate: Double?
    var purchaseRate: Double?
    var textFieldDoubleValue: Double?
    
    var fullDescription: String {
        return currency + " - " + (currencyDictionary[currency] ?? "")
    }
    var firstLetter: String {
        return currency[currency.startIndex].uppercased()
    }
}


