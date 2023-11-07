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

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var dailyResetWarning: Bool
    @NSManaged public var dayOfTheWeek: Int64
    @NSManaged public var levelingScheme: Int64
    @NSManaged public var time: Date?
    @NSManaged public var weeklyResetWarning: Bool

}

extension Settings : Identifiable {
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


