//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import SwiftData

struct MainView: View {

  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var editingQuestHandler: EditingQuestHandler

  var user: User {
    User.fetchFirstOrCreate(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true })
  var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false
  @State var showingLevelUpNotification: Bool = false

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        QuestListView(showingCompletedQuests: showingCompletedQuests)
        .layoutPriority(1)

        VStack {
          NavigationBar(showingCompletedQuests: $showingCompletedQuests)

          LevelAndExpUI()
            .padding(.horizontal)
        }
      }
    }
    .onChange(of: user.level) {
      showingLevelUpNotification = true
    }
    .sheet(isPresented: $editingQuestHandler.showingQuestDetails) {
      QuestView(quest: editingQuestHandler.questToShowDetails ?? Quest.defaultQuest(context: modelContext),
                editingQuest: true)
        .presentationDetents([.medium, .large])
    }
  }
}

#Preview {
  MainView()
      .modelContainer(PreviewSampleData.container)
}
