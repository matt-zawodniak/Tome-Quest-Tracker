//
//  QuestTrackerModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTrackerModel {
	
}

struct Quest: Identifiable, Hashable {
	
	var questType: String, Comparable
	var questName: String
	var timeRemaining: TimeInterval?
	var questDescription: String?
	var questBonusExp: Int?
	var questBonusReward: String?
	var id = UUID()
	var isSelected: Bool = false
}

enum typesOfQuests {
	case mainQuest
	case sideQuest
	case dailyQuest
	case weeklyQuest
}
