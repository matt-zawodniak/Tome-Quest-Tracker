//
//  Router.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 3/6/24.
//

import SwiftUI

final class Router: ObservableObject {

  public enum Destination: Hashable {

    case newQuestView
    case editingQuestView(quest: Quest)
    case rewards
    case settings
  }

  @Published var navPath = NavigationPath()

  func navigate(to destination: Destination) {
    navPath.append(destination)
  }

  func navigateBack() {
    navPath.removeLast()
  }

  func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
}
