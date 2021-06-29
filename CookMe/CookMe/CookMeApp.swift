//
//  CookMeApp.swift
//  CookMe
//
//  Created by Torben Ziegler on 11.05.21.
//

import SwiftUI

@main
struct CookMeApp: App {
    // linking Persistence Controller to application
    let persistenceController = PersistenceController.shared
    
    @Environment (\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in // Tracking of current scene states
            switch newScenePhase {
            case .background:
                print("Scene is in background")
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("No purpose")
            }
        }
    }
}
