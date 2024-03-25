//
//  QuestTrackerViewModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI
import SwiftData

class QuestTrackerViewModel: ObservableObject {

  @Published var trackerModel = QuestTrackerModel()

  func deselectQuests(quests: [Quest], context: ModelContext) {
    for quest in quests {
      quest.isSelected = false
    }
  }

  func sortDescriptorFromSortType(sortType: QuestSortDescriptor) -> SortDescriptor<Quest> {
    switch sortType {
    case .dueDate: SortDescriptor(\Quest.dueDate, order: .reverse)
    case .oldest: SortDescriptor(\Quest.timeCreated, order: .forward)
    case .timeCreated: SortDescriptor(\Quest.timeCreated, order: .reverse)
    case .questName: SortDescriptor(\Quest.questName, comparator: .lexical)
    case .questType: SortDescriptor(\Quest.questType)
    }
  }

  func refreshSettingsAndQuests(settings: Settings, context: ModelContext) {
    settings.refreshDailyReset()

    Quest.resetQuests(settings: settings, context: context)
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
