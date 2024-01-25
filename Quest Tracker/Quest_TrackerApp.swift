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

  var container: ModelContainer = {

    do {
      let container = ModelController.shared.modelContainer

      var settingsFetchDescriptor = FetchDescriptor<Settings>()
      settingsFetchDescriptor.fetchLimit = 1

      var userFetchDescriptor = FetchDescriptor<User>()
      userFetchDescriptor.fetchLimit = 1

      guard try container.mainContext.fetch(
        settingsFetchDescriptor).count == 0 && container.mainContext.fetch(userFetchDescriptor).count == 0 else {
        return container }

      container.mainContext.insert(Settings.defaultSettings)
      container.mainContext.insert(User.defaultUser)

      return container
    } catch {
      fatalError("Failed to initialize container.")
    }

  }()

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
