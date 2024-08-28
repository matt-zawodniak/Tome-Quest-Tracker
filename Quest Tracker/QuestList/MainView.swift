//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import SwiftData
import GoogleMobileAds
import StoreKit

struct MainView: View {

  @Environment(\.modelContext) var modelContext

  var user: User {
    User.fetchFirstOrCreate(context: modelContext)
  }

  @ObservedObject var sections = SectionsModel()

  @Query<Reward>(filter: #Predicate { $0.isEarned == true })
  var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false
  @State var showingLevelUpNotification: Bool = false

  @State var navigateToRewardsView: Bool = false

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        if !user.purchasedRemoveAds {
          AdBannerView()
            .frame(height: 20)
            .padding(.vertical)
        }

        QuestListView(sections: sections, showingCompletedQuests: showingCompletedQuests)
        .layoutPriority(1)

        VStack {
          NavigationBar(showingCompletedQuests: $showingCompletedQuests, sections: sections)

          LevelAndExpUI(expBarLength: user.currentExp / user.expToLevel)
            .padding(.horizontal)
        }
      }

      if user.leveledUpRecently {
        Rectangle()
        .ignoresSafeArea(.all)
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
    })
  }
}

#Preview {
  MainView()
      .modelContainer(PreviewSampleData.container)
}
