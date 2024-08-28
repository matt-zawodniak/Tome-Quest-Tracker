//
//  CompleteQuestIntent.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/11/24.
//

import Foundation
import AppIntents
import SwiftData

struct CompleteQuestIntent: AppIntent {
  static let title: LocalizedStringResource = "Complete Quest"

  @Parameter(title: "Quest",
             description: "The name of the quest to be completed.",
             requestValueDialog: IntentDialog("Which quest would you like to complete?"))
  var questName: String

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {
    let context = ModelController.shared.modelContainer.mainContext

    if Quest.findActiveQuestBy(name: questName, context: context) != nil {
      Quest.findByNameAndComplete(name: questName, context: context)

      return .result(dialog: "\(questName) marked complete.")
    } else {
      return .result(dialog: "Sorry, I couldn't find an active quest called \(questName). Use Add Quest to add it.")
    }
  }
}
