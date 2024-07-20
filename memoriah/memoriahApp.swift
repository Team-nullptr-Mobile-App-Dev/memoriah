//  Created by Raidel Almeida on 7/3/24.
//
//  memoriahApp.swift
//  memoriah
//
//

import SwiftData
import SwiftUI

@main
struct memoriahApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [User.self, GameSession.self])
    }
}
