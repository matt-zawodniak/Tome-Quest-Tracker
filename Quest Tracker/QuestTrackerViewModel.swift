//
//  QuestTrackerViewModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI
import CoreData

class QuestTrackerViewModel: ObservableObject {

  @Published var trackerModel = QuestTrackerModel()
  func resetQuests(quests: FetchedResults<Quest>, settings: Settings, context: NSManagedObjectContext) {
    let now = Date.now
    if now >= settings.time! {
      settings.refreshOnDailyReset(settings: settings)
      for quest in quests where quest.type == .dailyQuest {
        quest.setDateToDailyResetTime(quest: quest, settings: settings)
        quest.isCompleted = false
      }
      let weekday = Calendar.current.component(.weekday, from: now)
        for quest in quests where quest.type == .weeklyQuest {
          let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? Date.distantPast
          let components = DateComponents(weekday: Int(settings.dayOfTheWeek))
          let mostRecentWeeklyReset = Calendar.current.nextDate(
            after: lastWeek,
            matching: components,
            matchingPolicy: .nextTime)!
          print(mostRecentWeeklyReset)
          if quest.timeCreated! < mostRecentWeeklyReset || weekday == settings.dayOfTheWeek {
            quest.setDateToWeeklyResetDate(quest: quest, settings: settings)
            quest.isCompleted = false
          }
      }
      CoreDataController().save(context: context)
    }
  }

  func selectQuest(quest: Quest, quests: FetchedResults<Quest>) {
      quest.isSelected.toggle()
      for other in quests where other != quest {
        other.isSelected = false
      }
    }

    func deselectQuests(quests: FetchedResults<Quest>, context: NSManagedObjectContext) {
      for quest in quests {
        quest.isSelected = false
      }
    }

    func setSortType(sortType: QuestSortDescriptor, quests: FetchedResults<Quest>) {
      switch sortType {
      case .dueDate: quests.sortDescriptors = [SortDescriptor(\Quest.dueDate)]
      case .oldest: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .forward)]
      case .timeCreated: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .reverse)]
      case .questName: quests.sortDescriptors = [SortDescriptor(\Quest.questName, comparator: .lexical)]
      case .questType: quests.sortDescriptors = [SortDescriptor(\Quest.questType)]
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

extension Date {
  var string: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: self)
  }
  var dayOnly: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"

    return dateFormatter.string(from: self)
  }
  var timeOnly: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: self)
  }
}

extension Optional where Wrapped == Date {
  var _bound: Date? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  public var bound: Date {
    get {
      return _bound ?? Date()
    }
    set {
      _bound = newValue
    }
  }
  var exists: Bool {
    if self == nil {
      return false
    } else {
      return true
    }
  }
  var string: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    if self == nil {
      return ""
    } else {
      return dateFormatter.string(from: self!)
    }
  }
  var dateOnly: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    if self == nil {
      return ""
    } else {
      return dateFormatter.string(from: self!)
    }
  }
  var dayOnly: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    if self == nil {
      return ""
    } else {
      return dateFormatter.string(from: self!)
    }
  }
  var timeOnly: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    if self == nil {
      return ""
    } else {
      return dateFormatter.string(from: self!)
    }
  }
}
extension Optional where Wrapped == String {
  var _bound: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  public var bound: String {
    get {
      return _bound ?? ""
    }
    set {
      _bound = newValue.isEmpty ? nil : newValue
    }
  }
}
