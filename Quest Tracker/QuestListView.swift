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
  @FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)],
                predicate: NSPredicate(format: "isCompleted == false")) var quests: FetchedResults<Quest>
  @State var sortType: QuestSortDescriptor = .timeCreated
  @State var newQuestView: Bool = false
  @State var showingCompletedQuests: Bool = false
  @State var navigationTitle: String = "Quest Tracker"
  @FetchRequest(sortDescriptors: []) var settingsFetchResults: FetchedResults<Settings>
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
          }
        }
      }
      .navigationDestination(isPresented: $newQuestView) {
        QuestView(quest: Quest.defaultQuest(context: managedObjectContext), hasDueDate: false, settings: settings)
      }
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
  @FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)],
                predicate: NSPredicate(format: "isCompleted == false")) var quests: FetchedResults<Quest>
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
      .onTapGesture {
        selectQuest(quest: quest, quests: quests)
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
            restoreQuest(quest: quest)
            CoreDataController().save(context: managedObjectContext)
          } label: {
            Text("Restore to Quest List")
          }
        }
      }
    }
  }
  func restoreQuest(quest: Quest) {
    quest.isCompleted = false
    quest.timeCreated = Date.now
    print("\(quest.questName!) is \(quest.isCompleted)")
  }
  func selectQuest(quest: Quest, quests: FetchedResults<Quest>) {
      quest.isSelected.toggle()
      for other in quests where other != quest {
        other.isSelected = false
      }
    }
}

struct QuestTableView_Previews: PreviewProvider {
  static var previews: some View {
    QuestListView(tracker: QuestTrackerViewModel())
  }
}
