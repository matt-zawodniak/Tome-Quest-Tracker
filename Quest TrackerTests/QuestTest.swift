//
//  QuestTest.swift
//  Quest TrackerTests
//
//  Created by Matt Zawodniak on 5/31/24.
//

import XCTest
import SwiftData
@testable import Quest_Tracker

final class QuestTest: XCTestCase {
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

  func testFindActiveQuestsBy() {
    let quest: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "Find", questType: 1, timeCreated: Date())
    context?.insert(quest)

    let foundQuest = Quest.findActiveQuestBy(name: "Find", context: context!)

    XCTAssertEqual(quest, foundQuest)
  }

// Can I tear down at the end of each function? The user is persisting between tests.
  func testCompleteQuest() {
    let questToBeCompleted: Quest = Quest(difficulty: 1,
                                          id: UUID(),
                                          isCompleted: false,
                                          length: 1,
                                          questName: "Test",
                                          questType: 1,
                                          timeCreated: Date())
    context?.insert(questToBeCompleted)

    let user = User.defaultUser
    context?.insert(user)

    Quest.completeQuest(name: questToBeCompleted.questName, context: context!)

    XCTAssert(questToBeCompleted.isCompleted)
    XCTAssertEqual(user.currentExp, questToBeCompleted.completionExp)
  }

  func testCompleteQuestOnlyChoosesOneOfDuplicates() {
    let questToBeCompleted: Quest = Quest(difficulty: 1,
                                          id: UUID(),
                                          isCompleted: false,
                                          length: 1,
                                          questName: "Test",
                                          questType: 1,
                                          timeCreated: Date())
    let duplicate: Quest = Quest(difficulty: 1,
                                   id: UUID(),
                                   isCompleted: false,
                                   length: 1,
                                   questName: "Test",
                                   questType: 1,
                                   timeCreated: Date())
    context?.insert(questToBeCompleted)
    context?.insert(duplicate)

    let user = User.defaultUser
    context?.insert(user)

    Quest.completeQuest(name: questToBeCompleted.questName, context: context!)

    XCTAssert(questToBeCompleted.isCompleted != duplicate.isCompleted)
    XCTAssertEqual(user.currentExp, questToBeCompleted.completionExp)
  }

  func testCompletionExp() {

  }

  func testResetQuests() {

  }

  func testResetDailyQuests() {

  }

  func testResetWeeklyQuests() {

  }

  func testSetDateToDailyResetTime() {

  }

  func setDateToWeeklyResetDate() {

  }

    override func tearDownWithError() throws {
      try context?.delete(model: User.self)
      try context?.delete(model: Quest.self)
      try context?.delete(model: Reward.self)
      try context?.delete(model: Settings.self)
    }
}
