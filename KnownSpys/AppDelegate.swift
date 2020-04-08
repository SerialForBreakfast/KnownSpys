import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var dependencyRegistry: DependencyRegistry!
    
    static var navigationCoordinator: NavigationCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //MockedWebServer.sharedInstance.start()
        return true
    }
    
}

