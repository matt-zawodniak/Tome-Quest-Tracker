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

    let container = try? ModelContainer(for: Quest.self)
    let context = ModelContext(container!)

    Quest.completeQuest(name: questName, context: context)

    return .result(dialog: "\(questName) marked complete.")
  }
}
