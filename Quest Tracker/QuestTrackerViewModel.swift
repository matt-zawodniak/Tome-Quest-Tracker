//
//  QuestTrackerViewModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI

class QuestTrackerViewModel: ObservableObject {
	@Published var trackerModel = QuestTrackerModel()
	
	init() {
		trackerModel.questList = [
			Quest(questType: .sideQuest, questName: "Do Dishes", timeCreated: Date(timeIntervalSince1970: 1)),
			Quest(questType: .mainQuest, questName: "Work on TableView", timeCreated: Date(timeIntervalSince1970: 5)),
			Quest(questType: .dailyQuest, questName: "Exercise Ankle", timeRemaining: 50, questDescription: "Trace the alphabet, once with each foot.", timeCreated: Date(timeIntervalSince1970: 7)),
			Quest(questType: .weeklyQuest, questName: "Food Shopping", timeRemaining: 500, timeCreated: Date(timeIntervalSince1970: 19)),
			Quest(questType: .dailyQuest, questName: "Brush Teeth", timeRemaining: 50, timeCreated: Date(timeIntervalSince1970: 11))
		]
	}
	
		
	func sortByName() {
		trackerModel.sortByName()
	}
	func sortByType() {
		trackerModel.sortByType()
	}
	func sortByRecent() {
		trackerModel.sortByRecent()
	}
	func sortByTimeRemainingAscending() {
		trackerModel.sortByTimeRemainingAscending()
	}
	func sortByTimeRemainingDescending() {
		trackerModel.sortByTimeRemainingDescending()
	}
}
