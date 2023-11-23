//
//  QuestListView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI
import CoreData

struct QuestListView: View {
  @ObservedObject var tracker: QuestTrackerViewModel
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.scenePhase) var scenePhase
  @FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)],
                predicate: NSPredicate(format: "isCompleted == false")) var quests: FetchedResults<Quest>
  @State var sortType: QuestSortDescriptor = .timeCreated
  @State var newQuestView: Bool = false
  @State var showingCompletedQuests: Bool = false
  @State var navigationTitle: String = "Quest Tracker"
  @FetchRequest(sortDescriptors: []) var settingsFetchResults: FetchedResults<Settings>
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var settings: Settings {
    return settingsFetchResults.first!
  }
  var body: some View {
    NavigationStack {
      List {
        ForEach(quests, id: \.self) { (quest: Quest) in
          QuestRowView(quest: quest, settings: settings)
          .swipeActions(edge: .trailing) { Button(role: .destructive) {
            managedObjectContext.delete(quest)
            CoreDataController().save(context: managedObjectContext)
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
                quest.timeCreated = Date.now
                CoreDataController().save(context: managedObjectContext)
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
            NavigationLink(destination: SettingsView(settings: settings)) {
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
        }
      }
      .navigationTitle(navigationTitle).navigationBarTitleDisplayMode(.inline)
      .onChange(of: sortType) {_ in
        tracker.setSortType(sortType: sortType, quests: quests)
      }
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
            Text(settings.time!, style: .timer)
          }
        }
      }
      .navigationDestination(isPresented: $newQuestView) {
        QuestView(quest: Quest.defaultQuest(context: managedObjectContext), hasDueDate: false, settings: settings)
      }
    }
    .onReceive(timer, perform: { _ in
      CoreDataController().resetQuestsOnResetTimer(settings: settings, context: managedObjectContext)
    })
    .onChange(of: scenePhase) { phase in
      if phase == .active {
        CoreDataController().resetQuestsOnResetTimer(settings: settings, context: managedObjectContext)
      }
      print("Scene has changed to \(phase)")
    }
  }
  func showCompletedQuests() {
    tracker.deselectQuests(quests: quests, context: managedObjectContext)
    navigationTitle = "Completed Quests"
    showingCompletedQuests = true
    quests.nsPredicate = NSPredicate(format: "isCompleted == true")
  }
  func showActiveQuests() {
    tracker.deselectQuests(quests: quests, context: managedObjectContext)
    navigationTitle = "Quest Tracker"
    showingCompletedQuests = false
    quests.nsPredicate = NSPredicate(format: "isCompleted == false")
  }
}

struct QuestRowView: View, Identifiable {
  var id = UUID()

  @ObservedObject var quest: Quest
  var settings: Settings
  @Environment(\.managedObjectContext) var managedObjectContext

  var body: some View {
    VStack {
      HStack {
        switch quest.type {
        case .mainQuest: Text("!").foregroundStyle(.red)
        case .sideQuest: Text("!").foregroundStyle(.yellow)
        case .dailyQuest: Text("!").foregroundStyle(.green)
        case .weeklyQuest: Text("!").foregroundStyle(.purple)
        }
        Text(quest.questName ?? "")
        Spacer()
      }
      if quest.isSelected {
        Text(quest.questDescription ?? "")
        Text("Quest EXP:")
        HStack {
          Text("Quest Reward:")
          Text(quest.questBonusReward ?? "")
        }
        if !quest.isCompleted {
          HStack {
            NavigationLink(destination: QuestView(
              quest: quest, hasDueDate: quest.dueDate.exists, settings: settings)) {
                Button(action: {
                }, label: {
                  Text("Edit")
                }
                )
              }
            Spacer()
            Button(action: {
            },
                   label: {Text("Complete")})
          }
        } else {
          Button {
            quest.isCompleted = false
            quest.timeCreated = Date()
            CoreDataController().save(context: managedObjectContext)
          } label: {
            Text("Restore to Quest List")
          }
        }
      }
    }
  }
}

struct QuestTableView_Previews: PreviewProvider {
  static var previews: some View {
    QuestListView(tracker: QuestTrackerViewModel())
  }
}
