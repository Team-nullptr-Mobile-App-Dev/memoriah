//
//  memoriahTests.swift
//  memoriahTests
//
//  Created by Raidel Almeida on 7/3/24.
//

import CoreData
import XCTest
@testable import memoriah

class CoreDataTests: XCTestCase {
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: "memoriah")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
    }

    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }

    func testCreateUser() {
        let user = User(context: context)
        user.username = "TestUser"
        user.avatar = "😀"
        user.gamesPlayed = 0
        user.bestTime = 100.0

        XCTAssertNoThrow(try context.save())

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let fetchedUsers = try? context.fetch(fetchRequest)
        XCTAssertEqual(fetchedUsers?.count, 1)
        XCTAssertEqual(fetchedUsers?.first?.username, "TestUser")
    }

    func testCreateGameSession() {
        let user = User(context: context)
        user.username = "TestUser"

        let gameSession = GameSession(context: context)
        gameSession.id = UUID()
        gameSession.date = Date()
        gameSession.score = 100
        gameSession.timeElapsed = 60.0
        gameSession.mode = "Practice"
        gameSession.user = user

        XCTAssertNoThrow(try context.save())

        let fetchRequest: NSFetchRequest<GameSession> = GameSession.fetchRequest()
        let fetchedSessions = try? context.fetch(fetchRequest)
        XCTAssertEqual(fetchedSessions?.count, 1)
        XCTAssertEqual(fetchedSessions?.first?.score, 100)
        XCTAssertEqual(fetchedSessions?.first?.user?.username, "TestUser")
    }

    func testUserGameSessionRelationship() {
        let user = User(context: context)
        user.username = "TestUser"

        let gameSession1 = GameSession(context: context)
        gameSession1.id = UUID()
        gameSession1.score = 100
        gameSession1.user = user

        let gameSession2 = GameSession(context: context)
        gameSession2.id = UUID()
        gameSession2.score = 200
        gameSession2.user = user

        XCTAssertNoThrow(try context.save())

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let fetchedUsers = try? context.fetch(fetchRequest)
        XCTAssertEqual(fetchedUsers?.first?.gameSessions?.count, 2)
    }
}
