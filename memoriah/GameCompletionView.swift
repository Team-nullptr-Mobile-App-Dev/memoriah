//  Created by Raidel Almeida on 7/3/24.
//
// GameCompletionView.swift
// memoriah

import SwiftUI

struct GameCompletionView: View {
    let mode: GameMode
    let score: Int
    let timeElapsed: Double
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Mode: \(mode == .practice ? "Practice" : "Timed")")
                .font(.title2)
            
            Text("Score: \(score)")
                .font(.title2)
            
            Text("Time: \(formatTime(timeElapsed))")
                .font(.title2)
            
            Button("Back to Main Menu") {
                onDismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.top, 20)
        }
        .padding()
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct GameCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        GameCompletionView(mode: .practice, score: 100, timeElapsed: 75.5) {}
    }
}
