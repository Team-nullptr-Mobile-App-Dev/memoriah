//  Created by Raidel Almeida on 7/3/24.
//
//  CardView.swift
//  memoriah
//
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

struct CardView: View {
    let card: Card
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            if isFlipped {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 3)
                    .overlay(
                        Text(card.content)
                            .font(.largeTitle)
                    )
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .shadow(radius: 3)
            }
        }
        .frame(width: 80, height: 80)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.default, value: isFlipped)
    }
}
