//
//  weatherApp.swift
//  weather
//
//  Created by Владислав Космачев.
//

import SwiftUI

@main
struct weatherApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext).preferredColorScheme(.light)
        }
    }
}
