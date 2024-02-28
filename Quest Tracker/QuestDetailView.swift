//
//  QuestDetailView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/28/24.
//

import SwiftUI

struct QuestDetailView: View {
  @State var quest: Quest

  var body: some View {
    ZStack {
      Rectangle().fill(GlobalUISettings.colorFor(quest: quest).opacity(0.8))
      VStack {
        VStack(spacing: 20) {
          Spacer()
          Text(quest.questName).font(.largeTitle).foregroundStyle(.white)

          if let description = quest.questDescription {
            Text(description)

          } else {
            EmptyView()
          }

          Spacer()

          Text("Rewards").font(.headline)
          Text(" \(Int(quest.type.experience + quest.questBonusExp)) EXP")

          if let bonus = quest.questBonusReward {
            Text("Bonus Reward: \(bonus)")
          }
          Spacer()
        }
        List {
          HStack {
            Spacer()
            Text("Delete")
            Spacer()
          }
          HStack {
            Spacer()
            Text("Edit")
            Spacer()
          }
          HStack {
            Spacer()
            Text("Complete")
            Spacer()
          }
        }
        .listStyle(.grouped)
        .listRowSpacing(5)
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.black)
      }
      .foregroundStyle(.white)
    }
  }
}

#Preview {
  QuestDetailView(quest: Quest(difficulty: 1,
                               id: UUID(),
                               isCompleted: false,
                               isSelected: true,
                               length: 2,
                               questBonusExp: 20,
                               questName: "Test",
                               questType: 3))
}
