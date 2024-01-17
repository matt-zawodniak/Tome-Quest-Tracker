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
  @NSManaged public var time: Date
  @NSManaged public var weeklyResetWarning: Bool

}

extension Settings: Identifiable {
  func setNewResetTime() {
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
    let newResetTime = Calendar.current.nextDate(after: Date.now, matching: components, matchingPolicy: .nextTime)
    time = newResetTime!
  }

  func refreshDailyReset() {
    var components = DateComponents()
    components.day = 1
    time = Calendar.current.date(byAdding: components, to: time)!
  }

  static func fetchFirstOrInitialize(context: NSManagedObjectContext) -> Settings {

    var userSettings: Settings? {
      let request = NSFetchRequest<Settings>(entityName: "Settings")
      let userSettingsFetchResults = (try? context.fetch(request)) ?? []
      return userSettingsFetchResults.first ?? nil
    }

    if let userSettings {
      return userSettings
    } else {
      let defaultSettings = Settings(context: context)

      var components = DateComponents()
      components.day = 1
      components.second = -1

      defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))!

      defaultSettings.dayOfTheWeek = 2
      defaultSettings.dailyResetWarning = false
      defaultSettings.weeklyResetWarning = false

      return defaultSettings
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
