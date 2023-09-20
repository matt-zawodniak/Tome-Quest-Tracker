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
}

enum QuestType: Int {
	case mainQuest = 0
	case sideQuest = 1
	case dailyQuest = 2
	case weeklyQuest = 3
}

