//  Created by Raidel Almeida on 7/3/24.
//
//  CardView.swift
//  memoriah
//
//

import SwiftUI

// MARK: - CardView

struct CardView: View {
	let card: Card
	let isFlipped: Bool
	let onTap: () -> Void

	var body: some View {
		ZStack {
			if isFlipped {
				Image(card.content) // Display the image when flipped
					.resizable()
					.scaledToFit()
					.cornerRadius(10)
					.shadow(radius: 3)
			} else {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.accentColor)
					.shadow(radius: 3)
			}
		}
		.frame(width: 80, height: 80)
		.rotation3DEffect(
			.degrees(isFlipped ? 180 : 0),
			axis: (x: 0, y: 1, z: 0)
		)
		.animation(.default, value: isFlipped)
		.onTapGesture {
			onTap()
		}
	}
}

// MARK: - Card

struct Card: Identifiable {
	let id = UUID()
	let content: String
	var isFaceUp = false
	var isMatched = false
}
