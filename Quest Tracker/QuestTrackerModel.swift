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
	
	var questType: QuestType
	var questName: String
	var timeRemaining: TimeInterval?
	var questDescription: String?
	var questBonusExp: Int?
	var questBonusReward: String?
	var id = UUID()
	var isSelected: Bool = false
}

enum QuestType {
	case mainQuest
	case sideQuest
	case dailyQuest
	case weeklyQuest
}
