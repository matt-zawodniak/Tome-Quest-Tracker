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
    var expToLevel: Double = 0.0
    var level: Int64 = 0
    var levelingScheme: Int64 = 0

  public init(currentExp: Double, expToLevel: Double, level: Int64, levelingScheme: Int64) {
    self.currentExp = currentExp
    self.expToLevel = expToLevel
    self.level = level
    self.levelingScheme = levelingScheme
  }
}

extension User: Identifiable {

  func giveExp(quest: Quest, settings: Settings, context: ModelContext) {
    let questExp = quest.type.experience * quest.questDifficulty.expMultiplier * quest.questLength.expMultiplier
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

        if let milestoneRewardFetchedResults {
          let firstMilestoneReward = milestoneRewardFetchedResults.first
          createUnearnedCopyOfRewardAtEndOfArray(
            earnedReward: firstMilestoneReward!,
            rewardArray: milestoneRewardFetchedResults,
            context: context)

          firstMilestoneReward?.isEarned = true
          firstMilestoneReward?.dateEarned = Date()
        }
      } else {

        var minorRewardFetchedResults: [Reward]? {
          let request = FetchDescriptor<Reward>(
            predicate: #Predicate { $0.isMilestoneReward == false && $0.isEarned == false},
            sortBy: [SortDescriptor(\.sortId)])

          return (try? context.fetch(request))
        }

        if let minorRewardFetchedResults {
          if let firstMinorReward = minorRewardFetchedResults.first {
            createUnearnedCopyOfRewardAtEndOfArray(earnedReward: firstMinorReward,
                                                   rewardArray: minorRewardFetchedResults,
                                                   context: context)

            firstMinorReward.isEarned = true
            firstMinorReward.dateEarned = Date()
          }
        }
      }
    }
  }

  func createUnearnedCopyOfRewardAtEndOfArray(
    earnedReward: Reward,
    rewardArray: [Reward],
    context: ModelContext) {

      let endOfArraySortId = Int64((rewardArray.last?.sortId ?? 0) + 1)

      let unearnedCopyofReward = Reward(
        isMilestoneReward: earnedReward.isMilestoneReward,
        name: earnedReward.name,
        sortId: endOfArraySortId)

      context.insert(unearnedCopyofReward)

  }

  static func fetchFirstOrInitialize(context: ModelContext) -> User {

    var currentUser: User? {
      let request = FetchDescriptor<User>()
      let fetchedUserResults = (try? context.fetch(request)) ?? []
      return fetchedUserResults.first ?? nil
    }

    if let currentUser {

      context.insert(currentUser)
      return currentUser

    } else {
      let newUser = User(currentExp: 0, expToLevel: 100, level: 1, levelingScheme: 0)

      context.insert(newUser)
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