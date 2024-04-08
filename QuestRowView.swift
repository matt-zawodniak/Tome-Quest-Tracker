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
  @EnvironmentObject var editingQuestHandler: EditingQuestHandler

  var id = UUID()

  @State var quest: Quest

  var body: some View {
      HStack {
        Text(quest.questName)
        Spacer()
      }
    .contentShape(Rectangle())
    .onTapGesture {
      editingQuestHandler.questToShowDetails = quest
      editingQuestHandler.showingQuestDetails.toggle()
    }
  }
}

#Preview {
  QuestRowView(quest: PreviewSampleData.previewQuest)
    .modelContainer(PreviewSampleData.container)
}
