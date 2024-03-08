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

  @Query() var userQueryResults: [User]
  var user: User {

    return userQueryResults.first ?? User.fetchFirstOrInitialize(context: modelContext)

  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true }) var earnedRewards: [Reward]

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

  }

}

#Preview {
  MainActor.assumeIsolated {
    MainView()
      .modelContainer(PreviewSampleData.container)
  }
}
