//
//  FlashcardCreationView.swift
//  memoriah
//
//  Created by Nkosi on 7/21/24.
//

import SwiftUI
import SwiftData

struct FlashcardCreationView: View {
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Question")) {
                    TextField("Enter question", text: $question)
                }
                
                Section(header: Text("Answer"))
                {
                    TextField("Enter Response", text: $answer)
                    
                }
                Button("Save Flashcard"){
                    saveFlashcard()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .navigationTitle("Create Flashcard")
            .alert(isPresented: $showingSaveAlert) {
                Alert(title: Text("Saved"), message: Text("Flashcard saved!"), dismissButton: .default(Text("OK")))
            }
            
        }
        
    }
    
    @Environment(\.modelContext) private var modelContext
    @State private var question:String = ""
    @State private var answer: String = ""
    @State private var showingSaveAlert = false
    
    private func saveFlashcard(){
        let newFlashcard = Flashcard(question: question, answer: answer)
        modelContext.insert(newFlashcard)
        showingSaveAlert = true
    }
}

struct FlashcardCreationView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardCreationView()
            .modelContainer(for: [Flashcard.self], inMemory: true)
    }
}
