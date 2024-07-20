//  Created by Raidel Almeida on 7/3/24.
//
// GameBoardView.swift
// memoriah

import SwiftData
import SwiftUI

// MARK: - GameBoardView

struct GameBoardView: View {
    let mode: GameMode
    @State private var cards: [Card] = []
    @State private var timeElapsed: Double = 0
    @State private var score: Int = 0
    @State private var flippedCardIndices: Set<Int> = []
    @State private var isGameOver = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var activeError: GameError?
    @Query private var users: [User]
    
    let emojis = ["🐶", "🐱", "🐭", "🐹", "🐰"]
    
    var body: some View {
        ZStack {
            if !isGameOver {
                VStack {
                    Text(timerText)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            CardView(card: card, isFlipped: flippedCardIndices.contains(index) || card.isMatched) {
                                withAnimation {
                                    flipCard(at: index)
                                }
                            }
                        }
                    }
                }
                .onAppear(perform: setupGame)
                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                    updateTimer()
                }
            } else {
                GameCompletionView(
                    mode: mode == .practice ? "Practice" : "Timed",
                    score: score,
                    timeElapsed: timeElapsed,
                    onDismiss: {
                        saveGameSession()
                        dismiss()
                    },
                    onPlayAgain: {
                        saveGameSession()
                        setupGame()
                    }
                )
            }
        }
        .alert(item: $activeError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var timerText: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func setupGame() {
        cards = emojis.flatMap { [Card(content: $0), Card(content: $0)] }.shuffled()
        timeElapsed = 0
        score = 0
        flippedCardIndices.removeAll()
        isGameOver = false
    }

    private func flipCard(at index: Int) {
        guard !cards[index].isMatched, flippedCardIndices.count < 2 else { return }

        if flippedCardIndices.contains(index) {
            flippedCardIndices.remove(index)
        } else {
            flippedCardIndices.insert(index)
            playHapticFeedback()
            if flippedCardIndices.count == 2 {
                checkForMatch()
            }
        }
    }

    private func playHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    private func checkForMatch() {
        let flippedCards = flippedCardIndices.map { cards[$0] }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if flippedCards[0].content == flippedCards[1].content {
                for index in flippedCardIndices {
                    cards[index].isMatched = true
                }
                score += 2
            }
            flippedCardIndices.removeAll()
            if cards.allSatisfy(\.isMatched) {
                endGame()
            }
        }
    }

    private func updateTimer() {
        if !isGameOver {
            timeElapsed += 1
            if mode == .timed, timeElapsed >= 60 {
                endGame()
            }
        }
    }

    private func endGame() {
        isGameOver = true
        saveGameSession()
    }

    private func saveGameSession() {
        guard let user = fetchOrCreateUser() else {
            handleError(GameError.failedToFetchUser)
            return
        }

        let newSession = GameSession(data: Date(), id: UUID(), mode: mode == .practice ? "Practice" : "Timed", score: Int32(score), timeElapsed: timeElapsed)
        newSession.user = user

        user.gamesPlayed += 1
        if timeElapsed < user.bestTime || user.bestTime == 0 {
            user.bestTime = timeElapsed
        }

        modelContext.insert(newSession)
    }

    private func fetchOrCreateUser() -> User? {
        if let user = users.first {
            return user
        } else {
            let newUser = User(avatar: "😀", bestTime: 0, gamesPlayed: 0, userName: "Player")
            modelContext.insert(newUser)
            return newUser
        }
    }

    private func handleError(_ error: GameError) {
        activeError = error
    }
}

// MARK: - GameMode

enum GameMode {
    case practice, timed
}

// MARK: - GameError

enum GameError: Error, LocalizedError, Identifiable {
    case invalidMove
    case gameOver
    case failedToSaveGame
    case failedToFetchUser

    // MARK: Internal

    var id: String {
        switch self {
        case .invalidMove: "invalidMove"
        case .gameOver: "gameOver"
        case .failedToSaveGame: "failedToSaveGame"
        case .failedToFetchUser: "failedToFetchUser"
        }
    }

    var errorDescription: String? {
        switch self {
        case .failedToSaveGame:
            "Failed to save the game session. Please try again."
        case .failedToFetchUser:
            "Failed to fetch or create user. Please restart the app."
        case .invalidMove:
            "Invalid move."
        case .gameOver:
            "Game over."
        }
    }
}
