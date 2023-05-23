import Foundation

struct CurrencyModel {
    let date: String
    let currencys: [Currency]
    
    init?(_ exchange: Exchange){
        self.date = exchange.date
        self.currencys = exchange.exchangeRate
    }
}

