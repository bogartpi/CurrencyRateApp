
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.lightGray
        window = UIWindow(frame: UIScreen.main.bounds)
        let currencyListVC = CurrencyListRouter.createModule()
        window?.rootViewController = UINavigationController(rootViewController: currencyListVC)
        window?.makeKeyAndVisible()
        return true
    }

}

