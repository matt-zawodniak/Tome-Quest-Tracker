//
//  User+CoreDataProperties.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/1/23.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var level: Int64
    @NSManaged public var currentExp: Double
    @NSManaged public var expToLevel: Double

}

extension User: Identifiable {

  func giveExp(quest: Quest, settings: Settings) {
    let questExp = quest.type.experience * quest.questDifficulty.expMultiplier * quest.questLength.expMultiplier
    currentExp += questExp
    if currentExp >= expToLevel {
      levelUp(settings: settings)
    }
  }

  func levelUp(settings: Settings) {
    level += 1
    currentExp -= expToLevel
    if settings.levelingScheme == 1 {
      expToLevel += 20
    }
  }
}