//  Created by Raidel Almeida on 7/3/24.
//
// UserProfileView.swift
// memoriah

import SwiftData
import SwiftUI

// MARK: - UserProfileView

struct UserProfileView: View {
    // MARK: Internal

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Username", text: $username)
                        .onChange(of: username) { newUsername in
                            updateUsername(newUsername)
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

    // MARK: Private

    @Query private var users: [User]
    @Environment(\.modelContext) private var modelContext
    @State private var username: String = ""
    @State private var selectedAvatar: String = "😀"
    @State private var showEmojiPicker = false

    private var currentUser: User? {
        users.first ?? createUser()
    }

    private func loadUserData() {
        username = currentUser?.userName ?? ""
        selectedAvatar = currentUser?.avatar ?? "😀"
    }

    private func updateUsername(_ newUsername: String) {
        currentUser?.userName = newUsername
    }

    private func createUser() -> User? {
        let newUser = User(avatar: "😀", bestTime: 0, gamesPlayed: 0, userName: "Player")
        modelContext.insert(newUser)
        return newUser
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - EmojiPickerView

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) var dismiss

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
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle("Select Avatar")
        }
    }
}

// MARK: - UserProfileView_Previews

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .modelContainer(for: [User.self], inMemory: true)
    }
}
