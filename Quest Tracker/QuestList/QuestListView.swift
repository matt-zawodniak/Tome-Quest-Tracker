//
//  QuestList.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/23/24.
//

import SwiftUI
import SwiftData

struct QuestListView: View {

  @Environment(\.modelContext) var modelContext

  @Environment(\.scenePhase) var scenePhase

  @ObservedObject var tracker = QuestTrackerViewModel()

  @ObservedObject private var sections = SectionModel()

  @Query<Quest>(sort: [SortDescriptor(\Quest.questType, order: .reverse)]) var quests: [Quest]

  var filteredQuests: [Quest] {
    if showingCompletedQuests {
      return quests.filter({ $0.isCompleted == true})
    } else {
      return quests.filter({ $0.isCompleted == false})
    }
  }

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

  var showingCompletedQuests: Bool

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    List {
      ForEach(QuestType.allCases, id: \.self) { (type: QuestType) in
        let title: String = type.description + "s"

        var numberOfQuestsOfType: Int {
          quests.filter({
            $0.type == type &&
            $0.isCompleted == showingCompletedQuests })
          .count
        }

        Section(header: CategoryHeader(title: title,
                                       model: self.sections,
                                       countOfEntitiesInCategory: numberOfQuestsOfType,
                                       shouldBeExpanded: true)) {
          if self.sections.isExpanded(title: title) {
            QuestSection(settings: settings,
                         showingCompletedQuests: showingCompletedQuests,
                         user: user,
                         questType: type)
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
    .onReceive(timer, perform: { time in
      if time >= settings.time {
        tracker.refreshSettingsAndQuests(settings: settings, context: modelContext)
      }
    })
    .onChange(of: scenePhase) {
      if scenePhase == .active {
        if Date.now >= settings.time {
          tracker.refreshSettingsAndQuests(settings: settings, context: modelContext)
        }
      }
    }
  }
}

#Preview {
    QuestListView(tracker: QuestTrackerViewModel(), showingCompletedQuests: false)
      .modelContainer(PreviewSampleData.container)
}
