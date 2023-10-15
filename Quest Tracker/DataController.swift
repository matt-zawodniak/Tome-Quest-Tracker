//
//  DataController.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/5/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
	let container = NSPersistentContainer(name: "DataModel")
	
	init() {
		container.loadPersistentStores {description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
	}
	
	func save(context: NSManagedObjectContext) {
		do {
			try context.save()
			print("Quest Successfully Saved!")
		} catch {
			print("Quest could not be saved.")
		}
	}
	
	func addNewQuest(
		name: String,
		type: QuestType,
		description: String?,
		bonusReward: String?,
		bonusExp: Double?,
		length: QuestLength,
		dueDate: Date?,
		difficulty: QuestDifficulty,
		context: NSManagedObjectContext
	) {
		let quest = Quest(context: context)
		quest.questName = name
		quest.questType = type.rawValue
		quest.timeCreated = Date()
		quest.questDescription = description
		quest.questBonusReward = bonusReward
		quest.questBonusExp = bonusExp ?? 0
		quest.length = length.rawValue
		quest.dueDate = dueDate
		quest.difficulty = difficulty.rawValue
		quest.isSelected = false
		quest.id = UUID()
		
		save(context: context)
	}
	
	func editQuest(
		quest: Quest,
		name: String,
		type: QuestType,
		description: String?,
		bonusReward: String?,
		bonusExp: Double?,
		length: QuestLength,
		dueDate: Date?,
		difficulty: QuestDifficulty,
		context: NSManagedObjectContext
	) {
		quest.questName = name
		quest.questType = type.rawValue
		quest.timeCreated = Date()
		quest.questDescription = description
		quest.questBonusReward = bonusReward
		quest.questBonusExp = bonusExp ?? 0
		quest.length = length.rawValue
		quest.dueDate = dueDate
		quest.difficulty = difficulty.rawValue
		quest.isSelected = false
		
		save(context: context)
	}
	
	func addPreviewQuest (
		name: String = "Test Name",
		type: QuestType = .mainQuest,
		description: String? = "Test Description",
		bonusReward: String? = "Test Reward",
		bonusExp: Double? = 42,
		length: QuestLength = .long,
		dueDate: Date? = nil,
		difficulty: QuestDifficulty = .easy,
		context: NSManagedObjectContext
	) -> Quest {
		let quest = Quest(context: context)
		quest.questName = name
		quest.questType = type.rawValue
		quest.timeCreated = Date()
		quest.questDescription = description
		quest.questBonusReward = bonusReward
		quest.questBonusExp = bonusExp ?? 0
		quest.length = length.rawValue
		quest.dueDate = Date()
		quest.difficulty = difficulty.rawValue
		quest.isSelected = false
		quest.id = UUID()
		
		save(context: context)
		return quest
	}
}
