//
//  Settings+CoreDataProperties.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/3/23.
//
//

import Foundation
import CoreData

extension Settings {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
    return NSFetchRequest<Settings>(entityName: "Settings")
  }

  @NSManaged public var dailyResetWarning: Bool
  @NSManaged public var dayOfTheWeek: Int64
  @NSManaged public var levelingScheme: Int64
  @NSManaged public var resetTime: Date
  @NSManaged public var weeklyResetWarning: Bool

}

extension Settings: Identifiable {
  func setNewResetTime() {
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: resetTime)
    let newResetTime = Calendar.current.nextDate(after: Date.now, matching: components, matchingPolicy: .nextTime)
    resetTime = newResetTime!
  }

  func refreshDailyResetAndQuests(context: NSManagedObjectContext) {
    refreshDailyReset()
    resetDailyQuests(context: context)
    resetWeeklyQuests(context: context)
    CoreDataController.shared.save(context: context)
  }

  func refreshDailyReset() {
    var components = DateComponents()
    components.day = 1
    resetTime = Calendar.current.date(byAdding: components, to: resetTime)!
  }

  func resetDailyQuests(context: NSManagedObjectContext) {
    var completedDailyQuests: [Quest] {
      let request = NSFetchRequest<Quest>(entityName: "Quest")
      request.predicate = NSPredicate(format:
                                        "(isCompleted == true) AND (questType == \(QuestType.dailyQuest.rawValue))")
      return (try? context.fetch(request)) ?? []
    }

    let dailyComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: resetTime)
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!

    let mostRecentDailyReset = Calendar.current.nextDate(
      after: yesterday,
      matching: dailyComponents,
      matchingPolicy: .nextTime)!

    for quest in completedDailyQuests where quest.timeCompleted! <= mostRecentDailyReset {
      quest.setDateToDailyResetTime(settings: self)
      quest.isCompleted = false
    }
  }

  func resetWeeklyQuests(context: NSManagedObjectContext) {
    var completedWeeklyQuests: [Quest] {
      let request = NSFetchRequest<Quest>(entityName: "Quest")
      request.predicate = NSPredicate(format:
                                        "(isCompleted == true) AND (questType == \(QuestType.weeklyQuest.rawValue))")
      return (try? context.fetch(request)) ?? []
    }

    var weeklyComponents = DateComponents()
    weeklyComponents.weekday = Int(dayOfTheWeek)
    weeklyComponents.hour = Calendar.current.component(.hour, from: resetTime)
    weeklyComponents.minute = Calendar.current.component(.minute, from: resetTime)
    weeklyComponents.second = Calendar.current.component(.second, from: resetTime)
    let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!

    let mostRecentWeeklyReset = Calendar.current.nextDate(
      after: lastWeek,
      matching: weeklyComponents,
      matchingPolicy: .nextTime)!

    for quest in completedWeeklyQuests where quest.timeCompleted! <= mostRecentWeeklyReset {
      quest.setDateToWeeklyResetDate(settings: self)
      quest.isCompleted = false
    }
  }

  var day: DayOfTheWeek {
    get {
      return DayOfTheWeek(rawValue: self.dayOfTheWeek)!
    }
    set {
      self.dayOfTheWeek = newValue.rawValue
    }
  }

  var scaling: LevelingSchemes {
    get {
      return LevelingSchemes(rawValue: self.levelingScheme)!
    }
    set {
      self.levelingScheme = newValue.rawValue
    }
  }
}

enum LevelingSchemes: Int64, CaseIterable, CustomStringConvertible {
  case none = 0
  case flat = 1
  case linear = 2
  case exponential = 3

  var description: String {
    switch self {
    case .none: "None"
    case .flat: "Flat Increase"
    case .linear: "Linear Increase"
    case .exponential: "Exponential"
    }
  }
}

enum DayOfTheWeek: Int64, CaseIterable, CustomStringConvertible {
  case sunday = 1
  case monday = 2
  case tuesday = 3
  case wednesday = 4
  case thursday = 5
  case friday = 6
  case saturday = 7

  var description: String {
    switch self {
    case .sunday: return "Sunday"
    case .monday: return "Monday"
    case .tuesday: return "Tuesday"
    case .wednesday: return "Wednesday"
    case .thursday: return "Thursday"
    case .friday: return "Friday"
    case .saturday: return "Saturday"
    }
  }
}
