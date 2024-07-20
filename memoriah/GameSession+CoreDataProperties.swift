//
//  GameSession+CoreDataProperties.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/19/24.
//
//

import Foundation
import CoreData


extension GameSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameSession> {
        return NSFetchRequest<GameSession>(entityName: "GameSession")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var score: Int32
    @NSManaged public var timeElapsed: Double
    @NSManaged public var mode: String?
    @NSManaged public var user: User?

}

extension GameSession : Identifiable {

}
