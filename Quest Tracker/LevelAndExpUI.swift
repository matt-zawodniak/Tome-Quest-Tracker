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
  @State var isLevelingUp: Bool = false

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        HStack {
          Spacer()

          Text("LVL \(user.level)")
            .frame(minWidth: geometry.size.width * 0.15)

          Spacer(minLength: geometry.size.width * 0.45)

          Text("\(String(format: "%.0f/ %.0f", user.currentExp.rounded(), user.expToLevel.rounded()))")
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

              Spacer()
            }
          )
      }
      .foregroundStyle(.cyan)
      .onChange(of: user.level) {
        isLevelingUp = true
      }
      .onChange(of: user.expToLevel) {
        if isLevelingUp {
          withAnimation(.easeInOut(duration: 0.5)) {
            expBarLength = geometry.size.width * 0.4
          } completion: {
              expBarLength = 0

            withAnimation(.easeInOut(duration: 0.5)) {
                expBarLength = user.currentExp
              } completion: {
                isLevelingUp = false
              }
          }
        } else {
          withAnimation(.easeInOut(duration: 1)) {
            expBarLength = user.currentExp
          }
        }
      }
    }
  }
}

#Preview {
  LevelAndExpUI(expBarLength: 27)
      .modelContainer(PreviewSampleData.container)
}
