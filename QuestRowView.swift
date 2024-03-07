//
//  QuestRowView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/27/23.
//

import SwiftData
import SwiftUI

struct QuestRowView: View, Identifiable {

  @Environment(\.modelContext) var modelContext

  var id = UUID()

  @State var quest: Quest
  @Query<Quest>(filter: #Predicate { $0.isCompleted == false }) var quests: [Quest]

  var settings: Settings
  var user: User

  @State var showingQuestDetails: Bool = false

  var body: some View {
    VStack {
      HStack {
        //        switch quest.type {
        //        case .mainQuest: Text("!").foregroundStyle(.red)
        //        case .sideQuest: Text("!").foregroundStyle(.yellow)
        //        case .dailyQuest: Text("!").foregroundStyle(.green)
        //        case .weeklyQuest: Text("!").foregroundStyle(.purple)
        //        }
        Text(quest.questName)
        Spacer()
      }

      if quest.isSelected {
        Text(quest.questDescription ?? "")
        Text("Quest EXP: \(Int(quest.type.experience))")
        if quest.questBonusReward != nil {
          HStack {
            Text("Quest Reward:")
            Text(quest.questBonusReward ?? "")
          }
        }
        if !quest.isCompleted {
          if quest.type == .weeklyQuest ||
              quest.type == .dailyQuest {
            Button {
              quest.timeCompleted = Date()
              quest.isCompleted = true
            } label: {
              Text("Skip Quest").foregroundStyle(.orange)
            }
          }
        } else {
          Button {
            restoreQuest(quest: quest)
          } label: {
            Text("Restore to Quest List")
          }
          }
        }
      }
    .contentShape(Rectangle())
    .onTapGesture {
        showingQuestDetails.toggle()
    }
    .sheet(isPresented: $showingQuestDetails) {
      QuestDetailView(quest: quest, settings: settings, user: user)
        .presentationDetents([.medium, .large])
    }
  }
  func restoreQuest(quest: Quest) {
    quest.isCompleted = false
    quest.isSelected = false
    quest.timeCreated = Date.now
    print("\(quest.questName) is \(quest.isCompleted)")
  }
  func toggleQuest(quest: Quest, quests: [Quest]) {
      quest.isSelected.toggle()
      for other in quests where other != quest {
        other.isSelected = false
      }
    }
}
#Preview {
  MainActor.assumeIsolated {
    QuestRowView(quest: PreviewSampleData.previewQuest, settings: PreviewSampleData.previewSettings)
      .modelContainer(PreviewSampleData.container)
  }
}
