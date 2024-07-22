//
//  Flashcard.swift
//  memoriah
//
//  Created by Nkosi on 7/21/24.
//
import SwiftData
import SwiftUI
@Model
final class Flashcard {
    
    init(id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    var id: UUID
    var question: String
    var answer: String
}
