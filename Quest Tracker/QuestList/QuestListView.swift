//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import SwiftData

struct QuestListView: View {
  @ObservedObject var tracker: QuestTrackerViewModel
  @Environment(\.modelContext) var modelContext
  @Environment(\.scenePhase) var scenePhase

  @Query<Quest>(sort: [SortDescriptor(\Quest.timeCreated, order: .reverse)]) var quests: [Quest]

  var filteredQuests: [Quest] {
    if showingCompletedQuests {
      return quests.filter({ $0.isCompleted == true})
    } else {
      return quests.filter({ $0.isCompleted == false})
    }
  }

  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
//    return settingsQueryResults.first!
    return settingsQueryResults.first ?? Settings.fetchFirstOrInitialize(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return userQueryResults.first ?? User.fetchFirstOrInitialize(context: modelContext)
  }

  @Query<Reward>(filter: #Predicate { $0.isEarned == true }) var earnedRewards: [Reward]

  @State var sortType: QuestSortDescriptor = .timeCreated
  @State var newQuestView: Bool = false
  @State var rewardsView: Bool = false
  @State var showingCompletedQuests: Bool = false
  @State var navigationTitle: String = "Quest Tracker"
  @State var showingLevelUpNotification: Bool = false

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  @ObservedObject private var sections = SectionModel()

  var body: some View {

    NavigationStack {
      ZStack {
      List {
        if sortType == .questType {
          ForEach(QuestType.allCases, id: \.self) { type in
            let title: String = type.description + "s"
            var numberOfQuestsOfType: Int { filteredQuests.filter({ $0.type == type}).count }

            Section(header: CategoryHeader(title: title, model: self.sections, number: numberOfQuestsOfType)) {
              if self.sections.isOpen(title: title) {
                QuestSection(settings: settings,
                             showingCompletedQuests: showingCompletedQuests,
                             user: user,
                             questType: type)
              } else {
                EmptyView()
              }
            }
          }
        } else {
          QuestList(sortDescriptor: tracker.sortDescriptorFromSortType(sortType: sortType),
                    settings: settings,
                    showingCompletedQuests: showingCompletedQuests,
                    user: user)
        }
      }.disabled(showingLevelUpNotification)
        if showingLevelUpNotification {
          LevelUpNotification(user: user,
                              isPresented: $showingLevelUpNotification,
                              navigateToRewardsView: $rewardsView)
          .padding()
        }
    }
      .navigationTitle(navigationTitle).navigationBarTitleDisplayMode(.inline)
      .toolbar {

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Picker("", selection: $sortType) {
              ForEach(QuestSortDescriptor.allCases, id: \.self) {
                Text($0.description)
              }
            }
          } label: {
            Image(systemName: "arrow.up.arrow.down")
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button(
            action: {
              newQuestView = true
            },
            label: {
              Image(systemName: "plus.circle")
            })
        }

        ToolbarItem(placement: .principal) {
          if showingCompletedQuests {
            Text("Completed Quests")
          } else {
            Text(settings.time, style: .timer)
          }
        }

          ToolbarItem(placement: .topBarLeading) {
            if showingCompletedQuests {
            Button(
              action: {
                showActiveQuests()
              }, label: {
                HStack {
                  Image(systemName: "chevron.backward")
                  Text("Back")
                }
              })
          } else {
            Menu {
              Button("Home", action: { showActiveQuests()})

              Button(
                action: {
                  showCompletedQuests()
                },
                label: {
                  Text("Completed Quests")
                })

              NavigationLink(destination: RewardsView(user: user)) {
                Button(action: {}, label: {
                  Text("View Rewards")
                })
              }

              NavigationLink(destination: SettingsView(settings: settings, user: user)) {
                Button(action: {}, label: {
                  Text("Settings")
                })
              }
            } label: {
                Image(systemName: "list.bullet")
              }
          }
        }
      }
      .navigationDestination(isPresented: $newQuestView) {
        QuestView(quest: Quest.defaultQuest(context: modelContext), hasDueDate: false, settings: settings)
      }
      .navigationDestination(isPresented: $rewardsView) {
        RewardsView(user: user)
      }
      if earnedRewards.count > 0 {
        NavigationLink(destination: RewardsView(user: user)) {
          Text("You have earned rewards! Tap here to view them.").font(.footnote)
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
      print("Scene has changed to \(scenePhase)")
    }
    .onChange(of: user.level) {
      showingLevelUpNotification = true
    }
    LevelAndExpUI()
      .padding(.horizontal)
  }
  func showCompletedQuests() {
    tracker.deselectQuests(quests: quests, context: modelContext)
    navigationTitle = "Completed Quests"
    showingCompletedQuests = true
  }
  func showActiveQuests() {
    tracker.deselectQuests(quests: quests, context: modelContext)
    navigationTitle = "Quest Tracker"
    showingCompletedQuests = false
  }
}

#Preview {
  MainActor.assumeIsolated {
    QuestListView(tracker: QuestTrackerViewModel())
      .modelContainer(PreviewSampleData.container)
  }
}
