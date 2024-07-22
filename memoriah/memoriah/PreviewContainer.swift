//
//  PreviewContainer.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/21/24.
//

import SwiftData
import SwiftUI

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: User.self, GameSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        // Create sample users
        let user1 = User(avatar: "😀", bestTime: 45.0, gamesPlayed: 20, userName: "Alice")

        container.mainContext.insert(user1)

        // Create sample game sessions
        let currentDate = Date()
        let calendar = Calendar.current

        // Function to create a GameSession
        @MainActor func createSession(user: User, daysAgo: Int, score: Int32, timeElapsed: Double, mode: String) {
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: currentDate)!
            let session = GameSession(data: date, id: UUID(), mode: mode, score: score, timeElapsed: timeElapsed)
            session.user = user
            container.mainContext.insert(session)
        }

        // Sessions for Alice
        createSession(user: user1, daysAgo: 0, score: 100, timeElapsed: 45.0, mode: "Timed")
        createSession(user: user1, daysAgo: 0, score: 95, timeElapsed: 48.0, mode: "Timed")
        createSession(user: user1, daysAgo: 2, score: 110, timeElapsed: 50.0, mode: "Timed")
        createSession(user: user1, daysAgo: 3, score: 105, timeElapsed: 52.0, mode: "Timed")
        createSession(user: user1, daysAgo: 5, score: 95, timeElapsed: 47.0, mode: "Timed")
        createSession(user: user1, daysAgo: 7, score: 100, timeElapsed: 50.0, mode: "Timed")
        createSession(user: user1, daysAgo: 10, score: 120, timeElapsed: 55.0, mode: "Timed")
        createSession(user: user1, daysAgo: 15, score: 115, timeElapsed: 54.0, mode: "Timed")
        createSession(user: user1, daysAgo: 30, score: 90, timeElapsed: 46.0, mode: "Timed")
        createSession(user: user1, daysAgo: 45, score: 85, timeElapsed: 47.0, mode: "Timed")
        createSession(user: user1, daysAgo: 60, score: 105, timeElapsed: 49.0, mode: "Timed")

        createSession(user: user1, daysAgo: 90, score: 110, timeElapsed: 53.0, mode: "Timed")

        return container
    } catch {
        fatalError("Failed to create preview container: \(error.localizedDescription)")
    }
}()
