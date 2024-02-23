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

  @State var sortType: QuestSortDescriptor = .questType

  @State var newQuestView: Bool = false
  @State var rewardsView: Bool = false
  @State var showingCompletedQuests: Bool = false
  @State var settingsView: Bool = false
  @State var navigationTitle: String = "Quest Tracker"

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  @ObservedObject private var sections = SectionModel()

  var body: some View {
    ZStack {
      Rectangle().background(.black)
      VStack {

        NavigationStack {
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
                .listRowBackground(CustomListBackground(type: type))
              }
              .foregroundStyle(.cyan)
            } else {
              QuestList(sortDescriptor: tracker.sortDescriptorFromSortType(sortType: sortType),
                        settings: settings,
                        showingCompletedQuests: showingCompletedQuests,
                        user: user)
            }
          }
          .padding(.horizontal)
          .listStyle(.grouped)
          .scrollContentBackground(.hidden)
          .background(
              Image("IMG_1591")
                .resizable()
                .opacity(0.1)
                .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]),
                                     startPoint: .top,
                                     endPoint: .bottom)))

          .navigationDestination(isPresented: $newQuestView) {
            QuestView(quest: Quest.defaultQuest(context: modelContext), hasDueDate: false, settings: settings)
          }
          .navigationDestination(isPresented: $settingsView) {
            SettingsView(settings: settings, user: user)
          }
          .navigationDestination(isPresented: $rewardsView) {
            RewardsView(user: user)
          }
        }
        .layoutPriority(1)

        VStack {

          NavigationBar(
            newQuestView: $newQuestView,
            rewardsView: $rewardsView,
            settingsView: $settingsView,
            showingCompletedQuests: $showingCompletedQuests)

          LevelAndExpUI()
            .padding(.horizontal)

        }
      }
      .background(.black)

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
    }
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
