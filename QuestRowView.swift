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
      QuestView(quest: quest, editingQuest: true)
        .presentationDetents([.medium, .large])
    }
  }
}

#Preview {
    QuestRowView(quest: PreviewSampleData.previewQuest)
    .modelContainer(PreviewSampleData.container)
}
