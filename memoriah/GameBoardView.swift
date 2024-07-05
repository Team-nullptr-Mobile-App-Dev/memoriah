//  Created by Raidel Almeida on 7/3/24.
//
//  GameBoardView.swift
//  memoriah
//
//

import SwiftUI
import CoreData

struct GameBoardView: View {


    let mode: GameMode
    @State private var cards: [Card] = []
    @State private var timeElapsed: Double = 0
    @State private var score: Int = 0
    @State private var flippedCardIndices: Set<Int> = []
    @State private var isGameOver = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var activeError: GameError?

    let emojis = ["🐶", "🐱", "🐭", "🐹", "🐰"]

    var body: some View {
        VStack {
            Text(timerText)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card, isFlipped: flippedCardIndices.contains(index) || card.isMatched)
                        .onTapGesture {
                        withAnimation {
                            flipCard(at: index)
                        }
                    }
                }
            }
        }
            .onAppear(perform: setupGame)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if !isGameOver {
                timeElapsed += 1
                if mode == .timed && timeElapsed >= 60 {
                    endGame()
                }
            }
        }
            .sheet(isPresented: $isGameOver) {
            GameCompletionView(mode: mode, score: score, timeElapsed: timeElapsed) {
                isGameOver = false
                setupGame()
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
        cards = []
        for emoji in emojis {
            cards.append(Card(content: emoji))
            cards.append(Card(content: emoji))
        }
        cards.shuffle()
        timeElapsed = 0
        score = 0
        flippedCardIndices.removeAll()
    }

    private func flipCard(at index: Int) {
        guard !cards[index].isMatched && flippedCardIndices.count < 2 else { return }

        if flippedCardIndices.contains(index) {
            flippedCardIndices.remove(index)
        } else {
            flippedCardIndices.insert(index)
            if flippedCardIndices.count == 2 {
                checkForMatch()
            }
        }
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

            if cards.allSatisfy({ $0.isMatched }) {
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

        let newSession = GameSession(context: viewContext)
        newSession.score = Int32(score)
        newSession.timeElapsed = timeElapsed
        newSession.user = user
        newSession.mode = mode == .practice ? "Practice" : "Timed"
        newSession.date = Date()
        newSession.id = UUID()

        user.gamesPlayed += 1
        if timeElapsed < user.bestTime || user.bestTime == 0 {
            user.bestTime = timeElapsed
        }

        do {
            try viewContext.save()
            print("Game session saved successfully!")
        } catch {
            handleError(GameError.failedToSaveGame)

            let nsError = error as NSError
            print("Error saving game session: \(nsError), \(nsError.userInfo)")
            print("Error saving game session: \(error.localizedDescription)")
        }
    }

    private func fetchOrCreateUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                return user
            } else {
                let newUser = User(context: viewContext)
                newUser.username = "Player"
                newUser.avatar = "😀"
                newUser.gamesPlayed = 0
                newUser.bestTime = 0
                return newUser
            }
        } catch {
            handleError(GameError.failedToFetchUser)

            print("Error fetching user: \(error)")
            return nil
        }
    }

    private func handleError(_ error: GameError) {
        activeError = error
    }
    
    enum GameMode {
        case practice, timed
    }
    
    enum GameError: Error, LocalizedError, Identifiable {
        case invalidMove
        case gameOver
        case failedToSaveGame
        case failedToFetchUser
        
        var id: String {
            switch self {
                case .invalidMove:
                    return "invalidMove"
                case .gameOver:
                    return "gameOver"
                case .failedToSaveGame:
                    return "Failed to save the game session. Please try again."
                case .failedToFetchUser:
                    return "Failed to fetch or create user. Please restart the app."

            }
        }
        
//        var errorDescription: String? {
//            switch self {
//                case .failedToSaveGame:
//                    return "Failed to save the game session. Please try again."
//                case .failedToFetchUser:
//                    return "Failed to fetch or create user. Please restart the app."
//            }
//        }
    }

}


