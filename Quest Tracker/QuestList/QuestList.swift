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
  @ObservedObject private var sections = SectionModel()

  var quests: [Quest]
  var settings: Settings
  var showingCompletedQuests: Bool
  var user: User

    var body: some View {
      List {
        ForEach(QuestType.allCases, id: \.self) { (type: QuestType) in
            let title: String = type.description + "s"
            var numberOfQuestsOfType: Int { quests.filter({ $0.type == type}).count }

            Section(header: CategoryHeader(title: title, model: self.sections, number: numberOfQuestsOfType)) {
              if self.sections.isOpen(title: title) {
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
    }
}

#Preview {
  MainActor.assumeIsolated {
    QuestList(quests: PreviewSampleData.previewQuests, settings: PreviewSampleData.previewSettings,
              showingCompletedQuests: false,
              user: PreviewSampleData.previewUser)
        .modelContainer(PreviewSampleData.container)
  }
}
