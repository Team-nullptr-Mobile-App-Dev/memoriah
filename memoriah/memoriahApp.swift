//
//  memoriahApp.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/3/24.
//

import SwiftUI

@main
struct memoriahApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
