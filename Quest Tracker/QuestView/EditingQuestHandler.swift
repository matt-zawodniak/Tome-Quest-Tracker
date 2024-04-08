//
//  EditingQuestHandler.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 4/8/24.
//

import SwiftUI
import Foundation

class EditingQuestHandler: ObservableObject, Observable {
  @Published var questToShowDetails: Quest?
  @Published var showingQuestDetails: Bool = false

}
