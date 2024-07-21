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
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Text(selectedAvatar)
                                .font(.system(size: 90))
                                .onTapGesture {
                                    showEmojiPicker = true
                                }

                            Text("Select Avatar")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    TextField("Username", text: $username)
                        .onChange(of: username) {
                            updateUsername(username)
                        }
                }

                Section(header: Text("Statistics")) {
                    Text("Total Games Played: \(currentUser?.gamesPlayed ?? 0)")
                    Text("Best Time: \(formatTime(currentUser?.bestTime ?? 0))")
                }

//                NavigationLink("Settings", destination: SettingsView())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("User Profile")
                        .font(.title)
                        .fontWeight(.bold)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.accentColor)
                    }
                }
            }
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
    @State private var selectedAvatar: String = ""
    @State private var showEmojiPicker = false
    @State private var showSettings = false

    private var currentUser: User? {
        users.first ?? createUser()
    }

    private func loadUserData() {
        username = currentUser?.userName ?? ""
        selectedAvatar = currentUser?.avatar ?? ""
    }

    private func updateUsername(_ newUsername: String) {
        currentUser?.userName = newUsername
    }

    private func createUser() -> User? {
        let newUser = User(avatar: "🎲", bestTime: 0, gamesPlayed: 0, userName: "")
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

    let emojis = ["😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "☺️", "😚", "😙", "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🤫", "🤔", "🤐", "🤨", "😐", "😑", "😶", "😏", "😒", "🙄", "😬", "🤥", "😌", "😔", "😪", "🤤", "😴", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "🥵", "🥶", "🥴", "🤯", "😤", "🤬", "👿", "😈", "💀", "💩", "🤡", "🐵", "🐒", "🦍", "🦧", "🐶", "🐕", "🦮", "🐩", "🐺", "🦊", "🦝", "🐱", "🐈", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄", "🦓", "🦌", "🦬", "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐", "🐪", "🐫", "🦙", "🦒", "🐘", "🦣", "🦏", "🦛", "🐭", "🐁", "🐀", "🐹", "🐰", "🐇", "🐿️", "🦫", "🦔", "🦇", "🐻", "🐨", "🐼", "🦥", "🦦", "🦨", "🦘", "🦡", "🦃", "🐔", "🐓", "🐣", "🐤", "🐥", "🐦", "🐧", "🕊️", "🦅", "🦆", "🦢", "🦉", "🦤", "🦩", "🦚", "🦜", "🐸", "🐊", "🐢", "🦎", "🐍", "🐲", "🐉", "🦕", "🦖", "🐳", "🐋", "🐬", "🦭", "🐟", "🐠", "🐡", "🦈", "🐙", "🐚", "🐌", "🦋", "🐛", "🐜", "🐝", "🪲", "🐞", "🦗", "🪳", "🕷️", "🦂", "🦟", "🪰", "🪱", "🦠"]

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
    }
}
