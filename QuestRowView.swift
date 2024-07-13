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
  @EnvironmentObject var tracker: QuestListViewModel

  var id = UUID()

  @State var quest: Quest

  var body: some View {
      HStack {
        Text(quest.questName)
        Spacer()
      }
    .contentShape(Rectangle())
    .onTapGesture {
      tracker.questToShowDetails = quest
      tracker.showingQuestDetails = true
    }
  }
}

#Preview {
  QuestRowView(quest: PreviewSampleData.previewQuest)
    .modelContainer(PreviewSampleData.container)
}
