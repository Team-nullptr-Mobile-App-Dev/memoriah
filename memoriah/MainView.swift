//  Created by Raidel Almeida on 7/3/24.
//
//  ContentView.swift
//  memoriah
//
//

import SwiftUI
import CoreData

struct MainView: View {
    @State private var showLeaderboard = false
    @State private var showProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("memoriah")
                    .font(.largeTitle)
                    .padding(.bottom, 200)
                    .dynamicTypeSize(.xxxLarge)
                Text("Pick a mode")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                NavigationLink("Practice Mode", destination: GameBoardView(mode: .practice)).font(.title).padding(.bottom, 10)
                NavigationLink("Timed Mode", destination: GameBoardView(mode: .timed)).font(.title)
            }
            .navigationBarItems(
                leading: Button("Leaderboard") { showLeaderboard.toggle() },
                trailing: Button("Profile") { showProfile.toggle() }
            )
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
        }
        .sheet(isPresented: $showProfile) {
            UserProfileView()
        }
    }
    //        .alert(item: $activeError) { error in
    //            Alert(
    //                title: Text("Error"),
    //                message: Text(error.localizedDescription),
    //                dismissButton: .default(Text("OK"))
    //            )
    //        }
}


#Preview {
    MainView()
}
