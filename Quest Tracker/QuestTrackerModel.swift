//
//  QuestTrackerModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTrackerModel {
  
  func setDate(quest: Quest, value: Bool) {
    if value == true {
      quest.dueDate = Date()
    }
    else {
      quest.dueDate = nil
    }
  }
}

enum QuestSortDescriptor: Int64, CaseIterable, CustomStringConvertible {
  case timeCreated = 0
  case oldest = 1
  case questType = 2
  case questName = 3
  case dueDate = 4
  
  var description: String {
    switch self {
    case .timeCreated: return "Recent"
    case .oldest: return "Oldest"
    case .questType: return "Type"
    case .questName: return "Name"
    case .dueDate: return "Due Date"
    }
  }
}

enum QuestType: Int64, CaseIterable, CustomStringConvertible {
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
}

extension Quest {
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
}

extension Date {
  func setDateToDailyResetTime(date: Date) -> Date {
    Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
  }
}

