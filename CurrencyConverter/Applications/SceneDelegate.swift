
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let startVC = StartViewController()
        let navigationVC = UINavigationController(rootViewController: startVC)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.instance.saveContext()
    }
}

