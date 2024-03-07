//
//  QuestList.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/23/24.
//

import SwiftUI
import SwiftData

struct QuestList: View {
  @Environment(\.modelContext) var modelContext

  @Query var quests: [Quest]

  var settings: Settings
  var showingCompletedQuests: Bool
  var user: User

  init(sortDescriptor: SortDescriptor<Quest>, settings: Settings, showingCompletedQuests: Bool, user: User) {
    _quests = Query(filter: #Predicate { $0.isCompleted == showingCompletedQuests},
                    sort: [sortDescriptor])
    self.settings = settings
    self.showingCompletedQuests = showingCompletedQuests
    self.user = user
  }

    var body: some View {
      ForEach(quests, id: \.self) { (quest: Quest) in
        QuestRowView(quest: quest, settings: settings, user: user)
        .swipeActions(edge: .trailing) { Button(role: .destructive) {
          modelContext.delete(quest)
        } label: {
          Label("Delete", systemImage: "trash")
        }
          if !showingCompletedQuests {
            NavigationLink(destination: QuestView(
              quest: quest, hasDueDate: quest.dueDate.exists, settings: settings)) {
                Button(action: {
                }, label: {
                  Text("Edit")
                }
                )
              }
          }
        }
        .swipeActions(edge: .leading) {
          if !showingCompletedQuests {
            Button {
              quest.isCompleted = true
              user.giveExp(quest: quest, settings: settings, context: modelContext)
              quest.timeCompleted = Date.now
            } label: {
              Image(systemName: "checkmark")
            }
            .tint(GlobalUISettings.colorFor(quest: quest))
          }
        }
      }    }
}

#Preview {
  MainActor.assumeIsolated {
    QuestList(sortDescriptor: QuestTrackerViewModel().sortDescriptorFromSortType(sortType: .questType),
              settings: PreviewSampleData.previewSettings,
              showingCompletedQuests: false,
              user: PreviewSampleData.previewUser)
        .modelContainer(PreviewSampleData.container)
  }
}
