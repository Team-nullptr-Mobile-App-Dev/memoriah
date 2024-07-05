//  Created by Raidel Almeida on 7/3/24.
//
//  GameCompletionView.swift
//  memoriah
//
//

import SwiftUI

struct GameCompletionView: View {
    let mode: GameBoardView.GameMode
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
            
            Text("Time: \(String(format: "%.2f", timeElapsed)) seconds")
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
}
