//
//  User+CoreDataProperties.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/19/24.
//
//


import Foundation
import CoreData

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var username: String?
    @NSManaged public var avatar: String?
    @NSManaged public var gamesPlayed: Int32
    @NSManaged public var bestTime: Double
    @NSManaged public var gameSessions: NSSet?
}

    // MARK: Generated accessors for gameSessions
extension User {
    @objc(addGameSessionsObject:)
    @NSManaged public func addToGameSessions(_ value: GameSession)
    
    @objc(removeGameSessionsObject:)
    @NSManaged public func removeFromGameSessions(_ value: GameSession)
    
    @objc(addGameSessions:)
    @NSManaged public func addToGameSessions(_ values: NSSet)
    
    @objc(removeGameSessions:)
    @NSManaged public func removeFromGameSessions(_ values: NSSet)
}

extension User : Identifiable {
}
