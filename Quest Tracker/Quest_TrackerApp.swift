//
//  Quest_TrackerApp.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/14/23.
//

import SwiftUI
import AppIntents
import SwiftData
import Sentry
import GoogleMobileAds

@main
@MainActor
struct Quest_TrackerApp: App {

  var container: ModelContainer = ModelController.shared.modelContainer

  init() {
    SentrySDK.start { options in
      options.dsn = "https://eb6119b7fd055ed8924ce9146e1c2556@o4506910806769664.ingest.us.sentry.io/4506910808342528"
    }

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    QuestTrackerShortcuts.updateAppShortcutParameters()
  }

  var body: some Scene {
    WindowGroup {
      MainView()
    }
    .modelContainer(container)
  }
}
