//  Created by Raidel Almeida on 7/3/24.
//
// UserProfileView.swift
// memoriah

import SwiftUI
import CoreData

struct UserProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)],
        animation: .default
    ) private var users: FetchedResults<User>
    
    @State private var username: String = ""
    @State private var selectedAvatar: String = "😀"
    @State private var showEmojiPicker = false
    
    private var currentUser: User? {
        users.first ?? createUser()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Username", text: $username)
                        .onChange(of: username) { newValue in
                            updateUsername(newValue)
                        }
                    
                    HStack {
                        Text("Avatar")
                        Spacer()
                        Text(selectedAvatar)
                            .font(.system(size: 40))
                            .onTapGesture {
                                showEmojiPicker = true
                            }
                    }
                }
                
                Section(header: Text("Statistics")) {
                    Text("Total Games Played: \(currentUser?.gamesPlayed ?? 0)")
                    Text("Best Time: \(formatTime(currentUser?.bestTime ?? 0))")
                }
                
                NavigationLink("Settings", destination: SettingsView())
            }
            .navigationTitle("User Profile")
            .onAppear(perform: loadUserData)
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $selectedAvatar)
            }
        }
    }
    
    private func loadUserData() {
        username = currentUser?.username ?? ""
        selectedAvatar = currentUser?.avatar ?? "😀"
    }
    
    private func updateUsername(_ newUsername: String) {
        currentUser?.username = newUsername
        saveContext()
    }
    
    private func createUser() -> User? {
        let newUser = User(context: viewContext)
        newUser.username = "Player"
        newUser.avatar = "😀"
        newUser.gamesPlayed = 0
        newUser.bestTime = 0
        
        do {
            try viewContext.save()
            return newUser
        } catch {
            print("Failed to create user: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.presentationMode) var presentationMode
    
    let emojis = ["😀", "😎", "🤓", "🥳", "😺", "🐶", "🦊", "🐸", "🐙", "🦄"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 50))
                            .onTapGesture {
                                selectedEmoji = emoji
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
            .navigationTitle("Select Avatar")
        }
    }
}
