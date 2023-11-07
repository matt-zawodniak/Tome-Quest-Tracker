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
	
	static func defaultQuest(context: NSManagedObjectContext) -> Quest {
		let quest = Quest(context: context)
		quest.questName = ""
		quest.type = .mainQuest
		quest.difficulty = 1
		quest.length = 1
		
		return quest
	}
}
