//
//  EnvironmentalistsApp.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/2/20.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct EnvironmentalistsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
