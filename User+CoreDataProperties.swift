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

  func giveExp(quest: Quest, settings: Settings, context: NSManagedObjectContext) {
    let questExp = quest.type.experience * quest.questDifficulty.expMultiplier * quest.questLength.expMultiplier
    currentExp += questExp
    if currentExp >= expToLevel {
      levelUp(settings: settings)

      if level % 5 == 0 {

        var milestoneRewardFetchedResults: [Reward]? {
          let request = NSFetchRequest<Reward>(entityName: "Reward")
          request.predicate = NSPredicate(format: "isMilestoneReward == true && isEarned == false")
          request.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: true)]
          return (try? context.fetch(request))
        }

        if let milestoneRewardFetchedResults {
          let firstMilestoneReward = milestoneRewardFetchedResults.first
          createUnearnedCopyOfRewardAtEndOfArray(
            earnedReward: firstMilestoneReward!,
            rewardArray: milestoneRewardFetchedResults,
            context: context)
        }
      } else {

        var minorRewardFetchedResults: [Reward]? {
          let request = NSFetchRequest<Reward>(entityName: "Reward")
          request.predicate = NSPredicate(format: "isMilestoneReward == false && isEarned == false")
          request.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: true)]
          return (try? context.fetch(request))
        }

        if let minorRewardFetchedResults {
          if let firstMinorReward = minorRewardFetchedResults.first {
            createUnearnedCopyOfRewardAtEndOfArray(earnedReward: firstMinorReward,
                                                   rewardArray: minorRewardFetchedResults,
                                                   context: context)
          }
        }
      }

      CoreDataController.shared.save(context: context)
    }
  }

  func createUnearnedCopyOfRewardAtEndOfArray(
    earnedReward: Reward,
    rewardArray: [Reward],
    context: NSManagedObjectContext) {

    let copyOfEarnedReward = Reward(context: context)
    copyOfEarnedReward.name = earnedReward.name
    copyOfEarnedReward.isMilestoneReward = earnedReward.isMilestoneReward
    copyOfEarnedReward.isEarned = true
    copyOfEarnedReward.dateEarned = Date.now

    earnedReward.sortId = Int64((rewardArray.last?.sortId ?? 0) + 1)

    CoreDataController.shared.save(context: context)
  }

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

 func levelUp(settings: Settings) {

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
