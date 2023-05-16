import CoreData
import UIKit

class CoreDataManager {
   
    static let instance = CoreDataManager()
    private init(){}
    
    lazy var context = persistentContainer.viewContext
    
       
    func getJsonCurrencysForDate(date: Date) -> JsonCurrencys? {
        var jsonCurrencys: [JsonCurrencys] = []
        let fetchRequest = NSFetchRequest<JsonCurrencys>(entityName: "JsonCurrencys")
        do{
            jsonCurrencys = try context.fetch(fetchRequest)
        } catch {
            print("not fetch users")
        }
        for item in jsonCurrencys {
            if date.differenceCalculation(date: item.dateFetch!) {
                return item
            }
        }
        return nil
    }
    
    func getCurrencyFromCore() -> [String] {
            var currencyCore: [CurrencyCore] = []
            let fetchRequest = NSFetchRequest<CurrencyCore>(entityName: "CurrencyCore")
            
            let sortDescriptorToIdTime = NSSortDescriptor(key: #keyPath(CurrencyCore.idTime), ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptorToIdTime]
            
            do{
                currencyCore = try context.fetch(fetchRequest)
            } catch {
                print("not fetch users")
            }
            var array = [String]()
            currencyCore.forEach { item in
                array.append(item.currencyName ?? "")
                print(item.currencyName ?? "", "nameItemCurrency")
            }
            return array
        }
   
    func newCurrencyCore(_ currency: Currency) {
        
        let newCurrencyCore = CurrencyCore(context: context)
        
        newCurrencyCore.currencyName = currency.currency
        newCurrencyCore.idTime = Date()
        print("Create currencyCore")
        saveContext()
    }
    
    func newCurrencyCoreFromString(_ currencyName: String) {
        
        let newCurrencyCore = CurrencyCore(context: context)
        newCurrencyCore.currencyName = currencyName
        newCurrencyCore.idTime = Date()
        print("Create currencyCoreForString")
        saveContext()
    }
    
    func newjsonCurrencys(jsonCurrencyData: Data?, date: Date) {
        
        let newjsonCurrencys = JsonCurrencys(context: context)
        guard let dataJson = jsonCurrencyData else {return}
        newjsonCurrencys.dateFetch = date
        newjsonCurrencys.jsonData = dataJson
        print("create jsonCurrency")
        saveContext()
    }
    
    func deleteCurrencyCore(currencyToDelete: Currency){
        var currencyCores: [CurrencyCore] = []
        let fetchRequest = NSFetchRequest<CurrencyCore>(entityName: "CurrencyCore")
        do{
            currencyCores = try context.fetch(fetchRequest)
        } catch {
            print("not fetch users")
        }
        for item in currencyCores {
            if item.currencyName == currencyToDelete.currency {
                context.delete(item)
                saveContext()
            }
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


