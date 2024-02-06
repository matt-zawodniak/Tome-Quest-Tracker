//
//  ModelController.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/25/24.
//

import Foundation
import SwiftData

class ModelController {
  static let shared = ModelController()

  var modelContainer: ModelContainer

  init() {
    do {
      modelContainer = try ModelContainer(for: Settings.self, Quest.self, User.self, Reward.self)
    } catch {
      fatalError("Failed to configure SwiftData container.")
    }
  }

}
