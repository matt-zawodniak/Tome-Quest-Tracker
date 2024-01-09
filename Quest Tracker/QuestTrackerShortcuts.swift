//
//  QuestTrackerShorcuts.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/9/24.
//

import Foundation
import AppIntents

struct QuestTrackerShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: AddQuestIntent(),
      phrases: ["Add a quest to \(.applicationName)"]
      )
  }
}
