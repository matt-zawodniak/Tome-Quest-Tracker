//
//  QuestDetailView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/28/24.
//

import SwiftUI

struct QuestDetailView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss

  @State var quest: Quest
  @State var settings: Settings
  @State var user: User

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
        if quest.isCompleted == false {
          if quest.type == .dailyQuest || quest.type == .weeklyQuest {
            List {
              HStack {
                Spacer()
                Text("Delete")
                Spacer()
              }
              .onTapGesture {
                modelContext.delete(quest)
                dismiss()
              }
              HStack {
                Spacer()
                Text("Edit")
                Spacer()
              }
              .onTapGesture {
                dismiss()
              }
              HStack {
                Spacer()
                Text("Skip")
                Spacer()
              }
              .onTapGesture {
                quest.timeCompleted = Date()
                quest.isCompleted = true
                dismiss()
              }
              HStack {
                Spacer()
                Text("Complete")
                Spacer()
              }
              .onTapGesture {
                quest.isCompleted = true
                user.giveExp(quest: quest, settings: settings, context: modelContext)
                quest.timeCompleted = Date.now
                dismiss()
              }
            }
            .listStyle(.grouped)
            .listRowSpacing(5)
            .scrollContentBackground(.hidden)
            .listRowBackground(Color.black)
          } else {
            List {
              HStack {
                Spacer()
                Text("Delete")
                Spacer()
              }
              .onTapGesture {
                modelContext.delete(quest)
                dismiss()
              }
              HStack {
                Spacer()
                Text("Edit")
                Spacer()
              }
              .onTapGesture {
                dismiss()
              }
              HStack {
                Spacer()
                Text("Complete")
                Spacer()
              }
              .onTapGesture {
                quest.isCompleted = true
                user.giveExp(quest: quest, settings: settings, context: modelContext)
                quest.timeCompleted = Date.now
                dismiss()
              }
            }
            .listStyle(.grouped)
            .listRowSpacing(5)
            .scrollContentBackground(.hidden)
            .listRowBackground(Color.black)
          }
        } else {
          List {
            HStack {
              Spacer()
              Text("Edit")
              Spacer()
            }
            HStack {
              Spacer()
              Text("Restore to Active Quests")
              Spacer()
            }
            .onTapGesture {
              quest.isCompleted = false
              dismiss()
            }
          }
          .listStyle(.grouped)
          .listRowSpacing(5)
          .scrollContentBackground(.hidden)
          .listRowBackground(Color.black)
        }
      }
      .foregroundStyle(.white)
    }
  }
}

// #Preview {
//  QuestDetailView(quest: Quest(difficulty: 1,
//                               id: UUID(),
//                               isCompleted: false,
//                               isSelected: true,
//                               length: 2,
//                               questBonusExp: 20,
//                               questName: "Test",
//                               questType: 3))
// }
