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

  @Environment(\.scenePhase) var scenePhase

  @ObservedObject var tracker = QuestTrackerViewModel()

  var user: User {
    User.fetchFirstOrCreate(context: modelContext)
  }

  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
    return settingsQueryResults.first ?? Settings.fetchFirstOrCreate(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true })
  var earnedRewards: [Reward]

  @State var showingCompletedQuests: Bool = false

  @State var showingLevelUpNotification: Bool = false

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    ZStack {
      GlobalUISettings.background

      VStack {
        if showingCompletedQuests {
          CompletedQuestListView()
            .layoutPriority(1)
        } else {
          ActiveQuestListView()
            .layoutPriority(1)
        }

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
  }
}

#Preview {
    MainView()
      .modelContainer(PreviewSampleData.container)
}
