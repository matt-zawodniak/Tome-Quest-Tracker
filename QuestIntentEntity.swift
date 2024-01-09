//
//  QuestIntentEntity.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/9/24.
//

import AppIntents
import Foundation
import CoreData

struct QuestIntentEntity: AppEntity, Identifiable {

  var id: UUID

  @Property(title: "Name") var name: String
  @Property(title: "Is Completed") var isCompleted: Bool

  init(id: UUID, name: String, isCompleted: Bool) {
    self.id = id
    self.name = name
    self.isCompleted = isCompleted
  }

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Quest")

  var displayRepresentation: DisplayRepresentation {
    return DisplayRepresentation(title: "\(name)")
  }

  static var defaultQuery: IntentsQuestQuery = IntentsQuestQuery()
}

struct IntentsQuestQuery: EntityQuery {
  func entities(for identifiers: [UUID]) async throws -> [QuestIntentEntity] {
    let context = CoreDataController.shared.container.viewContext

    return identifiers.compactMap { identifier in
      let match = Quest.findQuest(withId: identifier) ?? Quest.defaultQuest(context: context)

        return QuestIntentEntity(
          id: match.id,
          name: match.questName,
          isCompleted: match.isCompleted
        )
    }
  }
}
