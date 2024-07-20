//  Created by Raidel Almeida on 7/3/24.
//
// LeaderboardView.swift
// memoriah

import SwiftData
import SwiftUI

// MARK: - LeaderboardView

struct LeaderboardView: View {
    // MARK: Internal

    var body: some View {
        List {
            ForEach(gameSessions) { session in
                HStack {
                    Text(session.user?.userName ?? "Unknown")
                    Spacer()
                    Text("Score: \(session.score)")
                    Text("Time: \(String(format: "%.2f", session.timeElapsed))")
                }
            }
        }
        .navigationTitle("Leaderboard")
    }

    // MARK: Private

    @Query(sort: \GameSession.score, order: .reverse) private var gameSessions: [GameSession]
}

#Preview {
    LeaderboardView()
        .modelContainer(for: [User.self, GameSession.self], inMemory: true)
}
