//
//  Quest_TrackerApp.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/14/23.
//

import SwiftUI
import AppIntents
import SwiftData

@main
@MainActor
struct Quest_TrackerApp: App {

  var container: ModelContainer = ModelController.shared.modelContainer

  init() {
    QuestTrackerShortcuts.updateAppShortcutParameters()
  }

  var body: some Scene {
    WindowGroup {
      QuestListView(tracker: QuestTrackerViewModel())
    }
    .modelContainer(container)
  }
}
