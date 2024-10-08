//
//  PreviewSampleData.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/8/24.
//

import Foundation
import SwiftData

class PreviewSampleData {

  @MainActor
  static var container: ModelContainer = {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

      let container = try ModelContainer(
        for: Settings.self, Quest.self, User.self, Reward.self,
        configurations: configuration)

      let previewUser: User = User(currentExp: 27, expToLevel: 80, level: 4, levelingScheme: 1, isLevelingUp: false, purchasedRemoveAds: false)

      container.mainContext.insert(previewUser)

      let previewSettings: Settings = Settings.fetchFirstOrCreate(context: container.mainContext)

      let previewQuests: [Quest] = [
        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Main",
              questType: 0,
              timeCreated: Date.now),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Side",
              questType: 1,
              timeCreated: Date.now),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Daily",
              questType: 2,
              timeCreated: Date.now),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Weekly",
              questType: 3,
              timeCreated: Date.now),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Second Main",
              questType: 0,
              timeCreated: Date.now),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              length: 1,
              questName: "Second Side",
              questType: 1,
              timeCreated: Date.now)
      ]

      previewQuests.forEach {
        container.mainContext.insert($0)
      }

      let previewRewards: [Reward] = [
        Reward(isMilestoneReward: false, name: "Minor", sortId: 1),
        Reward(isMilestoneReward: true, name: "Milestone", sortId: 1)
      ]

      previewRewards.forEach {
        container.mainContext.insert($0)
      }

      return container
    } catch {
      fatalError("Failed to create preview container.")
    }
  }()

  static var previewUser: User = User(currentExp: 27, expToLevel: 80, level: 4, levelingScheme: 1, isLevelingUp: false, purchasedRemoveAds: false)

  static var previewSettings: Settings = Settings(
    dayOfTheWeek: 3,
    time: Date(),
    weeklyResetWarning: false
  )

  static var previewQuest: Quest = Quest(
    difficulty: 1,
    id: UUID(),
    isCompleted: false,
    length: 1,
    questName: "Main",
    questType: 0,
    timeCreated: Date.now
  )

  static var previewQuests: [Quest] = [
    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Main",
          questType: 0,
          timeCreated: Date.now),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Side",
          questType: 1,
          timeCreated: Date.now),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Daily",
          questType: 2,
          timeCreated: Date.now),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Weekly",
          questType: 3,
          timeCreated: Date.now),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Second Main",
          questType: 0,
          timeCreated: Date.now),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          length: 1,
          questName: "Second Side",
          questType: 1,
          timeCreated: Date.now)
  ]
}
