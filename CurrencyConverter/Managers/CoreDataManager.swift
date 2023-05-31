import CoreData
import UIKit

class CoreDataManager {
   
    static let instance = CoreDataManager()
    
    let context: NSManagedObjectContext
    
    var persistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        self.context = self.persistentContainer.viewContext
    }
    
    init(_ mainContext: NSManagedObjectContext) {
        self.context = mainContext
    }
    
    //Return JsonCurrencys from CoreData if date store difference current Date less 20 hours
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
    
    //Return Name Currencys from CoreData which are displayed in the main table
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
            }
            return array
        }
   
    //Create CurrencyCore entity from Currency and save in CoreData
    func newCurrencyCore(_ currency: Currency) {
        let newCurrencyCore = CurrencyCore(context: context)
        newCurrencyCore.currencyName = currency.currency
        newCurrencyCore.idTime = Date()
        saveContext()
    }
    
    //Create CurrencyCore entity from String and save in CoreData
    func newCurrencyCoreFromString(_ currencyName: String) {
        let newCurrencyCore = CurrencyCore(context: context)
        newCurrencyCore.currencyName = currencyName
        newCurrencyCore.idTime = Date()
        saveContext()
    }
    
    //Create JsonCurrency entity from Data and save in CoreData
    func newjsonCurrencys(jsonCurrencyData: Data?, date: Date) {
        let newjsonCurrencys = JsonCurrencys(context: context)
        guard let dataJson = jsonCurrencyData else {return}
        newjsonCurrencys.dateFetch = date
        newjsonCurrencys.jsonData = dataJson
        saveContext()
    }
    
    //Delete CurrencyCore
    func deleteCurrencyCore(_ indexDelete: Int){
        let fetchRequest = NSFetchRequest<CurrencyCore>(entityName: "CurrencyCore")
        let sortDescriptorToIdTime = NSSortDescriptor(key: #keyPath(CurrencyCore.idTime), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorToIdTime]
        
        do{
            let currencyCores = try context.fetch(fetchRequest)
            context.delete(currencyCores[indexDelete])
            saveContext()
        } catch {
            print("not fetch users")
        }
    }

    // MARK: - Core Data Saving support

    func saveContext () {
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


