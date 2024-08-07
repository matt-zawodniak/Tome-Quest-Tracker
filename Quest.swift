//
//  Quest.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/22/24.
//
//

import Foundation
import SwiftData
import AppIntents

@Model class Quest {
  var difficulty: Int = QuestDifficulty.average.rawValue
  var dueDate: Date?
  var id = UUID()
  var isCompleted: Bool = false
  var length: Int = QuestLength.average.rawValue
  var questBonusReward: String?
  var questDescription: String?
  var questName: String = ""
  var questType: Int = QuestType.mainQuest.rawValue
  var timeCompleted: Date?
  var timeCreated: Date = Date.now

  public init(
    difficulty: Int,
    dueDate: Date? = nil,
    id: UUID,
    isCompleted: Bool,
    length: Int,
    questBonusReward: String? = nil,
    questDescription: String? = nil,
    questName: String,
    questType: Int,
    timeCompleted: Date? = nil,
    timeCreated: Date) {
      self.difficulty = difficulty
      self.dueDate = dueDate
      self.id = id
      self.isCompleted = isCompleted
      self.length = length
      self.questBonusReward = questBonusReward
      self.questDescription = questDescription
      self.questName = questName
      self.questType = questType
      self.timeCompleted = timeCompleted
      self.timeCreated = timeCreated
    }
}

extension Quest: Identifiable {
  static func findActiveQuestBy(name: String, context: ModelContext) -> Quest? {
    var request = FetchDescriptor<Quest>(predicate: #Predicate { $0.questName == name && $0.isCompleted == false })
    request.fetchLimit = 1

    let foundQuest = try? context.fetch(request).first ?? nil

    return foundQuest
  }

  static func findByNameAndComplete(name: String, context: ModelContext) {
    if let quest: Quest = findActiveQuestBy(name: name, context: context) {
      let user: User = User.fetchFirstOrCreate(context: context)

      let settings: Settings = Settings.fetchFirstOrCreate(context: context)

      quest.complete(user: user, settings: settings, context: context)
    }
  }

  func complete(user: User, settings: Settings, context: ModelContext) {
    isCompleted = true

    timeCompleted = Date.now

    user.giveExp(quest: self, settings: settings, context: context)
  }

  func skip() {
    isCompleted = true
    timeCompleted = Date.now
  }

  func restoreToActive() {
    isCompleted = false
    timeCreated = Date.now
  }

  var completionExp: Double { type.experience
    * (questDifficulty.expMultiplier + questLength.expMultiplier)/2
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

  static func resetQuests(settings: Settings, context: ModelContext) {
    resetDailyQuests(settings: settings, context: context)
    resetWeeklyQuests(settings: settings, context: context)
  }

  static func resetDailyQuests(settings: Settings, context: ModelContext) {
    var completedDailyQuests: [Quest] {
      let dailyRawValue = QuestType.dailyQuest.rawValue

      let request = FetchDescriptor<Quest>(
        predicate: #Predicate { $0.isCompleted == true && $0.questType == dailyRawValue})

      return (try? context.fetch(request)) ?? []
    }

    let dailyComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: settings.time)

    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!

    let mostRecentDailyReset = Calendar.current.nextDate(
      after: yesterday,
      matching: dailyComponents,
      matchingPolicy: .nextTime)!

    for quest in completedDailyQuests where quest.timeCompleted! <= mostRecentDailyReset {
      quest.setDateToDailyResetTime(settings: settings)

      quest.isCompleted = false
    }
  }

  static func resetWeeklyQuests(settings: Settings, context: ModelContext) {

    var completedWeeklyQuests: [Quest] {
      let weeklyRawValue = QuestType.weeklyQuest.rawValue

      let request = FetchDescriptor<Quest>(
        predicate: #Predicate { $0.isCompleted == true && $0.questType == weeklyRawValue})

      return (try? context.fetch(request)) ?? []
    }

    var weeklyComponents = DateComponents()
    weeklyComponents.weekday = Int(settings.dayOfTheWeek)
    weeklyComponents.hour = Calendar.current.component(.hour, from: settings.time)
    weeklyComponents.minute = Calendar.current.component(.minute, from: settings.time)
    weeklyComponents.second = Calendar.current.component(.second, from: settings.time)

    let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!

    let mostRecentWeeklyReset = Calendar.current.nextDate(
      after: lastWeek,
      matching: weeklyComponents,
      matchingPolicy: .nextTime)!

    for quest in completedWeeklyQuests where quest.timeCompleted! <= mostRecentWeeklyReset {
      quest.setDateToWeeklyResetDate(settings: settings)

      quest.isCompleted = false
    }
  }

  func setDateToDailyResetTime(settings: Settings) {
    var components = DateComponents()
    components.hour = Calendar.current.component(.hour, from: settings.time)
    components.minute = Calendar.current.component(.minute, from: settings.time)
    components.second = Calendar.current.component(.second, from: settings.time)

    let nextResetTime = Calendar.current.nextDate(after: Date.now, matching: components, matchingPolicy: .nextTime)

    dueDate = nextResetTime
  }

  func setDateToWeeklyResetDate(settings: Settings) {
    var components = DateComponents()
    components.weekday = Int(settings.dayOfTheWeek)
    components.hour = Calendar.current.component(.hour, from: settings.time)
    components.minute = Calendar.current.component(.minute, from: settings.time)

    let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)

    dueDate = nextResetDay
  }

  static func defaultQuest(context: ModelContext) -> Quest {
    let quest = Quest(difficulty: 1,
                      id: UUID(),
                      isCompleted: false,
                      length: QuestLength.average.rawValue,
                      questName: "",
                      questType: QuestType.mainQuest.rawValue,
                      timeCreated: Date.now)

    return quest
  }
}

enum QuestType: Int, CaseIterable, CustomStringConvertible, AppEnum {
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

enum QuestDifficulty: Int, CaseIterable, CustomStringConvertible {
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

enum QuestLength: Int, CaseIterable, CustomStringConvertible {
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
