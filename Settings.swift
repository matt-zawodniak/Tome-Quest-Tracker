//
//  Settings.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/22/24.
//
//

import Foundation
import SwiftData

@Model public class Settings {

  var dayOfTheWeek: Int = defaultResetDay.rawValue
  var time: Date = Settings.defaultResetTime
  var weeklyResetWarning: Bool = false

  public init(dayOfTheWeek: Int, time: Date, weeklyResetWarning: Bool) {
    self.dayOfTheWeek = dayOfTheWeek
    self.time = time
    self.weeklyResetWarning = weeklyResetWarning
  }
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

  static var defaultResetTime: Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1

    return Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))!
  }

  static var defaultResetDay: DayOfTheWeek = DayOfTheWeek.monday

  static var defaultSettings: Settings {
    Settings(dayOfTheWeek: defaultResetDay.rawValue,
             time: Settings.defaultResetTime,
             weeklyResetWarning: false)
  }

  static func fetchFirstOrCreate(context: ModelContext) -> Settings {
    let settingsRequest = FetchDescriptor<Settings>()
    let settingsData = try? context.fetch(settingsRequest)

    if let settings = settingsData?.first {
      return settings
    } else {
      context.insert(defaultSettings)
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

enum DayOfTheWeek: Int, CaseIterable, CustomStringConvertible {
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
