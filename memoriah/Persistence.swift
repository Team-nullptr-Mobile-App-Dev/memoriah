//  Created by Raidel Almeida on 7/4/24.
//
//  Persistence.swift
//  memoriah
//
//

import CoreData
import CoreTransferable

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "memoriah")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newSession = GameSession(context: viewContext)
            newSession.date = Date()
            newSession.id = UUID()
            newSession.score = Int32.random(in: 0...100)
            newSession.timeElapsed = Double.random(in: 0...300)
            newSession.mode = "Classic"
            
            let newUser = User(context: viewContext)
            newUser.username = "User\(Int.random(in: 1...1000))"
            newUser.avatar = "default_avatar"
            newUser.gamesPlayed = 1
            newUser.bestTime = newSession.timeElapsed
            newSession.user = newUser
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
