//
//  Quest_TrackerApp.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/14/23.
//

import SwiftUI

@main
struct Quest_TrackerApp: App {
	@StateObject var dataController = DataController()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
