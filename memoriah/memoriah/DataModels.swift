//
//  DataModels.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/20/24.
//

import Foundation
import SwiftData

// MARK: - GameSession

@Model
final class GameSession {
    // MARK: Lifecycle

    init(data: Date, id: UUID, mode: String, score: Int32, timeElapsed: Double) {
        self.data = data
        self.id = id
        self.mode = mode
        self.score = score
        self.timeElapsed = timeElapsed
    }

    // MARK: Internal

    var data: Date
    var id: UUID
    var mode: String
    var score: Int32
    var timeElapsed: Double
    @Relationship(inverse: \User.gameSessions)
    var user: User?
}

// MARK: - User

@Model
final class User {
    // MARK: Lifecycle

    init(avatar: String, bestTime: Double, gamesPlayed: Int32, userName: String) {
        self.avatar = avatar
        self.bestTime = bestTime
        self.gamesPlayed = gamesPlayed
        self.userName = userName
    }

    // MARK: Internal

    var avatar: String
    var bestTime: Double
    var gamesPlayed: Int32
    var userName: String
    var gameSessions: [GameSession] = []
}
