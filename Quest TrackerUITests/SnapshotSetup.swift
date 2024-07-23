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

//    let giftImage = app.images["Gift"]
//    giftImage.tap()
//
    let collectionViewsQuery = app.collectionViews
//    collectionViewsQuery.staticTexts["Manage Rewards"].tap()
//
//    let addRewardStaticText = collectionViewsQuery.staticTexts["Add Reward"]
//    addRewardStaticText.tap()
//
//    let rewardNameTextField = collectionViewsQuery.textFields["Reward Name"]
//    rewardNameTextField.tap()
//    rewardNameTextField.typeText("Ice Cream")
//
//    let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
//    backButton.tap()
//    addRewardStaticText.tap()
//    rewardNameTextField.tap()
//    rewardNameTextField.typeText("Dinner Out")
//    collectionViewsQuery.buttons["Milestone"].tap()
//    backButton.tap()
//    backButton.tap()
//
//    let nextLevelStaticText = collectionViewsQuery.staticTexts["Next Level"]
//    let start = nextLevelStaticText.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
//    let finish = nextLevelStaticText.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 50.0))
//    start.press(forDuration: 0.5, thenDragTo: finish)
//
//    app.images["plus.square.dashed"].tap()
//
    let questNameTextField = collectionViewsQuery.textFields["Quest Name"]
//    questNameTextField.tap()
//    questNameTextField.typeText("Download Tome")
//    app.buttons["Create"].tap()

    let plusImage = app.images["plus.square.dashed"]
    plusImage.tap()

    collectionViewsQuery.staticTexts["Main Quest"].tap()
    let dailyText = app.staticTexts["Daily Quest"]
    XCTAssert(dailyText.waitForExistence(timeout: 30))
    collectionViewsQuery.staticTexts["Daily Quest"].tap()
    questNameTextField.tap()
    questNameTextField.typeText("Exercise")
    app.buttons["Create"].tap()

//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Walk the Dog")
//    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Daily Quest")
//    app.buttons["Create"].tap()
//
//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Food Shopping")
//    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Weekly Quest")
//    app.buttons["Create"].tap()
//
//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Take Out Trash")
//    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Weekly Quest")
//    app.buttons["Create"].tap()
//
//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Clean Garage")
//    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Side Quest")
//    app.buttons["Create"].tap()
//
//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Laundry")
//    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Weekly Quest")
//    app.buttons["Create"].tap()
//
//    app.images["plus.square.dashed"].tap()
//
//    questNameTextField.tap()
//    questNameTextField.typeText("Make Car Service Appt")
//    app.buttons["Create"].tap()
//
//    collectionViewsQuery.staticTexts["Download Tome"].swipeRight()
//
//    let selectedButton = collectionViewsQuery.buttons["Selected"]
//    selectedButton.tap()
//
//    let exerciseStaticText = collectionViewsQuery.staticTexts["Exercise"]
//    exerciseStaticText.swipeLeft()
//
//    collectionViewsQuery.staticTexts["Daily Quests"].tap()
//
//    let foodShoppingStaticText = collectionViewsQuery.staticTexts["Food Shopping"]
//    foodShoppingStaticText.swipeRight()
//    selectedButton.tap()
//
//    giftImage.tap()
//    collectionViewsQuery.buttons["Claim Reward!"].tap()
//    start.press(forDuration: 0.5, thenDragTo: finish)
//
//    app.images["gearshape"].tap()
  }

  override func tearDownWithError() throws {
  }
}
