//  Created by Raidel Almeida on 7/3/24.
//
//  SettingsView.swift
//  memoriah
//
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingResetAlert = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Form {
            Toggle("Dark Mode", isOn: $isDarkMode)
            
            Button("Reset Scores") {
                showingResetAlert = true
            }
            .alert("Reset Scores", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetScores()
                }
            } message: {
                Text("Are you sure you want to reset all scores? This action cannot be undone.")
            }
            
            Button("Delete All Information") {
                showingDeleteAlert = true
            }
            .alert("Delete All Information", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAllInformation()
                }
            } message: {
                Text("Are you sure you want to delete all information? This action cannot be undone.")
            }
            
            Section(header: Text("App Information")) {
                Text("Version \(appVersion)")
            }
        }
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    private func resetScores() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameSession.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
        } catch {
            print("Failed to reset scores: \(error)")
        }
    }
    
    private func deleteAllInformation() {
        let entities = ["GameSession", "User"] // Add all your entity names here
        
        for entity in entities {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try viewContext.execute(batchDeleteRequest)
            } catch {
                print("Failed to delete \(entity) entities: \(error)")
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context after deleting all information: \(error)")
        }
    }
}