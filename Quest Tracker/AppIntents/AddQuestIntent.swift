//
//  AddQuestIntent.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/9/24.
//

import Foundation
import AppIntents
import SwiftUI
import SwiftData

struct AddQuestIntent: AppIntent {
  static let title: LocalizedStringResource = "Add Quest"

  @Parameter(title: "Quest Name",
             description: "The name of the new quest.",
             requestValueDialog: IntentDialog("What quest would you like to add?"))
  var questName: String

  @Parameter(title: "Quest Type",
             description: "The type of the new quest.",
             requestValueDialog: IntentDialog("What type of quest is it?"))
  var questType: QuestType

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {
    let quest = Quest(
      difficulty: 1,
      id: UUID(),
      isCompleted: false,
      length: 1,
      questName: questName,
      questType: questType.rawValue,
      timeCreated: Date.now)

    ModelController.shared.modelContainer.mainContext.insert(quest)

    return .result(dialog: "Added \(questName) to Quest Tracker.")
  }
}
