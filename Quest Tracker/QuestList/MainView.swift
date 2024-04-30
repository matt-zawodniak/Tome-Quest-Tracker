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

  @State var navigateToRewardsView: Bool = false

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

      if user.leveledUpRecently {
        Rectangle()
        .foregroundStyle(.black)
        .opacity(0.8)
        .onTapGesture {
          user.leveledUpRecently = false
        }

        LevelUpNotification(user: user, navigateToRewardsView: $navigateToRewardsView)
        .padding(.horizontal)
      }
    }
    .onChange(of: user.level) {
      user.leveledUpRecently = true
    }
    .sheet(isPresented: $navigateToRewardsView, content: {
      RewardsView()
        .presentationDetents([.medium, .large])
    })
  }
}

#Preview {
    MainView()
      .modelContainer(PreviewSampleData.container)
}
