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
