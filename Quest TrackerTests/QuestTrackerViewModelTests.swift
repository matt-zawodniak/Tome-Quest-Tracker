//
//  Quest_TrackerTests.swift
//  Quest TrackerTests
//
//  Created by Matt Zawodniak on 5/24/24.
//

import XCTest
@testable import Quest_Tracker

final class QuestTrackerViewModelTests: XCTestCase {

  func testSortDescriptorFromSortType() {
    let dueDate = QuestSortDescriptor.dueDate
    let oldest = QuestSortDescriptor.oldest
    let timeCreated = QuestSortDescriptor.timeCreated
    let questName = QuestSortDescriptor.questName
    let questType = QuestSortDescriptor.questType

    let dueDateDescriptor = QuestTrackerViewModel().sortDescriptorFromSortType(sortType: dueDate)
    let oldestDescriptor = QuestTrackerViewModel().sortDescriptorFromSortType(sortType: oldest)
    let timeCreatedDescriptor = QuestTrackerViewModel().sortDescriptorFromSortType(sortType: timeCreated)
    let questNameDescriptor = QuestTrackerViewModel().sortDescriptorFromSortType(sortType: questName)
    let questTypeDescriptor = QuestTrackerViewModel().sortDescriptorFromSortType(sortType: questType)

    let expectedDueDateDescriptor = SortDescriptor(\Quest.dueDate, order: .reverse)
    let expectedOldestDescriptor = SortDescriptor(\Quest.timeCreated, order: .forward)
    let expectedTimeCreatedDescriptor = SortDescriptor(\Quest.timeCreated, order: .reverse)
    let expectedQuestNameDescriptor = SortDescriptor(\Quest.questName, comparator: .lexical)
    let expectedQuestTypeDescriptor = SortDescriptor(\Quest.questType)

    XCTAssertEqual(dueDateDescriptor, expectedDueDateDescriptor)
    XCTAssertEqual(oldestDescriptor, expectedOldestDescriptor)
    XCTAssertEqual(timeCreatedDescriptor, expectedTimeCreatedDescriptor)
    XCTAssertEqual(questNameDescriptor, expectedQuestNameDescriptor)
    XCTAssertEqual(questTypeDescriptor, expectedQuestTypeDescriptor)
  }
}
