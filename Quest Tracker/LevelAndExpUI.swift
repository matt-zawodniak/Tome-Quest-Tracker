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

              Spacer()
            }
          )
      }
      .foregroundStyle(.cyan)
      .onChange(of: user.currentExp) {
        if user.isLevelingUp {
          withAnimation(.easeInOut(duration: 0.5)) {
              expBarLength = user.expToLevel
          } completion: {
              expBarLength = 0
              if user.levelingScheme == 1 {
                user.expToLevel += 20
              }
            withAnimation(.easeInOut(duration: 0.5)) {
                expBarLength = user.currentExp
              } completion: {
                user.isLevelingUp = false
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
