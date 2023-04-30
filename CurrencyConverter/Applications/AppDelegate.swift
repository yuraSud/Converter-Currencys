
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadData()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func preloadData(){
        let preloadDataKey = "PreloadDataKey"
        let coreDataManager = CoreDataManager.instance
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: preloadDataKey) == false {
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
                    print("Setup backgroundContext")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("not create, already existing")
        }
    }
}
