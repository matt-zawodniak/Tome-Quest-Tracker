//
//  QuestRowView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/27/23.
//

import CoreData
import SwiftUI

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
        toggleQuest(quest: quest, quests: quests)
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
            CoreDataController.shared.save(context: managedObjectContext)
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
  func toggleQuest(quest: Quest, quests: FetchedResults<Quest>) {
      quest.isSelected.toggle()
      for other in quests where other != quest {
        other.isSelected = false
      }
    }
}
