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

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Quest> {
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
	
	static func defaultQuest(context: NSManagedObjectContext) -> Quest {
		let quest = Quest(context: context)
		quest.questName = ""
		quest.type = .mainQuest
		quest.difficulty = 1
		quest.length = 1
		
		return quest
	}
}

enum QuestType: Int64, CaseIterable, CustomStringConvertible {
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

