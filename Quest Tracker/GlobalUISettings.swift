//
//  GlobalUISettings.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/27/24.
//

import SwiftUI

struct GlobalUISettings {
  static var background: some View {
    Image("Background")
      .resizable()
      .opacity(0.2)
      .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .black, .clear, .clear]),
                           startPoint: .top,
                           endPoint: .bottom))
      .ignoresSafeArea(.all)
  }

  static func colorFor(quest: Quest) -> Color {
    switch quest.type {
    case .mainQuest: return .red.opacity(0.8)
    case .sideQuest: return .yellow.opacity(0.8)
    case .dailyQuest: return .green.opacity(0.8)
    case .weeklyQuest: return .purple.opacity(0.8)
    }
  }
}
