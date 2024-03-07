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

      let previewUser: User = User(currentExp: 27, expToLevel: 80, level: 4, levelingScheme: 1)

      container.mainContext.insert(previewUser)

      let previewSettings: Settings = Settings.fetchFirstOrInitialize(context: container.mainContext)

      let previewQuests: [Quest] = [
        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Main",
              questType: 0),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Side",
              questType: 1),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Daily",
              questType: 2),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Weekly",
              questType: 3),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Second Main",
              questType: 0),

        Quest(difficulty: 1,
              id: UUID(),
              isCompleted: false,
              isSelected: false,
              length: 1,
              questBonusExp: 0,
              questName: "Second Side",
              questType: 1)
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

  static var previewUser: User = User(currentExp: 27, expToLevel: 80, level: 4, levelingScheme: 1)

  static var previewSettings: Settings = Settings(
    dayOfTheWeek: 3,
    time: Date(),
    dailyResetWarning: false,
    weeklyResetWarning: false
  )

  static var previewQuest: Quest = Quest(
    difficulty: 1,
    id: UUID(),
    isCompleted: false,
    isSelected: false,
    length: 1,
    questBonusExp: 0,
    questName: "Main",
    questType: 0
  )

  static var previewQuests: [Quest] = [
    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Main",
          questType: 0),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Side",
          questType: 1),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Daily",
          questType: 2),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Weekly",
          questType: 3),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Second Main",
          questType: 0),

    Quest(difficulty: 1,
          id: UUID(),
          isCompleted: false,
          isSelected: false,
          length: 1,
          questBonusExp: 0,
          questName: "Second Side",
          questType: 1)
  ]

}
