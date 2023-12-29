//
//  QuestShortcuts.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/29/23.
//

import Foundation
import AppIntents

struct QuestShortcuts: Identifiable, Hashable, Equatable, AppEntity {

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Quest")
  typealias DefaultQueryType = IntentsQuestQuery
  static var defaultQuery: IntentsQuestQuery = IntentsQuestQuery()

  var id: UUID

  @Property(title: "Quest Name")
  var questName: String

  @Property(title: "Quest Type")
  var questType: Int

  @Property(title: "Is Completed")
  var isCompleted: Bool

  var displayRepresentation: DisplayRepresentation {
    return DisplayRepresentation(
      title: "\(questName)")
  }

  init(quest: Quest) {
    self.id = quest.id
    self.questName = quest.questName
    self.questType = Int(quest.questType)
    self.isCompleted = quest.isCompleted
  }
}

extension QuestShortcuts {

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func ==(lhs: QuestShortcuts, rhs: QuestShortcuts) -> Bool {
    return lhs.id == rhs.id
  
  }
}

//@NSManaged public var difficulty: Int64
//@NSManaged public var dueDate: Date?
//@NSManaged public var id: UUID
//@NSManaged public var isSelected: Bool
//@NSManaged public var isCompleted: Bool
//@NSManaged public var length: Int64
//@NSManaged public var questBonusExp: Double
//@NSManaged public var questBonusReward: String?
//@NSManaged public var questDescription: String?
//@NSManaged public var questName: String
//@NSManaged public var questType: Int64
//@NSManaged public var timeCreated: Date?
