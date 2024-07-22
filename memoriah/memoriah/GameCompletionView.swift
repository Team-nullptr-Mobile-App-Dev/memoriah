//  Created by Raidel Almeida on 7/3/24.
//
// GameCompletionView.swift
// memoriah

import SwiftUI

struct GameCompletionView: View {
    // MARK: Internal

    let mode: String
    let score: Int
    let timeElapsed: Double
    let onDismiss: () -> Void
    let onPlayAgain: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Mode: \(mode)")
                .font(.title2)

            Text("Score: \(score)")
                .font(.title2)

            Text("Time: \(formatTime(timeElapsed))")
                .font(.title2)

            Button("Play Again") {
                onPlayAgain()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)

            Button("Back to Main Menu") {
                onDismiss()
                dismiss()
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding()
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
