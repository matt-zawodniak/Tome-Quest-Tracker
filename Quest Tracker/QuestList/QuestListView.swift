//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import SwiftUIIntrospect
import SwiftData
import NavigationTransitions

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
                .listRowSeparator(.hidden)

              }
              .foregroundStyle(.cyan)
            } else {
              QuestList(sortDescriptor: tracker.sortDescriptorFromSortType(sortType: sortType),
                        settings: settings,
                        showingCompletedQuests: showingCompletedQuests,
                        user: user)
            }
          }
          .padding()
          .listStyle(.grouped)
          .listRowSpacing(5)
          .scrollContentBackground(.hidden)

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
        .navigationTransition(.slide)
        .introspect(.navigationStack, on: .iOS(.v16, .v17)) {
                        $0.viewControllers.forEach { controller in
                            controller.view.backgroundColor = .clear
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
      )
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
