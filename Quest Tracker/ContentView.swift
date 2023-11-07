//
//  ContentView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		QuestListView(tracker: QuestTrackerViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
