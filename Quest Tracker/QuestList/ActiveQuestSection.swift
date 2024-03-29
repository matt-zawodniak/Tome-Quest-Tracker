//
//  ActiveQuestSection.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI
import SwiftData

struct ActiveQuestSection: View {

  @Environment(\.modelContext) var modelContext

  var activeQuests: [Quest]
  var questType: QuestType

  var questsOfChosenType: [Quest] {
    activeQuests.filter({ $0.type == questType })
  }

  var settings: Settings
  var user: User

  var body: some View {
    ForEach(questsOfChosenType, id: \.self) { (quest: Quest) in
      QuestRowView(quest: quest)
        .swipeActions(edge: .trailing) {
          Button(role: .destructive) {
            modelContext.delete(quest)
          } label: {
            Label("Delete", systemImage: "trash")
          }

          Button {
            quest.isCompleted = true
          } label: {
            Text("Skip")
          }
        }
        .swipeActions(edge: .leading) {
          Button {
            quest.isCompleted = true

            quest.timeCompleted = Date.now

            user.giveExp(quest: quest, settings: settings, context: modelContext)
          } label: {
            Image(systemName: "checkmark")
          }
          .tint(GlobalUISettings.colorFor(quest: quest))
        }
    }
  }
}
