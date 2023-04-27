import Foundation

struct TransformCurrency {
    var headerArray: [String] = []
    var sections: [[Currency]] = [[]]
   private let popular = ["UAH","EUR","USD"]
    
    mutating func createDataSourceHeaderAndSections(model: CurrencyModel){
        var popularArrayCurrencys: [Currency] = []
        
        model.currencys.forEach{ value in
            headerArray.append(value.firstLetter)
            if popular.contains(value.currency) {
                popularArrayCurrencys.append(value)
            }
        }
        headerArray = Array(Set(headerArray)).sorted()
        sections = headerArray.map { firstLet in
            return model.currencys
                .filter { $0.firstLetter == firstLet }
                .sorted { $0.currency < $1.currency }
        }
        headerArray.insert("Popular", at: 0)
        sections.insert(popularArrayCurrencys, at: 0)
    }
}
