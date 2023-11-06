//
//  Quest+CoreDataProperties.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/6/23.
//
//

import Foundation
import CoreData


extension Quest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quest> {
        return NSFetchRequest<Quest>(entityName: "Quest")
    }

    @NSManaged public var difficulty: Int64
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isSelected: Bool
    @NSManaged public var length: Int64
    @NSManaged public var questBonusExp: Double
    @NSManaged public var questBonusReward: String?
    @NSManaged public var questDescription: String?
    @NSManaged public var questName: String?
    @NSManaged public var questType: Int64
    @NSManaged public var timeCreated: Date?

}

extension Quest : Identifiable {
	var type: QuestType {
		get {
			return QuestType(rawValue: self.questType)!
		}
		set {
			self.questType = newValue.rawValue
		}
	}
	var questLength: QuestLength {
		get {
			return QuestLength(rawValue: self.length)!
		}
		set {
			self.length = newValue.rawValue
		}
	}
	var questDifficulty: QuestDifficulty {
		get {
			return QuestDifficulty(rawValue: self.difficulty)!
		}
		set {
			self.difficulty = newValue.rawValue
		}
	}
	func setDateToDailyResetTime(quest: Quest, settings: Settings) {
		var components = DateComponents()
		components.hour = Calendar.current.component(.hour, from: settings.time!)
		components.minute = Calendar.current.component(.minute, from: settings.time!)
		components.second = Calendar.current.component(.second, from: settings.time!)
		
		let nextResetTime = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
		quest.dueDate = nextResetTime
	}
	func setDateToWeeklyResetDate(quest: Quest, settings: Settings) {

		var components = DateComponents()
		components.weekday = Int(settings.dayOfTheWeek)
		components.hour = Calendar.current.component(.hour, from: settings.time!)
		components.minute = Calendar.current.component(.minute, from: settings.time!)
		
		let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
		
		quest.dueDate = nextResetDay
	}
}
