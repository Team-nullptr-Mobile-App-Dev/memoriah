//  Created by Raidel Almeida on 7/3/24.
//
//  UserProfileView.swift
//  memoriah
//
//

import SwiftUI
import CoreData

struct UserProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var username: String = ""
    @State private var selectedAvatar: String = "😀"
    @State private var showEmojiPicker = false
    
    private var currentUser: User? {
        print("Fetching current user")
        let user = users.first ?? createUser()
        print("Current user: \(user?.username ?? "nil")")
        return user
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Username", text: $username)
                        .onChange(of: username) { newValue in
                            print("Username changed to: \(newValue)")
                            updateUsername(newValue)
                        }
                    
                    HStack {
                        Text("Avatar")
                        Spacer()
                        Text(selectedAvatar)
                            .font(.system(size: 40))
                            .onTapGesture {
                                print("Avatar tapped, showing emoji picker")
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
        }
        .onAppear(perform: loadUserData)
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerView(selectedEmoji: $selectedAvatar)
        }
    }
    
    private func loadUserData() {
        print("Loading user data")
        username = currentUser?.username ?? ""
        selectedAvatar = currentUser?.avatar ?? "😀"
        print("Loaded username: \(username), avatar: \(selectedAvatar)")
    }
    
    private func updateUsername(_ newUsername: String) {
        print("Updating username to: \(newUsername)")
        currentUser?.username = newUsername
        saveContext()
    }
    
    private func createUser() -> User? {
        print("Creating new user")
        let newUser = User(context: viewContext)
        newUser.username = "Player"
        newUser.avatar = "😀"
        newUser.gamesPlayed = 0
        newUser.bestTime = 0
        do {
            try viewContext.save()
            print("New user created successfully")
            return newUser
        } catch {
            print("Failed to create user: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        print("Saving context")
        do {
            try viewContext.save()
            print("Context saved successfully")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        print("Formatting time: \(time) to \(formattedTime)")
        return formattedTime
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
                                print("Emoji selected: \(emoji)")
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
