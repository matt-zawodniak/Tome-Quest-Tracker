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

  @Query<Quest>(filter: #Predicate { $0.isCompleted == false })
  var quests: [Quest]

  var settings: Settings
  var user: User

  @State var showingQuestDetails: Bool = false

  var body: some View {
      HStack {
        Text(quest.questName)
        Spacer()
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
}

#Preview {
    QuestRowView(quest: PreviewSampleData.previewQuest,
                 settings: PreviewSampleData.previewSettings,
                 user: PreviewSampleData.previewUser)
    .modelContainer(PreviewSampleData.container)
}
