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

  var user: User {
    User.fetchFirstOrCreate(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true })
  var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false
  @State var showingLevelUpNotification: Bool = false
  @State var showingQuestDetails: Bool = false

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        QuestListView(showingCompletedQuests: showingCompletedQuests,
                      showingQuestDetails: $showingQuestDetails)
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
  }
}

#Preview {
  MainView()
      .modelContainer(PreviewSampleData.container)
}
