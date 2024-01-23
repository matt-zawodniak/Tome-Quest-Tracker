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
struct Quest_TrackerApp: App {

  init() {

    QuestTrackerShortcuts.updateAppShortcutParameters()

  }

  var body: some Scene {
    WindowGroup {
      QuestListView(tracker: QuestTrackerViewModel())
    }
    .modelContainer(for: [Settings.self, Quest.self, User.self, Reward.self])
  }
}
