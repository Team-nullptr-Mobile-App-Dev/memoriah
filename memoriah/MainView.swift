//  Created by Raidel Almeida on 7/3/24.
//
// MainView.swift
// memoriah

import SwiftUI

struct MainView: View {
    // MARK: Internal

    var body: some View {
        NavigationView {
            VStack {
                Image(.brain3)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .phaseAnimator([false, true]) { brain3, chromaRotate in brain3
                        .scaleEffect(1, anchor: chromaRotate ? .bottom : .topTrailing)
                        .hueRotation(.degrees(chromaRotate ? 60 : 0))
                    } animation: { _ in
                        .easeInOut(duration: 4)
                    }

                Text("memoriah")
                    .font(.custom("Futura", size: 50))
                    .padding(.bottom, 200)
                    .dynamicTypeSize(.xxxLarge)

                Text("Pick a mode")
                    .font(.headline)
                    .dynamicTypeSize(.xxxLarge)
                    .padding(.bottom, 20)

                NavigationLink("👶 Practice Mode", destination: GameBoardView(mode: .practice))
                    .font(.title)
                    .padding(.bottom, 10)
                    .buttonStyle(.borderedProminent)

                NavigationLink("⏰ Timed Mode", destination: GameBoardView(mode: .timed))
                    .font(.title)
                    .buttonStyle(.borderedProminent)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showLeaderboard.toggle()
                    }) {
                        Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfile.toggle()
                    }) {
                        Image("custom.person.circle.fill.badge.gearshape.fill")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showLeaderboard) {
                LeaderboardView()
            }
            .sheet(isPresented: $showProfile) {
                UserProfileView()
            }
        }
    }

    // MARK: Private

    @State private var showLeaderboard = false
    @State private var showProfile = false
}

#Preview {
    MainView()
        .modelContainer(previewContainer)

}
