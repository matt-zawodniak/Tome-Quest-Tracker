//
//  ModelController.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/25/24.
//

import Foundation
import SwiftData

@MainActor
class ModelController {
  static let shared = ModelController()

  let modelContainer: ModelContainer = {
    do {
          let container = try ModelContainer(for: Settings.self, Quest.self, User.self, Reward.self)

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
}
