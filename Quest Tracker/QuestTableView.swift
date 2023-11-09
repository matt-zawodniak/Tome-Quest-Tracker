//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
 @ObservedObject var tracker: QuestTrackerViewModel
 @Environment(\.managedObjectContext) var managedObjectContext
 @FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)], predicate: NSPredicate(format: "isCompleted == false")) var quests: FetchedResults<Quest>
 @State var activeSortType: QuestSortDescriptor = .timeCreated
 @State var completedSortType: QuestSortDescriptor = .timeCreated
 @State var showingCompletedQuests: Bool = false
 @State var navigationTitle: String = "Quest Tracker"
 
 var body: some View {
  NavigationStack {
   List {
    ForEach(quests, id: \.self) { (quest: Quest) in
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
       if !showingCompletedQuests {
        HStack {
         
         NavigationLink(destination: EditPopUpMenu(
          quest: quest, hasDueDate: quest.dueDate.exists)) {
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
     .swipeActions(edge: .trailing) {
      Button(role: .destructive) {
       CoreDataController().deleteQuest(quest: quest, context: managedObjectContext)
      } label: {
       Label("Delete", systemImage: "trash")
      }
      if !showingCompletedQuests {
       NavigationLink(destination: EditPopUpMenu(
        quest: quest, hasDueDate: quest.dueDate.exists)) {
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
       Button() {
        CoreDataController().completeQuest(quest: quest, context: managedObjectContext)
       } label: {
        Image(systemName: "checkmark")
       }
       .tint(.green)					}
     }
    }
    if !showingCompletedQuests {
     HStack {
      Spacer()
      NavigationLink(destination: NewQuestPopUpMenu()) {
       
       Button(
        action: {
        },
        label: {
         Image(systemName: "plus.circle")
        })
      }
      Spacer()
     }
     HStack {
      Spacer()
      Button(
       action: {
        deselectQuests()
        showCompletedQuests()
       },
       label: {
        Text("Completed Quests")
       })
      Spacer()
     }
    }
   }
   .navigationTitle(navigationTitle).navigationBarTitleDisplayMode(.inline)
   .onChange(of: activeSortType) {_ in
    setSortType(sortType: activeSortType)
   }
   .toolbar {
    ToolbarItem(placement: .topBarTrailing) {
     HStack {
      Text("Sort:")
      if showingCompletedQuests {
       Picker("", selection: $completedSortType) {
        ForEach(QuestSortDescriptor.allCases, id: \.self) {
         Text($0.description)
        }
       }
      }
      else {
       Picker("", selection: $activeSortType) {
        ForEach(QuestSortDescriptor.allCases, id: \.self) {
         Text($0.description)
        }
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
 func setSortType(sortType: QuestSortDescriptor) {
  switch sortType {
  case .dueDate: quests.sortDescriptors = [SortDescriptor(\Quest.dueDate)]
  case .oldest: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .forward)]
  case .timeCreated: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .reverse)]
  case .questName: quests.sortDescriptors = [SortDescriptor(\Quest.questName, comparator: .lexical)]
  case .questType: quests.sortDescriptors = [SortDescriptor(\Quest.questType)]
  }
 }
}

struct QuestTableView_Previews: PreviewProvider {
 static var previews: some View {
  QuestTableView(tracker: QuestTrackerViewModel())
 }
}
