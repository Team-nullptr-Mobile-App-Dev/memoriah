//  Created by Raidel Almeida on 7/3/24.
//
// MainView.swift
// memoriah

import SwiftUI

struct MainView: View {
	// MARK: Internal

	var body: some View {
		NavigationView {
			VStack {
				Image(.brain2)
					.resizable()
//					.aspectRatio(contentMode: .fill)
					.frame(width: 200, height: 200)
					.padding(.top, 30)
					.phaseAnimator([false, true]) { brain2, chromaRotate in brain2
						.scaleEffect(1, anchor: chromaRotate ? .bottom : .topTrailing)
						.hueRotation(.degrees(chromaRotate ? 400 : 0))
					} animation: { _ in
						.easeInOut(duration: 2)
					}

				Text("memoriah")
					.font(.custom("Futura", size: 50))
					.padding(.bottom, 20)
					.dynamicTypeSize(.xxxLarge)

				Text("Pick a mode")
					.font(.headline)
					.dynamicTypeSize(.xxxLarge)
					.padding(.bottom, 10)

				Text("Flip Card")
					.font(.subheadline)
				GeometryReader { geometry in
					HStack {
						NavigationLink(destination: GameBoardView(mode: .practice)) {
							Text("👶 Practice Mode")
								.font(.title3)
								.frame(maxWidth: .infinity)
						}
						.buttonStyle(GrowingButton())

						NavigationLink(destination: GameBoardView(mode: .timed)) {
							Text("⏰ Timed Mode")
								.font(.title3)
								.frame(maxWidth: .infinity)
						}
						.buttonStyle(GrowingButton())
					}
					.frame(width: geometry.size.width)
				}

				Text("Flashcards")
					.font(.subheadline)
				GeometryReader { geometry in
					HStack {
						NavigationLink(destination: FlashcardCreationView()) {
							Text("🖊️ Create Card")
								.font(.title3)
								.frame(maxWidth: .infinity)
						}
						.buttonStyle(GrowingButton())

						NavigationLink(destination: FlashcardView()) {
							Text("📓 Memorize")
								.font(.title3)
								.frame(maxWidth: .infinity)
						}
						.buttonStyle(GrowingButton())
					}
					.frame(width: geometry.size.width)
				}
				NavigationLink("🤓 Quiz Mode", destination: FlashcardQuizView())
					.font(.title3)
					.buttonStyle(GrowingButton())
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {
						showLeaderboard.toggle()
					}) {
						Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
					}
				}

				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						showProfile.toggle()
					}) {
						Image("custom.person.circle.fill.badge.gearshape.fill")
							.foregroundColor(.accentColor)
					}
				}
			}
			.sheet(isPresented: $showLeaderboard) {
				LeaderboardView()
			}
			.sheet(isPresented: $showProfile) {
				UserProfileView()
			}
		}
	}

	// MARK: Private

	@State private var showLeaderboard = false
	@State private var showProfile = false
}

#Preview {
	MainView()
		.modelContainer(previewContainer)
}
