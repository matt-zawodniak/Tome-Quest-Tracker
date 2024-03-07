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

  @Query<Quest>(sort: [SortDescriptor(\Quest.questType, order: .reverse)]) var quests: [Quest]

  var filteredQuests: [Quest] {
    if showingCompletedQuests {
      return quests.filter({ $0.isCompleted == true})
    } else {
      return quests.filter({ $0.isCompleted == false})
    }
  }

  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
    return settingsQueryResults.first ?? Settings.fetchFirstOrInitialize(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return userQueryResults.first ?? User.fetchFirstOrInitialize(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true }) var earnedRewards: [Reward]

  @Query() var rewards: [Reward]
  var minorRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == false && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  var milestoneRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == true && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  @State var sortType: QuestSortDescriptor = .questType

  @State var showingCompletedQuests: Bool = false
  @State var showingNewQuestView: Bool = false
  @State var showingRewardsView: Bool = false
  @State var showingSettingsView: Bool = false
  @State var showingLevelUpNotification: Bool = false

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  @ObservedObject private var sections = SectionModel()

  var body: some View {
    Image("IMG_1591")
      .resizable()
//      .scaledToFill()
      .opacity(0.2)
      .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .black, .clear, .clear]),
                           startPoint: .top,
                           endPoint: .bottom))
      .ignoresSafeArea(.all)
      .overlay(

        VStack {
          QuestList(quests: filteredQuests,
                    settings: settings,
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
      .ignoresSafeArea(.keyboard)

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
          print("Scene has changed to \(scenePhase)")
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
    .onChange(of: user.level) {
      showingLevelUpNotification = true
    }
        )
  }
  func showCompletedQuests() {
    tracker.deselectQuests(quests: quests, context: modelContext)
    showingCompletedQuests = true
  }
  func showActiveQuests() {
    tracker.deselectQuests(quests: quests, context: modelContext)
    showingCompletedQuests = false
  }
}

#Preview {
  MainActor.assumeIsolated {
    MainView(tracker: QuestTrackerViewModel())
      .modelContainer(PreviewSampleData.container)
  }
}
