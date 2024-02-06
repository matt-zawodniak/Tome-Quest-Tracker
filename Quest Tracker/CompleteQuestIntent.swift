//
//  CompleteQuestIntent.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/11/24.
//

import Foundation
import AppIntents

struct CompleteQuestIntent: AppIntent {
  static let title: LocalizedStringResource = "Complete Quest"

  @Parameter(title: "Quest",
             description: "The name of the quest to be completed.",
             requestValueDialog: IntentDialog("Which quest would you like to complete?"))
  var questName: String

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {

    Quest.completeQuest(name: questName)

    return .result(dialog: "\(questName) marked complete.")
  }
}
