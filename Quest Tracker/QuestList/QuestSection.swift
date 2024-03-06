//
//  SortedQuestList.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI
import SwiftData

struct QuestSection: View {

    @Environment(\.modelContext) var modelContext    
  @EnvironmentObject var router: Router


    @Query var quests: [Quest]

    var settings: Settings
    var showingCompletedQuests: Bool
    var user: User
    var questType: QuestType

  @State var showingQuestDetails: Bool = false
  @State var questToShowDetails: Quest?

  init(settings: Settings, showingCompletedQuests: Bool, user: User, questType: QuestType, router: Router) {
    _quests = Query(filter: #Predicate { $0.isCompleted == showingCompletedQuests})
      self.settings = settings
      self.showingCompletedQuests = showingCompletedQuests
      self.user = user
    self.questType = questType
    }

  var questsOfChosenType: [Quest] {
    quests.filter({ $0.type == questType }).sorted {$0.questName < $1.questName}
  }

      var body: some View {
        ForEach(questsOfChosenType, id: \.self) { (quest: Quest) in
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
        }
        .sheet(isPresented: $showingQuestDetails) {
          if let questToShowDetails {
            QuestDetailView(router: router, quest: questToShowDetails, settings: settings, user: user)
              .presentationDetents([.medium])
          }
        }
        }
  }
  //
  // #Preview {
  //    QuestList()
  // }
