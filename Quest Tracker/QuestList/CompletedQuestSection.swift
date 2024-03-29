//
//  CompletedQuestSection.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 3/29/24.
//

import SwiftUI

struct CompletedQuestSection: View {

  @Environment(\.modelContext) var modelContext

  var completedQuests: [Quest]
  var questType: QuestType

  var questsOfChosenType: [Quest] {
    completedQuests.filter({ $0.type == questType })
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
        }
        .swipeActions(edge: .leading) {
          Button {
            quest.isCompleted = false

            quest.timeCreated = Date.now
          } label: {
            Label("Restore to Quest List", systemImage: "arrow.counterclockwise")
          }
          .tint(GlobalUISettings.colorFor(quest: quest))
        }
    }
  }
}
