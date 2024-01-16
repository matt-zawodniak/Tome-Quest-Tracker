//
//  Quest+CoreDataProperties.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/6/23.
//
//

import Foundation
import CoreData
import AppIntents

extension Quest {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Quest> {
    return NSFetchRequest<Quest>(entityName: "Quest")
  }

  @NSManaged public var difficulty: Int64
  @NSManaged public var dueDate: Date?
  @NSManaged public var id: UUID
  @NSManaged public var isSelected: Bool
  @NSManaged public var isCompleted: Bool
  @NSManaged public var length: Int64
  @NSManaged public var questBonusExp: Double
  @NSManaged public var questBonusReward: String?
  @NSManaged public var questDescription: String?
  @NSManaged public var questName: String
  @NSManaged public var questType: Int64
  @NSManaged public var timeCreated: Date?
}

extension Quest: Identifiable {

  static func findQuestBy(id: UUID) -> Quest? {

    let request: NSFetchRequest<Quest> = Quest.fetchRequest()
    request.fetchLimit = 1
    request.predicate = NSPredicate(format: "id = $@", id as CVarArg)

   let foundQuest = try? CoreDataController.shared.container.viewContext.fetch(request).first ?? nil

    return foundQuest
  }

  static func findQuestBy(name: String) -> Quest? {
    let request: NSFetchRequest<Quest> = Quest.fetchRequest()
    request.fetchLimit = 1
    request.predicate = NSPredicate(format: "questName = %@", name)

   let foundQuest = try? CoreDataController.shared.container.viewContext.fetch(request).first ?? nil

    return foundQuest
  }

  static func completeQuest(name: String) {
    if let quest: Quest = findQuestBy(name: name) {

      let context = CoreDataController.shared.container.viewContext

      let userRequest: NSFetchRequest<User> = User.fetchRequest()
      if let user: User = try? context.fetch(userRequest).first {

        let settingsRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        if let settings: Settings = try? context.fetch(settingsRequest).first {

          quest.isCompleted = true
          user.giveExp(quest: quest, settings: settings, context: context)
          
          CoreDataController.shared.save(context: context)
        }
      }
    }
  }

  var type: QuestType {
    get {
      return QuestType(rawValue: self.questType)!
    }
    set {
      self.questType = newValue.rawValue
    }
  }

  var questLength: QuestLength {
    get {
      return QuestLength(rawValue: self.length)!
    }
    set {
      self.length = newValue.rawValue
    }
  }

  var questDifficulty: QuestDifficulty {
    get {
      return QuestDifficulty(rawValue: self.difficulty)!
    }
    set {
      self.difficulty = newValue.rawValue
    }
  }

  func setDateToDailyResetTime(quest: Quest, settings: Settings) {
    var components = DateComponents()
    components.hour = Calendar.current.component(.hour, from: settings.time!)
    components.minute = Calendar.current.component(.minute, from: settings.time!)
    components.second = Calendar.current.component(.second, from: settings.time!)

    let nextResetTime = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
    quest.dueDate = nextResetTime
  }

  func setDateToWeeklyResetDate(quest: Quest, settings: Settings) {
    var components = DateComponents()
    components.weekday = Int(settings.dayOfTheWeek)
    components.hour = Calendar.current.component(.hour, from: settings.time!)
    components.minute = Calendar.current.component(.minute, from: settings.time!)

    let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)

    quest.dueDate = nextResetDay
  }

  static func defaultQuest(context: NSManagedObjectContext) -> Quest {
    let quest = Quest(context: context)
    quest.questName = ""
    quest.type = .mainQuest
    quest.difficulty = 1
    quest.length = 1

    return quest
  }
}

enum QuestType: Int64, CaseIterable, CustomStringConvertible, AppEnum {
  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Quest Type")

  static var caseDisplayRepresentations: [QuestType: DisplayRepresentation] = [
    .mainQuest: "Main",
    .sideQuest: "Side",
    .dailyQuest: "Daily",
    .weeklyQuest: "Weekly"
  ]

  case mainQuest = 0
  case sideQuest = 1
  case dailyQuest = 2
  case weeklyQuest = 3

  var description: String {
    switch self {
    case .mainQuest: return "Main Quest"
    case .sideQuest: return "Side Quest"
    case .dailyQuest: return "Daily Quest"
    case .weeklyQuest: return "Weekly Quest"
    }
  }

  var experience: Double {
    switch self {
    case .mainQuest: return 40
    case .sideQuest: return 10
    case .dailyQuest: return 4
    case .weeklyQuest: return 20
    }
  }
}

enum QuestDifficulty: Int64, CaseIterable, CustomStringConvertible {
  case easy = 0
  case average = 1
  case hard = 2

  var description: String {
    switch self {
    case .easy: return "Easy"
    case .average: return "Average"
    case .hard: return "Hard"
    }
  }

  var expMultiplier: Double {
    switch self {
    case .easy: 0.75
    case .average: 1
    case .hard: 1.25
    }
  }
}

enum QuestLength: Int64, CaseIterable, CustomStringConvertible {
  case short = 0
  case average = 1
  case long = 2

  var description: String {
    switch self {
    case .short: return "Short"
    case .average: return "Average"
    case .long: return "Long"
    }
  }

  var expMultiplier: Double {
    switch self {
    case .short: 0.75
    case .average: 1
    case .long: 1.25
    }
  }
}
