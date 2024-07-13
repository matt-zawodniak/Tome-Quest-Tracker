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
    let questToFind: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "Find", questType: 1, timeCreated: Date())
    context?.insert(questToFind)

    let _: Quest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "False", questType: 1, timeCreated: Date())

    let foundQuest = Quest.findActiveQuestBy(name: "Find", context: context!)

    XCTAssertEqual(questToFind, foundQuest)
  }

  func testCompleteQuest() {
    let questToBeCompleted: Quest = Quest(difficulty: 1,
                                          id: UUID(),
                                          isCompleted: false,
                                          length: 1,
                                          questName: "Test",
                                          questType: 1,
                                          timeCreated: Date())
    context?.insert(questToBeCompleted)

    let user = User.fetchFirstOrCreate(context: context!)
    user.currentExp = 0

    Quest.findByNameAndComplete(name: questToBeCompleted.questName, context: context!)

    XCTAssert(questToBeCompleted.isCompleted)
    XCTAssertEqual(user.currentExp, questToBeCompleted.completionExp)
  }

  func testCompleteQuestOnlyChoosesOneOfDuplicates() {
    let quest: Quest = Quest(difficulty: 1,
                                          id: UUID(),
                                          isCompleted: false,
                                          length: 1,
                                          questName: "Unique",
                                          questType: 1,
                                          timeCreated: Date())
    let duplicate: Quest = Quest(difficulty: 1,
                                   id: UUID(),
                                   isCompleted: false,
                                   length: 1,
                                   questName: "Unique",
                                   questType: 1,
                                   timeCreated: Date())
    context?.insert(quest)
    context?.insert(duplicate)

    let user = User.fetchFirstOrCreate(context: context!)
    user.currentExp = 0

    Quest.findByNameAndComplete(name: quest.questName, context: context!)

    XCTAssert(quest.isCompleted != duplicate.isCompleted)
    XCTAssertEqual(user.currentExp, quest.completionExp)
  }

  func testCompletionExp() {
    let mainQuest = Quest(difficulty: 1, id: UUID(), isCompleted: false, length: 1, questName: "Main", questType: 0, timeCreated: Date())

    XCTAssertEqual(mainQuest.completionExp,
                   mainQuest.type.experience * (mainQuest.questDifficulty.expMultiplier + mainQuest.questLength.expMultiplier)/2)
  }

  func testResetQuests() {
    let daily1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let daily2 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let weekly1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let weekly2 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))

    context?.insert(daily1)
    context?.insert(daily2)
    context?.insert(weekly1)
    context?.insert(weekly2)

    var timeComponents = DateComponents()
    timeComponents.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    timeComponents.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)
    timeComponents.second = Calendar.current.component(.second, from: Settings.defaultSettings.time)

    let nextResetTime = Calendar.current.nextDate(after: Date.now, matching: timeComponents, matchingPolicy: .nextTime)

    var dayComponents = DateComponents()
    dayComponents.weekday = Int(Settings.defaultSettings.dayOfTheWeek)
    dayComponents.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    dayComponents.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)

    let nextResetDay = Calendar.current.nextDate(after: Date(), matching: dayComponents, matchingPolicy: .nextTime)

    Quest.resetQuests(settings: Settings.defaultSettings, context: context!)

    XCTAssert(daily1.isCompleted == false && daily1.dueDate == nextResetTime)
    XCTAssert(daily2.isCompleted == false && daily2.dueDate == nextResetTime)
    XCTAssert(weekly1.isCompleted == false && weekly1.dueDate == nextResetDay)
    XCTAssert(weekly2.isCompleted == false && weekly2.dueDate == nextResetDay)
  }

  func testResetDailyQuests() {
    let daily1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let daily2 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let weekly = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))

    context?.insert(daily1)
    context?.insert(daily2)
    context?.insert(weekly)

    var components = DateComponents()
    components.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    components.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)
    components.second = Calendar.current.component(.second, from: Settings.defaultSettings.time)

    let nextResetTime = Calendar.current.nextDate(after: Date.now, matching: components, matchingPolicy: .nextTime)

    Quest.resetDailyQuests(settings: Settings.defaultSettings, context: context!)

    XCTAssert(daily1.isCompleted == false && daily1.dueDate == nextResetTime)
    XCTAssert(daily2.isCompleted == false && daily2.dueDate == nextResetTime)
    XCTAssert(weekly.isCompleted == true && weekly.dueDate == nil)
  }

  func testResetWeeklyQuests() {
    let daily1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let daily2 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let weekly1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))
    let weekly2 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))

    context?.insert(daily1)
    context?.insert(daily2)
    context?.insert(weekly1)
    context?.insert(weekly2)

    var components = DateComponents()
    components.weekday = Int(Settings.defaultSettings.dayOfTheWeek)
    components.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    components.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)

    let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)

    Quest.resetWeeklyQuests(settings: Settings.defaultSettings, context: context!)

    XCTAssert(daily1.isCompleted == true && daily1.dueDate == nil)
    XCTAssert(daily2.isCompleted == true && daily2.dueDate == nil)
    XCTAssert(weekly1.isCompleted == false && weekly1.dueDate == nextResetDay)
    XCTAssert(weekly2.isCompleted == false && weekly2.dueDate == nextResetDay)
  }

  func testSetDateToDailyResetTime() {
    let daily1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "daily",
                       questType: QuestType.dailyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))

    var components = DateComponents()
    components.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    components.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)
    components.second = Calendar.current.component(.second, from: Settings.defaultSettings.time)

    let nextResetTime = Calendar.current.nextDate(after: Date.now, matching: components, matchingPolicy: .nextTime)

    daily1.setDateToDailyResetTime(settings: Settings.defaultSettings)

    XCTAssertEqual(daily1.dueDate, nextResetTime)
  }

  func setDateToWeeklyResetDate() {
    let weekly1 = Quest(difficulty: 1,
                       id: UUID(),
                       isCompleted: true,
                       length: 1,
                       questName: "Weekly",
                       questType: QuestType.weeklyQuest.rawValue,
                       timeCompleted: Date(timeIntervalSince1970: 0),
                       timeCreated: Date(timeIntervalSince1970: 0))

    var components = DateComponents()
    components.weekday = Int(Settings.defaultSettings.dayOfTheWeek)
    components.hour = Calendar.current.component(.hour, from: Settings.defaultSettings.time)
    components.minute = Calendar.current.component(.minute, from: Settings.defaultSettings.time)

    let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)

    weekly1.setDateToWeeklyResetDate(settings: Settings.defaultSettings)

    XCTAssertEqual(weekly1.dueDate, nextResetDay)
  }

    override func tearDownWithError() throws {
      try context?.delete(model: User.self)
      try context?.delete(model: Quest.self)
      try context?.delete(model: Reward.self)
      try context?.delete(model: Settings.self)
    }
}
