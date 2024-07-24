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
                Image(.brain2)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .phaseAnimator([false, true]) { brain2, chromaRotate in brain2
                        .scaleEffect(1, anchor: chromaRotate ? .bottom : .topTrailing)
                        .hueRotation(.degrees(chromaRotate ? 400 : 0))
                    } animation: { _ in
                        .easeInOut(duration: 2)
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
               
                NavigationLink("🖊️ Create Card", destination: FlashcardCreationView())
                    .font(.title)
                    .buttonStyle(.borderedProminent)
                
                NavigationLink("📓 Memory Cards", destination: FlashcardView())
                    .font(.title)
                    .buttonStyle(.borderedProminent)
                
                NavigationLink("🤓 Quiz Mode", destination: FlashcardQuizView())
                    .font(.title)
                    .padding(.bottom, 10)
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