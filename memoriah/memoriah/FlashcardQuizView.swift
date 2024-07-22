// FlashcardQuizView.swift
import SwiftUI
import SwiftData

struct FlashcardQuizView: View {
    @Query private var flashcards: [Flashcard]
    @State private var currentCardIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var correctAnswers: Int = 0
    @State private var timeRemaining: Int = 60
    @State private var isQuizOver: Bool = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if isQuizOver {
                VStack {
                    Text("Quiz Over")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Correct Answers: \(correctAnswers)")
                        .font(.title)
                        .padding()

                    Text("Score: \(calculateScorePercentage())%")
                        .font(.title)
                        .padding()

                    Button("Back to Main Menu") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            } else {
                Text("Time Remaining: \(timeRemaining) seconds")
                    .font(.headline)
                    .padding(.bottom, 10)

                Text("Question \(currentCardIndex + 1) of \(flashcards.count)")
                    .font(.headline)
                    .padding(.bottom, 10)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 3)
                        .frame(width: 300, height: 200)
                        .overlay(
                            VStack {
                                Text(isFlipped ? "Answer" : "Question")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(isFlipped ? flashcards[currentCardIndex].answer : flashcards[currentCardIndex].question)
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .padding()
                                Spacer()
                            }
                        )
                        .onTapGesture {
                            withAnimation {
                                isFlipped.toggle()
                            }
                        }
                }
                
                HStack {
                    Button("Correct") {
                        correctAnswers += 1
                        nextCard()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                    Spacer()

                    Button("Incorrect") {
                        nextCard()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding()
            }
        }
        .navigationTitle("Flashcard Quiz")
        .onAppear(perform: startTimer)
        .alert(isPresented: $isQuizOver) {
            Alert(
                title: Text("Quiz Over"),
                message: Text("You answered \(correctAnswers) correctly out of \(flashcards.count). Score: \(calculateScorePercentage())%"),
                dismissButton: .default(Text("OK"), action: { dismiss() })
            )
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isQuizOver = true
                timer.invalidate()
            }
        }
    }

    private func nextCard() {
        if currentCardIndex < flashcards.count - 1 {
            currentCardIndex += 1
            isFlipped = false
        } else {
            isQuizOver = true
        }
    }

    private func calculateScorePercentage() -> Int {
        return Int((Double(correctAnswers) / Double(flashcards.count)) * 100)
    }
}

struct FlashcardQuizView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardQuizView()
            .modelContainer(for: [Flashcard.self], inMemory: true)
    }
}
