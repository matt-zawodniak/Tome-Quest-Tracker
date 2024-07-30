//
//  Quest_TrackerUITests.swift
//  Quest TrackerUITests
//
//  Created by Matt Zawodniak on 7/19/24.
//

import XCTest
import SwiftData

final class SnapshotSetup: XCTestCase {
  var context: ModelContext?

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testExample() throws {
    let app = XCUIApplication()
    app.launch()

    let collectionViewsQuery = app.collectionViews

    let giftImage = app.images["Gift"]
    giftImage.tap()
    let manageRewardsText = collectionViewsQuery.staticTexts["Manage Rewards"]
    XCTAssert(manageRewardsText.waitForExistence(timeout: 30))

    collectionViewsQuery.staticTexts["Manage Rewards"].tap()

    let addRewardStaticText = collectionViewsQuery.staticTexts["Add Reward"]
    XCTAssert(addRewardStaticText.waitForExistence(timeout: 30))

    addRewardStaticText.tap()

    let rewardNameTextField = collectionViewsQuery.textFields["Reward Name"]
    XCTAssert(rewardNameTextField.waitForExistence(timeout: 30))

    rewardNameTextField.tap()
    rewardNameTextField.typeText("Ice Cream")

    let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
    backButton.tap()
    XCTAssert(collectionViewsQuery.staticTexts["Ice Cream"].waitForExistence(timeout: 30))

    addRewardStaticText.tap()
    rewardNameTextField.tap()
    rewardNameTextField.typeText("Dinner Out")
    collectionViewsQuery.buttons["Milestone"].tap()
    backButton.tap()
    XCTAssert(collectionViewsQuery.staticTexts["Dinner Out"].waitForExistence(timeout: 30))

    backButton.tap()

    let nextLevelStaticText = collectionViewsQuery.staticTexts["Next Level"]
    let start = nextLevelStaticText.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
    let finish = nextLevelStaticText.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 50.0))
    start.press(forDuration: 0.5, thenDragTo: finish)
    XCTAssert(manageRewardsText.exists == false)

    app.images["plus.square.dashed"].tap()

    let questNameTextField = collectionViewsQuery.textFields["Quest Name"]
    XCTAssert(questNameTextField.waitForExistence(timeout: 30))

    questNameTextField.tap()
    questNameTextField.typeText("Download Tome")
    app.buttons["Create"].tap()
    XCTAssert(collectionViewsQuery.staticTexts["Create"].exists == false)
    XCTAssert(collectionViewsQuery.staticTexts["Download Tome"].waitForExistence(timeout: 30))

    let questName = collectionViewsQuery.staticTexts["Download Tome"]
    questName.tap()
    XCTAssert(app.buttons["Confirm"].waitForExistence(timeout: 30))
  }

  override func tearDownWithError() throws {
  }
}
