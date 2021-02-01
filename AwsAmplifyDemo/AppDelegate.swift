//
//  AppDelegate.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 20/01/2021.
//

import UIKit
import Amplify
import AmplifyPlugins
import AWSMobileClient
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        let storagePlugin = AWSCognitoAuthPlugin()
         do {
           try Amplify.add(plugin: storagePlugin)
           try Amplify.configure()
            Amplify.Logging.logLevel = .verbose
           print("Amplify configured with storage plugin")
          } catch {
            print("Failed to initialize Amplify with \(error)")
          }
    
        AWSMobileClient.default().initialize { (user , error) in
            if let userState = user {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

