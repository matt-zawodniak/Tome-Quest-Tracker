//
//  QuestTrackerModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTrackerModel {
	var questList: [Quest] = []
	var completedQuests: [Quest] = []
	var level: Double = 1
	var exp: Double = 0
	var availableRewards: [String] = []
	
	mutating func completeQuest(quest: Quest) {
		completedQuests.append(quest)
		questList.removeAll(where: {$0 == quest})
		if quest.questBonusReward != nil {
			availableRewards.append(quest.questBonusReward!)
		}
		gainExp(quest: quest)
	}
	
	mutating func gainExp(quest: Quest) {
		exp = exp +	(quest.questType.standardExp * (1 + quest.difficulty.expModifier + quest.length.expModifier)) +	Double(quest.questBonusExp ?? 0)
		
		if exp >= level * 20 {
			level += 1
			exp = exp - (level * 20)
		}
	}
	
	//TODO: Adjustable levelUP requirement? 10 + level * 10 maybe? Could be a setting - either flat, linear, or exponential
	
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
	
	var standardExp: Double {
		switch self {
		case .mainQuest: return 10
		case .sideQuest: return 4
		case .dailyQuest: return 1
		case .weeklyQuest: return 2
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
	
	var expModifier: Double {
		switch self {
		case .easy: return -0.25
		case .average: return 0
		case .hard: return 0.25
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
	
	var expModifier: Double {
		switch self {
		case .short: return -0.25
		case .average: return 0
		case .long: return 0.25
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

