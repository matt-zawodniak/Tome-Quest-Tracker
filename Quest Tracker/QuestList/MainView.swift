//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
  @ObservedObject var tracker: QuestTrackerViewModel
  @Environment(\.modelContext) var modelContext
  @Environment(\.scenePhase) var scenePhase

  var settings: Settings { Settings.fetchFirstOrInitialize(context: modelContext)
  }

  var user: User {
    User.fetchFirstOrInitialize(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true }) var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false
  @State var showingNewQuestView: Bool = false
  @State var showingRewardsView: Bool = false
  @State var showingSettingsView: Bool = false
  @State var showingLevelUpNotification: Bool = false

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        QuestListView(settings: settings,
                      showingCompletedQuests: showingCompletedQuests,
                      user: user)
        .layoutPriority(1)

        VStack {

          NavigationBar(showingNewQuestView: $showingNewQuestView,
                        showingRewardsView: $showingRewardsView,
                        showingSettingsView: $showingSettingsView,
                        showingCompletedQuests: $showingCompletedQuests)

          LevelAndExpUI()
            .padding(.horizontal)

        }
        if earnedRewards.count > 0 {
          NavigationLink(destination: RewardsView(user: user)) {
            Text("You have earned rewards! Tap here to view them.").font(.footnote)
          }
        }
      }
    }

    .onReceive(timer, perform: { time in
      if time >= settings.time {
        tracker.refreshSettingsAndQuests(settings: settings, context: modelContext)
      }
    })
    .onChange(of: scenePhase) {
      if scenePhase == .active {
        if Date.now >= settings.time {
          tracker.refreshSettingsAndQuests(settings: settings, context: modelContext)
        }
      }
    }
    .onChange(of: user.level) {
      showingLevelUpNotification = true
    }
    .sheet(isPresented: $showingNewQuestView) {
      QuestView(quest: Quest.defaultQuest(context: modelContext), settings: settings)
        .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showingRewardsView) {
      RewardsView(user: user)
        .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showingSettingsView) {
      SettingsView(settings: settings, user: user)
        .presentationDetents([.medium, .large])
    }
  }
}

#Preview {
    MainView(tracker: QuestTrackerViewModel())
      .modelContainer(PreviewSampleData.container)
}
