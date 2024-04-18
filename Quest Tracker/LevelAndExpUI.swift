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
                  .phaseAnimator([user.currentExp, user.expToLevel, 0], trigger: user.currentExp) { capsule, phase in
                    capsule
                      .frame(width: geometry.size.width * 0.4 * expBarLength / user.expToLevel)
                      .onChange(of: phase) {
                        switch phase {
                        case user.currentExp:
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if expBarLength != user.currentExp {
                              expBarLength = user.currentExp
                            }
                          }
                        case user.expToLevel:
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if expBarLength > user.currentExp {
                              expBarLength = user.expToLevel
                            } else {
                              expBarLength = user.currentExp
                            }
                          }
                        case 0:
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if expBarLength > user.currentExp {
                              expBarLength = 0
                            }
                          }
                        default: print("default")
                        }
                      }
                  } animation: { _ in
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
