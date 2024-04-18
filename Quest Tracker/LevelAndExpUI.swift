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

  @State var expBarLength: Double

  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack {
          HStack {
            Spacer()

            Text("LVL \(user.level)")
              .frame(minWidth: geometry.size.width * 0.15)

            Spacer(minLength: geometry.size.width * 0.45)

            Text("\(String(format: "%.0f", user.currentExp.rounded()))/ \(String(format: "%.0f", user.expToLevel.rounded()))")
              .frame(minWidth: geometry.size.width * 0.15)

            Spacer()
          }

          Capsule()
            .frame(width: geometry.size.width * 0.4, height: 5)
            .opacity(0.1)
            .overlay(
              HStack {
                Capsule()
                  .phaseAnimator([0, 1, 2], trigger: user.currentExp) { bar, phase in
                    switch phase {
                    case 0: bar.frame(width: geometry.size.width * 0.4 * user.currentExp / user.expToLevel)
                    case 1: bar.frame(width: geometry.size.width * 0.4)
                    case 2: bar.frame(width: 0)
                    default:
                      bar.frame(width: user.currentExp)
                    }
                  } animation: { phase in
                    .easeInOut(duration: 1)
                  }

                Spacer()
              }
            )

//          ProgressView(value: user.currentExp, total: user.expToLevel)
//            .animation(.easeOut(duration: 1), value: user.currentExp)
//            .tint(.cyan)
//            .frame(maxWidth: geometry.size.width * 0.4)
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
  LevelAndExpUI(expBarLength: 27)
      .modelContainer(PreviewSampleData.container)
}
