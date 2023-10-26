//
//  DataController.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/5/23.
//

import CoreData
import Foundation
import SwiftUI

class DataController: ObservableObject {
	let container = NSPersistentContainer(name: "DataModel")
	
	init() {
		container.loadPersistentStores {description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
		fetchFirstOrCreate(context: container.viewContext)
	}
	
	
	func fetchFirstOrCreate(context: NSManagedObjectContext) {
		var userSettings: [Settings] {
			let request = NSFetchRequest<Settings>(entityName: "Settings")
			
			return (try? container.viewContext.fetch(request)) ?? []
		}
		
		if userSettings.isEmpty {
			let defaultSettings = Settings(context: context)
			
			var components = DateComponents()
			components.day = 1
			components.second = -1
			
			defaultSettings.dayOfTheWeek = 2
			defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))
			defaultSettings.dailyResetWarning = false
			defaultSettings.weeklyResetWarning = false
			defaultSettings.levelingScheme = 2
			
			save(context: context)
		}
		else {
			//						container.viewContext.delete(userSettings.first!) // Use this to delete the Settings
			//						save(context: context)
			//
			//					print(userSettings.first?.time as Any)
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
	
	func setDailyQuestResetDate(quest: Quest, resetDate: Settings, context: NSManagedObjectContext) {
		var components = DateComponents()
		components.hour = Calendar.current.component(.hour, from: resetDate.time!)
		components.minute = Calendar.current.component(.minute, from: resetDate.time!)
		components.second = Calendar.current.component(.second, from: resetDate.time!)
		
		let nextResetTime = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
		quest.dueDate = nextResetTime
	}
	
	func setWeeklyQuestResetDate(quest: Quest, resetDate: Settings, context: NSManagedObjectContext) {
		
		var components = DateComponents()
		components.weekday = Int(resetDate.dayOfTheWeek)
		components.hour = Calendar.current.component(.hour, from: resetDate.time!)
		components.minute = Calendar.current.component(.minute, from: resetDate.time!)
		
		let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
		
		quest.dueDate = nextResetDay
	}
	
	func editResetDayAndTime(resetDate: Settings, dayOfTheWeek: Int64?, resetTime: Date?, context: NSManagedObjectContext) {
		
		if let dayOfTheWeek {
			resetDate.dayOfTheWeek = dayOfTheWeek
		}
		if let resetTime {
			resetDate.time = resetTime
		}
		
		save(context: context)
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
	
	func loadPreviewSettings(context: NSManagedObjectContext) -> Settings {
		let defaultSettings = Settings(context: context)
		
		var components = DateComponents()
		components.day = 1
		components.second = -1
		
		defaultSettings.dayOfTheWeek = 3
		defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))
		defaultSettings.dailyResetWarning = true
		defaultSettings.weeklyResetWarning = false
		defaultSettings.levelingScheme = 2
		
		save(context: context)
		return defaultSettings
	}
}
