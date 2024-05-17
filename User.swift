//
//  User.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/22/24.
//
//

import Foundation
import SwiftData

@Model public class User {

  var currentExp: Double = 0.0
  var expToLevel: Double = 60
  var level: Int = 1
  var levelingScheme: Int = LevelingSchemes.normal.rawValue

  public init(currentExp: Double, expToLevel: Double, level: Int, levelingScheme: Int) {
    self.currentExp = currentExp
    self.expToLevel = expToLevel
    self.level = level
    self.levelingScheme = levelingScheme
  }
}

extension User: Identifiable {
  func giveExp(quest: Quest, settings: Settings, context: ModelContext) {
    let questExp = quest.type.experience * (quest.questDifficulty.expMultiplier + quest.questLength.expMultiplier)/2

    currentExp += questExp

    if currentExp >= expToLevel {
      levelUp(settings: settings)

      if level % 5 == 0 {
        var milestoneRewardFetchedResults: [Reward]? {
          let request = FetchDescriptor<Reward>(
            predicate: #Predicate { $0.isMilestoneReward == true && $0.isEarned == false },
            sortBy: [SortDescriptor(\.sortId)])

          return (try? context.fetch(request))
        }

        if let milestoneRewardFetchedResults,
           let firstMilestoneReward = milestoneRewardFetchedResults.first {
          createUnearnedCopyOfRewardAtEndOfArray(
            earnedReward: firstMilestoneReward,
            rewardArray: milestoneRewardFetchedResults,
            context: context)

          firstMilestoneReward.isEarned = true

          firstMilestoneReward.dateEarned = Date()
        }
      } else {
        var minorRewardFetchedResults: [Reward]? {
          let request = FetchDescriptor<Reward>(
            predicate: #Predicate { $0.isMilestoneReward == false && $0.isEarned == false},
            sortBy: [SortDescriptor(\.sortId)])

          return (try? context.fetch(request))
        }

        if let minorRewardFetchedResults,
           let firstMinorReward = minorRewardFetchedResults.first {
          createUnearnedCopyOfRewardAtEndOfArray(earnedReward: firstMinorReward,
                                                 rewardArray: minorRewardFetchedResults,
                                                 context: context)

          firstMinorReward.isEarned = true

          firstMinorReward.dateEarned = Date()
        }
      }
    }
  }

  func createUnearnedCopyOfRewardAtEndOfArray(
    earnedReward: Reward,
    rewardArray: [Reward],
    context: ModelContext) {
      let endOfArraySortId = Int((rewardArray.last?.sortId ?? 0) + 1)

      let unearnedCopyofReward = Reward(
        isMilestoneReward: earnedReward.isMilestoneReward,
        name: earnedReward.name,
        sortId: endOfArraySortId)

      context.insert(unearnedCopyofReward)
    }

  static var defaultUser: User = User(currentExp: 0, expToLevel: 60, level: 1, levelingScheme: 0)

  static func fetchFirstOrCreate(context: ModelContext) -> User {
    let userRequest = FetchDescriptor<User>()

    let userData = try? context.fetch(userRequest)

    let user = userData?.first ?? defaultUser

    return user
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

enum LevelingSchemes: Int, CaseIterable, CustomStringConvertible {
  case normal = 0
  case hard = 1

  var description: String {
    switch self {
    case .normal: "Normal"
    case .hard: "Hard"
    }
  }
}
