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
  @NSManaged public var time: Date?
  @NSManaged public var weeklyResetWarning: Bool

}

extension Settings: Identifiable {

  static func fetchFirstOrCreate(context: NSManagedObjectContext) {

    var userSettings: Settings? {
      let request = NSFetchRequest<Settings>(entityName: "Settings")
      var userSettingsFetchResults = (try? context.fetch(request)) ?? []
      return userSettingsFetchResults.first ?? nil
    }

    if userSettings == nil {
      let defaultSettings = Settings(context: context)

      var components = DateComponents()
      components.day = 1
      components.second = -1

      defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))

      defaultSettings.dayOfTheWeek = 2
      defaultSettings.dailyResetWarning = false
      defaultSettings.weeklyResetWarning = false
      defaultSettings.levelingScheme = 0

      CoreDataController.shared.save(context: context)
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
  case normal = 0
  case hard = 1

  var description: String {
    switch self {
    case .normal: "Normal"
    case .hard: "Hard"
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
