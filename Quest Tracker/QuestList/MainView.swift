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

  @Query<Reward>(filter: #Predicate { $0.isEarned == true })
  var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false
  @State var showingLevelUpNotification: Bool = false
  @State var showingAds: Bool = true

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        if showingAds {
          AdBannerView()
            .frame(height: 20)
            .padding(.vertical)
        }

        QuestListView(showingCompletedQuests: showingCompletedQuests)
        .layoutPriority(1)

        VStack {
          NavigationBar(showingCompletedQuests: $showingCompletedQuests)

          LevelAndExpUI(expBarLength: user.currentExp / user.expToLevel)
            .padding(.horizontal)
        }
      }
    }
    .onChange(of: user.level) {
      showingLevelUpNotification = true
    }
    .onAppear {
      showingAds = !user.purchasedRemoveAds
    }
    .onChange(of: user.purchasedRemoveAds) {
      showingAds = !user.purchasedRemoveAds
    }
  }
}

#Preview {
  MainView()
      .modelContainer(PreviewSampleData.container)
}
