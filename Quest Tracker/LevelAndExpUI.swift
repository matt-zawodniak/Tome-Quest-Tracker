//
//  LevelAndExpUI.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/30/23.
//

import SwiftUI

struct LevelAndExpUI: View {
  @State var level: Int = 3
  @State var experience: Double = 27
  @State var experienceToLevelUp: Double = 40

  var body: some View {
    HStack {
      Text("LVL \(level)")
      ProgressView(value: experience, total: experienceToLevelUp)
      Text("\(String(format: "%.0f", experience.rounded())) / \(String(format: "%.0f", experienceToLevelUp.rounded()))")
    }
  }
}

#Preview {
    LevelAndExpUI()
}
