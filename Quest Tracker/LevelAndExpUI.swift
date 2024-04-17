//
//  LevelAndExpUI.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/30/23.
//

import SwiftUI
import SwiftData

struct LevelAndExpUI: View {
  @Environment(\.modelContext) var modelContext

  @Query() var users: [User]

  var user: User {
    return users.first ?? User.fetchFirstOrCreate(context: modelContext)
  }

  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack {
          HStack {
            Spacer()

            Text("LVL \(user.level)")

            Spacer(minLength: geometry.size.width * 0.45)

            Text("\(String(format: "%.0f", user.currentExp.rounded()))/ \(String(format: "%.0f", user.expToLevel.rounded()))")

            Spacer()
          }

          ProgressView(value: user.currentExp, total: user.expToLevel)
            .animation(.easeOut(duration: 1), value: user.currentExp)
            .tint(.cyan)
            .frame(maxWidth: geometry.size.width * 0.4)
        }
        .foregroundStyle(.cyan)

        Button("Add 40 EXP") {
          user.giveExp(quest: Quest.defaultQuest(context: modelContext), settings: Settings.defaultSettings, context: modelContext)
        }
      }
    }
  }
}

#Preview {
    LevelAndExpUI()
      .modelContainer(PreviewSampleData.container)
}
