// FlashcardView.swift
import SwiftUI
import SwiftData

struct FlashcardView: View {
    @Query private var flashcards: [Flashcard]
    @State private var currentCardIndex: Int = 0
    @State private var isFlipped: Bool = false

    var body: some View {
        VStack {
            if !flashcards.isEmpty {
                Text("Flash Card # \(currentCardIndex + 1) of \(flashcards.count)")
                    .font(.headline)
                    .padding(.bottom, 10)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 3)
                        .frame(width: 300, height: 200)
                        .overlay(
                            Text(isFlipped ? flashcards[currentCardIndex].answer : flashcards[currentCardIndex].question)
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding()
                        )
                        .onTapGesture {
                            withAnimation {
                                isFlipped.toggle()
                            }
                        }

                    VStack {
                        Spacer()

                        HStack {
                            Button(action: previousCard) {
                                Text("Previous")
                                    .font(.title2)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .disabled(currentCardIndex == 0)

                            Spacer()

                            Button(action: nextCard) {
                                Text("Next")
                                    .font(.title2)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .disabled(currentCardIndex == flashcards.count - 1)
                        }
                        .padding()
                    }
                }
            } else {
                Text("No flashcards available.")
            }
        }
        .navigationTitle("Study Flashcards")
    }

    private func nextCard() {
        if currentCardIndex < flashcards.count - 1 {
            currentCardIndex += 1
            isFlipped = false
        }
    }

    private func previousCard() {
        if currentCardIndex > 0 {
            currentCardIndex -= 1
            isFlipped = false
        }
    }
}

// MARK: - FlashcardView_Previews

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView()
            .modelContainer(for: [Flashcard.self], inMemory: true)
    }
}
