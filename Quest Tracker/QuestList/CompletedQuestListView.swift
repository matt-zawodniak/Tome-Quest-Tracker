//
//  CompletedQuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 3/29/24.
//

import SwiftUI
import SwiftData

struct CompletedQuestListView: View {

  @Environment(\.modelContext) var modelContext

  @ObservedObject private var sections = SectionModel()

  @Query<Quest>(filter: #Predicate { $0.isCompleted == true },
                sort: [SortDescriptor(\Quest.questType,
                                       order: .reverse)])
  var completedQuests: [Quest]

  // Using @Query to keep up to date with Settings and
  // computed var to create a default settings.
  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
    return settingsQueryResults.first ?? Settings.fetchFirstOrCreate(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return userQueryResults.first ?? User.fetchFirstOrCreate(context: modelContext)
  }

  var body: some View {
    List {
      ForEach(QuestType.allCases, id: \.self) { (type: QuestType) in
        let title: String = type.description + "s"

        var numberOfQuestsOfType = completedQuests.filter({ $0.type == type }).count

        Section(header: CategoryHeader(title: title,
                                       model: self.sections,
                                       countOfEntitiesInCategory: numberOfQuestsOfType,
                                       shouldBeExpanded: true)) {
          if self.sections.isExpanded(title: title) {
            CompletedQuestSection(completedQuests: completedQuests, questType: type, settings: settings, user: user)
          } else {
            EmptyView()
          }
        }
        .listRowBackground(CustomListBackground(type: type))
        .listRowSeparator(.hidden)
      }
      .foregroundStyle(.cyan)
    }
    .padding()
    .listStyle(.grouped)
    .listRowSpacing(5)
    .scrollContentBackground(.hidden)
  }
}

#Preview {
    CompletedQuestListView()
    .modelContainer(PreviewSampleData.container)
}
