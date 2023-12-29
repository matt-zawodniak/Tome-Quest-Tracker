//
//  IntentsQuestQuery.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/29/23.
//

import AppIntents
import Foundation
import CoreData

struct IntentsQuestQuery: EntityPropertyQuery {

  func entities(for identifiers: [UUID]) async throws -> [ShortcutsQuestEntity] {
    return identifiers.compactMap { identifier in
      
      let request: NSFetchRequest<Quest> = Quest.fetchRequest()
      request.fetchLimit = 1
      request.predicate = NSPredicate(format: "id = $@")

      if let foundQuest = try? CoreDataController.shared.container.viewContext.fetch(request).first {
        return ShortcutsQuestEntity(quest: foundQuest)
      } else {
        return nil
      }

    }
  }

  func suggestedEntities() async throws -> [ShortcutsQuestEntity] {
    return []
  }

  func entities(matching query: String) async throws -> [ShortcutsQuestEntity] {
    return []
  }

  static var properties = QueryProperties {
    Property(\ShortcutsQuestEntity.$questName) {
      EqualToComparator { NSPredicate(format: "questName = %@", $0) }
      ContainsComparator { NSPredicate(format: "questName CONTAINS %@", $0) }
    }
    Property(\ShortcutsQuestEntity.$questType) {
      EqualToComparator { NSPredicate(format: "questType = %@", $0) }
    }
    Property(\ShortcutsQuestEntity.$isCompleted) {
      EqualToComparator { NSPredicate(format: "isCompleted = %@", $0) }
    }
  }

  static var sortingOptions = SortingOptions {
    SortableBy(\ShortcutsQuestEntity.$questName)
    SortableBy(\ShortcutsQuestEntity.$questType)
  }

  func entities(
    matching comparators: [NSPredicate],
    mode: ComparatorMode,
    sortedBy: [Sort<ShortcutsQuestEntity>],
    limit: Int?
  ) async throws -> [ShortcutsQuestEntity] {
    print("Fetching quests")
    let context = CoreDataController.shared.container.viewContext
    let request: NSFetchRequest<Quest> = Quest.fetchRequest()
    let predicate = NSCompoundPredicate(type: .and, subpredicates: comparators)
    request.fetchLimit = limit ?? 5
    request.predicate = predicate

    let matchingQuests = try context.fetch(request)
    return matchingQuests.map { quest in
      ShortcutsQuestEntity(quest: quest)
    }
  }
}
