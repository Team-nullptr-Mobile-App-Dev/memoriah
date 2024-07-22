//  Created by Raidel Almeida on 7/3/24.
//
// LeaderboardView.swift
// memoriah

import SwiftData
import SwiftUI

// MARK: - LeaderboardView

struct LeaderboardView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Picker("Time Frame", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                    Text(timeFrame.rawValue).tag(timeFrame)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
//            .padding(.top, 60)

            List {
                ForEach(Array(filteredSessions.enumerated()), id: \.element.id) { index, session in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                            .frame(width: 15)
                        Text(session.user?.userName ?? "Unknown")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Score: \(session.score)")
                            Text("Time: \(String(format: "%.2f", session.timeElapsed))")
                                .font(.caption)
                            Text(formatDate(session.data))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
//        .navigationTitle("Leaderboard")
    }

    // MARK: Private

    @Query(sort: \GameSession.score, order: .reverse, animation: .default) private var gameSessions: [GameSession]
    @State private var selectedTimeFrame: TimeFrame = .today

    private var filteredSessions: [GameSession] {
        let calendar = Calendar.current
        let now = Date()

        return gameSessions.filter { session in
            switch selectedTimeFrame {
            case .today:
                return calendar.isDateInToday(session.data)
            case .thisWeek:
                let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                return session.data >= weekAgo && session.data <= now
            case .allTime:
                return true
            }
        }
//        .sorted { $0.score > $1.score }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - TimeFrame

enum TimeFrame: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case allTime = "All Time"
}

#Preview {
    LeaderboardView()
        .modelContainer(previewContainer)
}
