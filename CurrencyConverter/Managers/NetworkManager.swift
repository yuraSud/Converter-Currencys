import Foundation
import CoreData

struct NetworkManager {
    
//    lazy var coreData = CoreDataManager.instance
    
    func fetchCurrency(for date: Date, completionhandler: @escaping (Data?,Error?) ->(Void) ) {
        
        let session = URLSession.shared
        guard let url = URL(string: "https://api.privatbank.ua/p24api/exchange_rates?json&date=\(date.formateDateToJsonRequest())") else {
            completionhandler(nil,NetworkRequestError.notValidURL)
            return}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil, NetworkRequestError.noData)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil, NetworkRequestError.statusCode)
            }
            print("Получил дата с интернета")
            //if let currency = parseJSON(data: data) {
                completionhandler(data, nil)
            //}
        }
        task.resume()
    }
    
    func parseCurrency(_ jsonData: Data?, completionhandler: @escaping (CurrencyModel?)->()){
        guard let data = jsonData else {
            completionhandler(nil)
            return
        }
        if let currency = parseJSON(data: data) {
            completionhandler(currency)
        }
    }
    
    private func parseJSON(data: Data) -> CurrencyModel? {
        
        do{
            let exchangeData = try JSONDecoder().decode(Exchange.self, from: data)
            guard let currencyModel = CurrencyModel(exchangeData) else { return nil
            }
            return currencyModel
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

