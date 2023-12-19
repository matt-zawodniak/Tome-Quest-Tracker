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

  func giveExp(quest: Quest, settings: Settings, context: NSManagedObjectContext) {
    let questExp = quest.type.experience * quest.questDifficulty.expMultiplier * quest.questLength.expMultiplier
    currentExp += questExp
    if currentExp >= expToLevel {
      levelUp(settings: settings)

      if level % 5 == 0 {

        var milestoneRewardFetchedResults: [Reward] {
          let request = NSFetchRequest<Reward>(entityName: "Reward")
          request.predicate = NSPredicate(format: "isMilestoneReward == true && isEarned == false")
          request.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: true)]
          return (try? context.fetch(request)) ?? []
        }

        if milestoneRewardFetchedResults != [] {
          let firstMilestoneReward = milestoneRewardFetchedResults.first
          makeEarnedCopyOfRewardAndSendToEndOfArray(
            earnedReward: firstMilestoneReward!,
            rewardArray: milestoneRewardFetchedResults,
            context: context)
        }
      } else {

        var minorRewardFetchedResults: [Reward] {
          let request = NSFetchRequest<Reward>(entityName: "Reward")
          request.predicate = NSPredicate(format: "isMilestoneReward == false && isEarned == false")
          request.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: true)]
          return (try? context.fetch(request)) ?? []
        }

        if minorRewardFetchedResults != [] {
          let firstMinorReward = minorRewardFetchedResults.first
          makeEarnedCopyOfRewardAndSendToEndOfArray(earnedReward: firstMinorReward!,
                                                    rewardArray: minorRewardFetchedResults,
                                                    context: context)
        }
      }

      CoreDataController.shared.save(context: context)
    }
  }

  func makeEarnedCopyOfRewardAndSendToEndOfArray(
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

  func levelUp(settings: Settings) {
    level += 1
    currentExp -= expToLevel
    if settings.levelingScheme == 1 {
      expToLevel += 20
    }
  }
}
