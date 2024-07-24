//
//  GrowingButton.swift
//  memoriah
//
//  Created by Raidel Almeida on 7/21/24.
//

import Foundation
import SwiftUI

struct GrowingButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(Color.accentColor)
//			.foregroundStyle(.white)
			.clipShape(Capsule())
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
