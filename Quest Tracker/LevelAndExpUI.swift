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

  @State var expBarLength: Double = 27

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
                  .frame(width: geometry.size.width * 0.4 * expBarLength / user.expToLevel)
//                  .animation(.easeOut, value: user.currentExp)

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
      .onChange(of: user.currentExp) {
        if user.isLevelingUp {
          withAnimation(.easeIn(duration: 0.25)) {
            expBarLength = geometry.size.width * 0.4
          } completion: {
            withAnimation(.easeInOut(duration: 0.5)) {
              expBarLength = 0
            } completion: {
              withAnimation(.easeOut(duration: 0.25)) {
                expBarLength = user.currentExp
              } completion: {
                user.isLevelingUp = false
              }
            }
          }
        } else {
          withAnimation(.easeInOut(duration: 0.5)) {
            expBarLength = user.currentExp
          }
        }
      }
    }
  }
}

#Preview {
  LevelAndExpUI()
      .modelContainer(PreviewSampleData.container)
}
