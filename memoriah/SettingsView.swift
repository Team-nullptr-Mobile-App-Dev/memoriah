//  Created by Raidel Almeida on 7/3/24.
//
// SettingsView.swift
// memoriah

import SwiftData
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
	// MARK: Internal

	var body: some View {
		Form {
			Section(header: Text("Appearance")) {
				HStack {
					//                    Spacer()
					Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
						.foregroundColor(isDarkMode ? .yellow : .orange)
					Toggle(isDarkMode ? "Dark Mode" : "Light Mode", isOn: $isDarkMode)
				}
			}

			Section(header: Text("Data Management")) {
				Button("Reset Scores") {
					showingResetAlert = true
				}
				.foregroundColor(.red)

				Button("Delete All Information") {
					showingDeleteAlert = true
				}
				.foregroundColor(.red)
			}

			Section(header: Text("App Information")) {
				Text("Version \(appVersion)")
			}
		}
		.navigationTitle("Settings")
		.preferredColorScheme(isDarkMode ? .dark : .light)
		.alert("Reset Scores", isPresented: $showingResetAlert) {
			Button("Cancel", role: .cancel) {}
			Button("Reset", role: .destructive) {
				resetScores()
			}
		} message: {
			Text("Are you sure you want to reset all scores? This action cannot be undone.")
		}
		.alert("Delete All Information", isPresented: $showingDeleteAlert) {
			Button("Cancel", role: .cancel) {}
			Button("Delete", role: .destructive) {
				deleteAllInformation()
			}
		} message: {
			Text("Are you sure you want to delete all information? This action cannot be undone.")
		}
	}

	// MARK: Private

	@AppStorage("isDarkMode") private var isDarkMode = false
	@Environment(\.modelContext) private var modelContext
	@State private var showingResetAlert = false
	@State private var showingDeleteAlert = false
	@Binding var refreshTrigger: Bool

	private var appVersion: String {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
	}

	private func resetScores() {
		do {
			let gameSessionsFetchDescriptor = FetchDescriptor<GameSession>()
			let gameSessions = try modelContext.fetch(gameSessionsFetchDescriptor)

			for gameSession in gameSessions {
				gameSession.user = nil
				modelContext.delete(gameSession)
			}

			// Reset User statistics
			let usersFetchDescriptor = FetchDescriptor<User>()
			let users = try modelContext.fetch(usersFetchDescriptor)

			for user in users {
				user.gamesPlayed = 0
				user.bestTime = 0
			}

			try modelContext.save()
			print("Scores reset successfully")
		} catch {
			print("Failed to reset scores: \(error)")
		}
	}

	private func deleteAllInformation() {
		do {
			// First, delete all GameSessions
			let gameSessionsFetchDescriptor = FetchDescriptor<GameSession>()
			let gameSessions = try modelContext.fetch(gameSessionsFetchDescriptor)

			for gameSession in gameSessions {
				gameSession.user = nil
				modelContext.delete(gameSession)
			}

			// Then, delete all Users
			let usersFetchDescriptor = FetchDescriptor<User>()
			let users = try modelContext.fetch(usersFetchDescriptor)

			for user in users {
				modelContext.delete(user)
			}

			try modelContext.save()
			print("All information deleted successfully")
		} catch {
			print("Failed to delete all information: \(error)")
		}
	}
}

// MARK: - SettingsView_Previews

//struct SettingsView_Previews: PreviewProvider {
//	static var previews: some View {
//		SettingsView()
//	}
//}
