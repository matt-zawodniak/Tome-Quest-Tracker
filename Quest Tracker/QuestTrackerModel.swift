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

extension Settings {
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

extension Date {
	func setDateToDailyResetTime(date: Date) -> Date {
		Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
	}
}

