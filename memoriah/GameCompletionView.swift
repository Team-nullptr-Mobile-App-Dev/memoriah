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
	let timeLimit: Double?
	let playerWon: Bool
	let onDismiss: (Bool) -> Void
	let onPlayAgain: () -> Void
	let onNewGame: () -> Void

	var body: some View {
		VStack(spacing: 20) {
			Text(playerWon ? "Congratulations!" : "Game Over!")
				.font(.largeTitle)
				.fontWeight(.bold)

			Text("Mode: \(mode)")
				.font(.title2)

			Text("Score: \(score)")
				.font(.title2)

			Text("Time Elapsed: \(formatTime(timeElapsed))")
				.font(.title2)

			if !playerWon, mode == "Timed" {
				Text("Time Limit: \(formatTime(timeLimit ?? 0))")
					.font(.title2)
			}

			if playerWon {
				Button("Next Round") {
					onPlayAgain()
				}
				.padding()
				.background(Color.blue)
				.foregroundColor(.white)
				.cornerRadius(10)
				.shadow(radius: 5)
			}

			if !playerWon {
				Button("New Game") {
					onNewGame()
				}
				.padding()
				.background(Color.green)
				.foregroundColor(.white)
				.cornerRadius(10)
				.shadow(radius: 5)
			}

			Button("Save and Exit") {
				onDismiss(true)
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

	private var timeText: String {
		if mode == "Timed" {
			"Time Limit: \(formatTime(timeLimit ?? 0))"
		} else {
			"Time Elapsed: \(formatTime(timeElapsed))"
		}
	}

	private func formatTime(_ time: Double) -> String {
		let minutes = Int(time) / 60
		let seconds = Int(time) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}
