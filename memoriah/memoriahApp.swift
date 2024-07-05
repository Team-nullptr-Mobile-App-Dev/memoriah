//  Created by Raidel Almeida on 7/3/24.
//
//  memoriahApp.swift
//  memoriah
//
//

import SwiftUI
import CoreData

@main
struct memoriahApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
