////
////  DataController.swift
////  Quest Tracker
////
////  Created by Matt Zawodniak on 10/5/23.
////
//
// import CoreData
// import Foundation
// import SwiftUI
//
// class CoreDataController: ObservableObject {
//  static let shared = CoreDataController()
//
//  init(inMemory: Bool = false) {
//      container = NSPersistentContainer(name: "DataModel")
//      if inMemory {
//          container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//      }
//      container.loadPersistentStores(completionHandler: { (_, error) in
//          if let error = error as NSError? {
//              fatalError("Unresolved error \(error), \(error.userInfo)")
//          }
//      })
//      container.viewContext.automaticallyMergesChangesFromParent = true
//  }
//
//  var container = NSPersistentContainer(name: "DataModel")
//
//  private init() {
//    container.loadPersistentStores {_, error in
//      if let error = error {
//        print("Core Data failed to load: \(error.localizedDescription)")
//      }
//    }
//
//    _ = User.fetchFirstOrInitialize(context: container.viewContext)
//    _ = Settings.fetchFirstOrInitialize(context: container.viewContext)
//    save(context: container.viewContext)
//
//  }
//
//  func save(context: NSManagedObjectContext) {
//    do {
//      try context.save()
//      print("Quest Successfully Saved!")
//    } catch {
//      print("Quest could not be saved.")
//    }
//  }
//
//  func addPreviewQuest (
//    name: String = "Test Name",
//    type: QuestType = .mainQuest,
//    description: String? = "Test Description",
//    bonusReward: String? = "Test Reward",
//    bonusExp: Double? = 42,
//    length: QuestLength = .long,
//    dueDate: Date? = nil,
//    difficulty: QuestDifficulty = .easy,
//    context: NSManagedObjectContext
//  ) -> Quest {
////    let quest = Quest(context: context)
////    quest.questName = name
////    quest.questType = type.rawValue
////    quest.timeCreated = Date()
////    quest.questDescription = description
////    quest.questBonusReward = bonusReward
////    quest.questBonusExp = bonusExp ?? 0
////    quest.length = length.rawValue
////    quest.dueDate = Date()
////    quest.difficulty = difficulty.rawValue
////    quest.isSelected = false
////    quest.id = UUID()
////    save(context: context)
////    return quest
//  }
// }
