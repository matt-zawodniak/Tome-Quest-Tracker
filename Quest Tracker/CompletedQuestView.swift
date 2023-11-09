//
//  CompletedQuestView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/9/23.
//

import SwiftUI

struct CompletedQuestView: View {
 @Environment(\.managedObjectContext) var managedObjectContext
 @FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)], predicate: NSPredicate(format: "isCompleted == true")) var completedQuests: FetchedResults<Quest>
 @State var sortType: QuestSortDescriptor = .timeCreated
 
 var body: some View {
  NavigationStack {
   List {
    ForEach(completedQuests, id: \.self) { (quest: Quest) in
     VStack {
      HStack {
       switch quest.type {
       case .mainQuest : Text("!").foregroundStyle(.red)
       case .sideQuest : Text("!").foregroundStyle(.yellow)
       case .dailyQuest : Text("!").foregroundStyle(.green)
       case .weeklyQuest : Text("!").foregroundStyle(.purple)
       }
       Text(quest.questName ?? "")
       Spacer()
      }
      .onTapGesture {
       quest.isSelected.toggle()
      }
      
      if quest.isSelected {
       Text(quest.questDescription ?? "")
       
       Text("Quest EXP:")
       HStack {
        Text("Quest Reward:")
        Text(quest.questBonusReward ?? "")
       }
       Button {
        quest.isCompleted = false
        quest.timeCreated = Date()
        CoreDataController().save(context: managedObjectContext)
       } label: {
        Text("Restore to Quest List")
       }
      }
     }
     .swipeActions(edge: .trailing) {
      Button(role: .destructive) {
       CoreDataController().deleteQuest(quest: quest, context: managedObjectContext)
      } label: {
       Label("Delete", systemImage: "trash")
      }
     }
    }
   }
   .navigationTitle("Completed Quests").navigationBarTitleDisplayMode(.inline)
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
   }
  }
 }
 func setSortType() {
  switch sortType {
  case .dueDate: completedQuests.sortDescriptors = [SortDescriptor(\Quest.dueDate)]
  case .oldest: completedQuests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .forward)]
  case .timeCreated: completedQuests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .reverse)]
  case .questName: completedQuests.sortDescriptors = [SortDescriptor(\Quest.questName, comparator: .lexical)]
  case .questType: completedQuests.sortDescriptors = [SortDescriptor(\Quest.questType)]
  }
 }
}

#Preview {
 CompletedQuestView()
}
