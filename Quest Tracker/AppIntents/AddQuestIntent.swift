//
//  AddQuestIntent.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/9/24.
//

import Foundation
import AppIntents
import SwiftUI

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
    let context = CoreDataController.shared.container.viewContext
    let quest = Quest(context: context)
    quest.questName = questName
    quest.questType = questType.rawValue
    quest.difficulty = 1
    quest.length = 1
    quest.id = UUID()
    quest.isSelected = false
    quest.isCompleted = false

    CoreDataController.shared.save(context: context)

    return .result(dialog: "Added quest with Siri.")
  }
}
