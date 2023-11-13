//
//  QuestTrackerModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTrackerModel {
	var questList: [Quest] = []
	
	mutating func sortByType() {
		questList = questList.sorted {
			$0.questType.rawValue < $1.questType.rawValue
		}
	}
	
	mutating func sortByName() {
		questList = questList.sorted {
			$0.questName < $1.questName
		}
	}
	
	mutating func sortByRecent() {
		questList = questList.sorted {
			$0.timeCreated < $1.timeCreated
		}
	}
	
	mutating func sortByTimeRemainingAscending() {
		questList = questList.sorted {
			$0.timeRemaining ?? 999999999999 < $1.timeRemaining ?? 99999999999
		}
	}
	
	mutating func sortByTimeRemainingDescending() {
		questList = questList.sorted {
			$0.timeRemaining ?? 0 > $1.timeRemaining ?? 0
		}
	}
		
}

struct Quest: Identifiable, Hashable {
	
	var questType: QuestType
	var questName: String
	var timeRemaining: TimeInterval?
	var questDescription: String?
	var questBonusExp: Int?
	var questBonusReward: String?
	var id = UUID()
	var isSelected: Bool = false
	var timeCreated: Date
	var difficulty: QuestDifficulty = .average
	var length: QuestLength = .average
	var dueDate: Date?
}

enum QuestType: Int, CaseIterable, CustomStringConvertible {
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

enum QuestDifficulty: CaseIterable, CustomStringConvertible {
	case easy
	case average
	case hard
	
	var description: String {
		switch self {
		case .easy: return "Easy"
		case .average: return "Average"
		case .hard: return "Hard"
		}
	}
}

enum QuestLength: CaseIterable, CustomStringConvertible {
	case short
	case average
	case long
	
	var description: String {
		switch self {
		case .short: return "Short"
		case .average: return "Average"
		case .long: return "Long"
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
	var exists: Bool {
		if self == nil {
			return false
		} else {
			return true
		}
	}
}

