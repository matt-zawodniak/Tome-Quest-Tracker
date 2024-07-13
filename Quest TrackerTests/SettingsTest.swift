//
//  Settings.swift
//  Quest TrackerTests
//
//  Created by Matt Zawodniak on 5/27/24.
//

import SwiftData
import XCTest
@testable import Quest_Tracker

final class SettingsTest: XCTestCase {
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

  func testSetNewResetTime() {
    let settings = Settings.fetchFirstOrCreate(context: context!)

    var oldResetComponents = DateComponents()
    oldResetComponents.hour = 0
    oldResetComponents.minute = 0
    oldResetComponents.second = 0

    let oldResetTime = Calendar.current.date(byAdding: oldResetComponents, to: Calendar.current.startOfDay(for: Date()))!

    let nextResetTime = Calendar.current.date(byAdding: .day, value: 1, to: oldResetTime)

    settings.time = oldResetTime

    settings.setNewResetTime()

    XCTAssertEqual(nextResetTime, settings.time)
  }

  func testRefreshDailyReset() {
    let settings = Settings.fetchFirstOrCreate(context: context!)

    var components = DateComponents()
    components.day = 1

    let newDailyReset = Calendar.current.date(byAdding: components, to: settings.time)

    settings.refreshDailyReset()

    XCTAssertEqual(newDailyReset, settings.time)
  }

  func testDefaultResetTime() {
    var components = DateComponents()
    components.day = 1
    components.second = -1

    let testResetTime = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))!

    XCTAssertEqual(testResetTime, Settings.defaultResetTime)
  }

  func testFetchFirstOrCreateFetches() {
    var testResetTimeComponents = DateComponents()
    testResetTimeComponents.hour = 5
    testResetTimeComponents.minute = 30
    testResetTimeComponents.second = 07

    let testResetTime = Calendar.current.date(byAdding: testResetTimeComponents, to: Calendar.current.startOfDay(for: Date()))!

    let settings = Settings(dayOfTheWeek: 5, time: testResetTime, weeklyResetWarning: true)
    context?.insert(settings)

    let fetchedSettings: Settings = Settings.fetchFirstOrCreate(context: context!)

    XCTAssertEqual(settings, fetchedSettings)
  }
}
