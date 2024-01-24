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
    return settingsQueryResults.first ?? Settings.fetchFirstOrInitialize(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return userQueryResults.first ?? User.fetchFirstOrInitialize(context: modelContext)
  }

  @State var sortType: QuestSortDescriptor = .timeCreated
  @State var newQuestView: Bool = false
  @State var showingCompletedQuests: Bool = false
  @State var navigationTitle: String = "Quest Tracker"

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    NavigationStack {
      List {
        ForEach(filteredQuests, id: \.self) { (quest: Quest) in
          QuestRowView(quest: quest, settings: settings)
          .swipeActions(edge: .trailing) { Button(role: .destructive) {
            modelContext.delete(quest)
          } label: {
            Label("Delete", systemImage: "trash")
          }
            if !showingCompletedQuests {
              NavigationLink(destination: QuestView(
                quest: quest, hasDueDate: quest.dueDate.exists, settings: settings)) {
                  Button(action: {
                  }, label: {
                    Text("Edit")
                  }
                  )
                }
            }
          }
          .swipeActions(edge: .leading) {
            if !showingCompletedQuests {
              Button {
                quest.isCompleted = true
                user.giveExp(quest: quest, settings: settings, context: modelContext)
                quest.timeCompleted = Date.now
              } label: {
                Image(systemName: "checkmark")
              }
              .tint(.green)          }
          }
        }
        if !showingCompletedQuests {
          HStack {
            Button(
              action: {
                newQuestView = true
              },
              label: {
                Image(systemName: "plus.circle")
              })
          }
          HStack {
            Spacer()
            NavigationLink(destination: SettingsView(settings: settings, user: user)) {
              Button(action: {}, label: {
                Text("Settings")
              })
            }
          }
          HStack {
            Button(
              action: {
                showCompletedQuests()
              },
              label: {
                Text("Completed Quests")
              })
          }
          HStack {
            Spacer()
            NavigationLink(destination: RewardsView(user: user)) {
              Button(action: {}, label: {
                Text("View Rewards")
              })
            }
          }
        }
      }
      .navigationTitle(navigationTitle).navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HStack {
            Text("Sort:")
            Picker("", selection: $sortType) {
              ForEach(QuestSortDescriptor.allCases, id: \.self) {
                Text($0.description)
              }
            }
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
            Text(settings.time, style: .timer)
          }
        }
      }
      .navigationDestination(isPresented: $newQuestView) {
        QuestView(quest: Quest.defaultQuest(context: modelContext), hasDueDate: false, settings: settings)
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

struct QuestTableView_Previews: PreviewProvider {
  static var previews: some View {
    QuestListView(tracker: QuestTrackerViewModel())
  }
}
