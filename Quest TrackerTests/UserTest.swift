//
//  QuestTest.swift
//  Quest TrackerTests
//
//  Created by Matt Zawodniak on 5/28/24.
//

import XCTest
import SwiftData
@testable import Quest_Tracker

final class UserTest: XCTestCase {
  var context: ModelContext?

  override func setUpWithError() throws {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

    guard let container = try? ModelContainer(
      for: Settings.self, Quest.self, User.self, Reward.self,
      configurations: configuration) else {
      XCTFail("Failed to create testing container.")
      return
    }
    context = ModelContext(container)
  }

  func testGiveExp() {
    let user: User = User(currentExp: 0, expToLevel: 60, level: 1, levelingScheme: 0, isLevelingUp: false)
    let quest: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "test", questType: 1, timeCreated: Date())

    user.giveExp(quest: quest, settings: Settings.defaultSettings, context: context!)

    XCTAssertEqual(user.currentExp, quest.completionExp)
  }

  func testGiveExpGivesMinorRewardOnLevelUp() {
    let user: User = User(currentExp: 59, expToLevel: 60, level: 1, levelingScheme: 0, isLevelingUp: false)
    let quest: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "test", questType: 1, timeCreated: Date())

    let minorReward0: Reward = Reward(isMilestoneReward: false, name: "Minor", sortId: 0)
    let minorReward1: Reward = Reward(isMilestoneReward: false, name: "Minor", sortId: 1)
    let minorReward2: Reward = Reward(isMilestoneReward: false, name: "Minor", sortId: 2)

    context?.insert(minorReward0)
    context?.insert(minorReward1)
    context?.insert(minorReward2)

    user.giveExp(quest: quest, settings: Settings.defaultSettings, context: context!)

    XCTAssert(minorReward0.isEarned == true)
    XCTAssert(minorReward1.isEarned == false)
    XCTAssert(minorReward2.isEarned == false)
  }

  func testGiveExpGivesMajorRewardOnLevelUp() {
    let user: User = User(currentExp: 59, expToLevel: 60, level: 4, levelingScheme: 0, isLevelingUp: false)
    context?.insert(user)

    let quest: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "test", questType: 1, timeCreated: Date())
    context?.insert(quest)

    let majorReward0: Reward = Reward(isMilestoneReward: true, name: "Major", sortId: 0)
    let majorReward1: Reward = Reward(isMilestoneReward: true, name: "Major", sortId: 1)
    let majorReward2: Reward = Reward(isMilestoneReward: true, name: "Major", sortId: 2)

    context?.insert(majorReward0)
    context?.insert(majorReward1)
    context?.insert(majorReward2)

    user.giveExp(quest: quest, settings: Settings.defaultSettings, context: context!)

    XCTAssert(majorReward0.isEarned == true)
    XCTAssert(majorReward1.isEarned == false)
    XCTAssert(majorReward2.isEarned == false)
  }

  func testCreateUnearnedCopyOfRewardAtEndOfArray() {
    let user: User = User(currentExp: 59, expToLevel: 60, level: 1, levelingScheme: 0, isLevelingUp: false)

    let earnedReward: Reward = Reward(isMilestoneReward: false, name: "Earned", sortId: 0)
    let test1: Reward = Reward(isMilestoneReward: false, name: "Test 1", sortId: 1)
    let test2: Reward = Reward(isMilestoneReward: false, name: "Test 2", sortId: 2)

    context?.insert(earnedReward)
    context?.insert(test1)
    context?.insert(test2)

    let rewardRequest = FetchDescriptor<Reward>(sortBy: [SortDescriptor(\.sortId)])
    let rewardData = try? context?.fetch(rewardRequest)

    user.createUnearnedCopyOfRewardAtEndOfArray(earnedReward: rewardData!.first!, rewardArray: rewardData!, context: context!)

    let rewardDataAfterCopy = try? context?.fetch(rewardRequest)

    XCTAssertEqual(rewardDataAfterCopy?.last!.name, "Earned")
    XCTAssertEqual(rewardDataAfterCopy?.last!.sortId, 3)
  }

  func testFetchFirstOrCreateFetches() {
    let testUser: User = User(currentExp: 60, expToLevel: 60, level: 2, levelingScheme: 0, isLevelingUp: false)
    context?.insert(testUser)

    let fetchedUser: User = User.fetchFirstOrCreate(context: context!)

    XCTAssertEqual(testUser, fetchedUser)
  }

  func testFetchFirstOrCreateCreates() {
    let user = User.fetchFirstOrCreate(context: context!)

    XCTAssertEqual(user.level, User.defaultUser.level)
    XCTAssertEqual(user.currentExp, User.defaultUser.currentExp)
    XCTAssertEqual(user.expToLevel, User.defaultUser.expToLevel)
    XCTAssertEqual(user.isLevelingUp, User.defaultUser.isLevelingUp)
    XCTAssertEqual(user.levelingScheme, User.defaultUser.levelingScheme)
  }

  func testLevelUpExact() {
    let testUser: User = User(currentExp: 60, expToLevel: 60, level: 2, levelingScheme: 0, isLevelingUp: true)
    let projectedUser: User = User(currentExp: 0, expToLevel: 60, level: 3, levelingScheme: 0, isLevelingUp: true)

    testUser.levelUp()

    XCTAssertEqual(testUser.currentExp, projectedUser.currentExp)
    XCTAssertEqual(testUser.expToLevel, projectedUser.expToLevel)
    XCTAssertEqual(testUser.level, projectedUser.level)
  }

  func testLevelUpWithOverflow() {
    let testUser: User = User(currentExp: 100, expToLevel: 60, level: 2, levelingScheme: 0, isLevelingUp: true)
    let projectedUser: User = User(currentExp: 40, expToLevel: 60, level: 3, levelingScheme: 0, isLevelingUp: true)

    testUser.levelUp()

    XCTAssertEqual(testUser.currentExp, projectedUser.currentExp)
    XCTAssertEqual(testUser.expToLevel, projectedUser.expToLevel)
    XCTAssertEqual(testUser.level, projectedUser.level)
  }

  func testLevelUpWithLevelingScheme() {
    let testUser: User = User(currentExp: 100, expToLevel: 60, level: 2, levelingScheme: 1, isLevelingUp: true)
    let projectedUser: User = User(currentExp: 40, expToLevel: 80, level: 3, levelingScheme: 1, isLevelingUp: true)

    testUser.levelUp()

    XCTAssertEqual(testUser.currentExp, projectedUser.currentExp)
    XCTAssertEqual(testUser.expToLevel, projectedUser.expToLevel)
    XCTAssertEqual(testUser.level, projectedUser.level)
    XCTAssertEqual(testUser.levelingScheme, projectedUser.levelingScheme)
  }

    override func tearDownWithError() throws {
      try context?.delete(model: User.self)
      try context?.delete(model: Quest.self)
      try context?.delete(model: Reward.self)
      try context?.delete(model: Settings.self)
    }
}
