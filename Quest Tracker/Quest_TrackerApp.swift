//
//  Quest_TrackerApp.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/14/23.
//

import SwiftUI

@main
struct Quest_TrackerApp: App {
	@StateObject private var dataController = DataController()
	
    var body: some Scene {
        WindowGroup {
			QuestListView(tracker: QuestTrackerViewModel())
				.environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
