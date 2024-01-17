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
  @NSManaged public var levelingScheme: Int64

}

extension User: Identifiable {

  static func fetchFirstOrInitialize(context: NSManagedObjectContext) -> User {

    var currentUser: User? {
      let request = User.fetchRequest()
      let fetchedUserResults = (try? context.fetch(request)) ?? []
      return fetchedUserResults.first ?? nil
    }

    if let currentUser {
      return currentUser
    } else {
      let newUser = User(context: context)
      newUser.currentExp = 0
      newUser.expToLevel = 100
      newUser.level = 1
      newUser.levelingScheme = 0

      return newUser
    }
  }

  func giveExp(quest: Quest) {
    let questExp = quest.type.experience * quest.questDifficulty.expMultiplier * quest.questLength.expMultiplier
    currentExp += questExp
    if currentExp >= expToLevel {
      levelUp()
    }
  }

  func levelUp() {
    level += 1
    currentExp -= expToLevel
    if levelingScheme == 1 {
      expToLevel += 20
    }
  }

  var scaling: LevelingSchemes {
    get {
      return LevelingSchemes(rawValue: self.levelingScheme)!
    }
    set {
      self.levelingScheme = newValue.rawValue
    }
  }
}

enum LevelingSchemes: Int64, CaseIterable, CustomStringConvertible {
  case normal = 0
  case hard = 1

  var description: String {
    switch self {
    case .normal: "Normal"
    case .hard: "Hard"
    }
  }
}
