//
//  SceneDelegate.swift
//  NFT_Marketplace
//
//  Created by Developer on 29/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static var shared: SceneDelegate?
    
    var tempScene : UIScene!
    
    var window: UIWindow?
    
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//
//        self.checkLogin()
//    }
   
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func checkLogin() {
        
        
        guard let windowScene = (tempScene as? UIWindowScene) else { return }
        
        SceneDelegate.shared = self
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        var navigationController: UINavigationController!
    
        if UserDefaultsManager.shared.isLoggedIn()
        {
                let userType =  UserDefaultsManager.shared.getUserType()
            
            if(userType  == "admin") {
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "AdminDashboard") as! AdminDashboard
                navigationController = UINavigationController(rootViewController: initialViewController)
                navigationController.navigationBar.isHidden = false
                
            }else if(userType == "student") {
                
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "StudentDashBoard") as! StudentDashBoard
                    navigationController = UINavigationController(rootViewController: initialViewController)
                    navigationController.navigationBar.isHidden = false
            }else {
                
                
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "FacultyDashBoard") as! FacultyDashBoard
                    navigationController = UINavigationController(rootViewController: initialViewController)
                    navigationController.navigationBar.isHidden = false
                
                
            }
                
        
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarHome") as! TabBarHome
            navigationController = UINavigationController(rootViewController: initialViewController)
            navigationController.navigationBar.isHidden = false
            
            
            
        }
        
        self.window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
       
        self.tempScene = scene
        self.checkLogin()
        
       
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

 
