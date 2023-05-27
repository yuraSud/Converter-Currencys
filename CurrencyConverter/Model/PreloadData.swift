//
//  PreloadData.swift
//  CurrencyConverter
//
//  Created by YURA																			 on 27.05.2023.
//

import Foundation

struct PreloadData {
   
    public func preloadData(){
        let preloadDataKey = "PreloadDataKey"
        let coreDataManager = CoreDataManager.instance
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: preloadDataKey) {
            let backgroundContext = coreDataManager.persistentContainer.newBackgroundContext()
            coreDataManager.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                let namesCurrency = ["UAH", "USD", "EUR"]
                do {
                    namesCurrency.forEach { name in
                        coreDataManager.newCurrencyCoreFromString(name)
                    }
                    try backgroundContext.save()
                    userDefaults.set(true, forKey: preloadDataKey)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("not create, already existing")
        }
    }
}
