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
  @FetchRequest(sortDescriptors: []) var settingsFetchResults: FetchedResults<Settings>
  @State var sortType: QuestSortDescriptor = .timeCreated
  @State var showingCompletedQuests: Bool = false
  @State var navigationTitle: String = "Quest Tracker"
  var settings: Settings {
    return settingsFetchResults.first!
  }

  var body: some View {
    NavigationStack {
      List {
        ForEach(quests, id: \.self) { (quest: Quest) in
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
              for other in quests {
                if other == quest {
                  other.isSelected.toggle()
                } else {
                  other.isSelected = false
                }
              }
            }

            if quest.isSelected {
              Text(quest.questDescription ?? "")
              Text("Quest EXP:")
              HStack {
                Text("Quest Reward:")
                Text(quest.questBonusReward ?? "")
              }
              if !showingCompletedQuests {
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
          .swipeActions(edge: .trailing) { Button(role: .destructive) {
            managedObjectContext.delete(quest)
            CoreDataController().save(context: managedObjectContext)
          } label: {
            Label("Delete", systemImage: "trash")
          }
            if !showingCompletedQuests {
              NavigationLink(
                destination: QuestView(quest: quest, hasDueDate: quest.dueDate.exists, settings: settings)) {
                Button(action: {
                },
                       label: {Text("Edit")})
              }
            }
          }
          .swipeActions(edge: .leading) {
                      if !showingCompletedQuests {
                        Button {
                          quest.isCompleted = true
                              quest.isSelected = false
                              quest.timeCreated = Date()
                          CoreDataController().save(context: managedObjectContext)
                        } label: {
                          Image(systemName: "checkmark")
                        }
                        .tint(.green)          }
        }

        HStack {
          Button(
            action: {
              showingCompletedQuests = true
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
      }
      .navigationTitle("Quest Tracker").navigationBarTitleDisplayMode(.inline)
      .onChange(of: sortType) {_ in
        setSortType()
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
                deselectQuests()
                showingCompletedQuests = false
                navigationTitle = "Quest Tracker"
                quests.nsPredicate = NSPredicate(format: "isCompleted == false")
              }, label: {
                HStack {
                  Image(systemName: "chevron.backward")
                  Text("Back")
                }
              })
          }
        }
      }
      }
    }
  }
  func deselectQuests() {
    for quest in quests {
      quest.isSelected = false
    }
    CoreDataController().save(context: managedObjectContext)
  }
  func showCompletedQuests() {
    navigationTitle = "Completed Quests"
       showingCompletedQuests = true
       quests.nsPredicate = NSPredicate(format: "isCompleted == true")
  }
  func setSortType() {
    switch sortType {
    case .dueDate: quests.sortDescriptors = [SortDescriptor(\Quest.dueDate)]
    case .oldest: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .forward)]
    case .timeCreated: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .reverse)]
    case .questName: quests.sortDescriptors = [SortDescriptor(\Quest.questName, comparator: .lexical)]
    case .questType: quests.sortDescriptors = [SortDescriptor(\Quest.questType)]
    }
  }
}

struct QuestListView_Previews: PreviewProvider {
  static var previews: some View {
    QuestListView(tracker: QuestTrackerViewModel())
  }
}
