//  Created by Raidel Almeida on 7/3/24.
//
//  LeaderboardView.swift
//  memoriah
//
//

import SwiftUI
import CoreData

struct LeaderboardView: View {
    @FetchRequest(
        entity: GameSession.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GameSession.score, ascending: false)]
    ) var gameSessions: FetchedResults<GameSession>
    
    var body: some View {
        List {
            ForEach(gameSessions) { session in
                HStack {
                    Text(session.user?.username ?? "Unknown")
                    Spacer()
                    Text("Score: \(session.score)")
                    Text("Time: \(String(format: "%.2f", session.timeElapsed))")
                }
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
