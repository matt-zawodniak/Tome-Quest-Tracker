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
      phrases: ["Add a quest to \(.applicationName)",
                "Add a \(.applicationName)",
                "Add \(.applicationName)",
                "New \(.applicationName)",
                "Create \(.applicationName)"
               ],
      shortTitle: "Add Quest",
      systemImageName: "plus.circle"
    )

    AppShortcut(
      intent: CompleteQuestIntent(),
      phrases: ["Complete quest in \(.applicationName).",
                "Complete \(.applicationName).",
                "Complete a \(.applicationName).",
                "Mark \(.applicationName) as complete.",
                "Mark a \(.applicationName) as complete."
               ],
      shortTitle: "Complete Quest",
      systemImageName: "checkmark"
    )
  }
}
