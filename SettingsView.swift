//
//  SettingsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/25/23.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var quests: FetchedResults<Quest>
	@FetchRequest(sortDescriptors: []) var settings: FetchedResults<Settings>
	
	@State var dailyResetTime: Date = Date()
	@State var weeklyResetDay: DayOfTheWeek = .tuesday
	@State var dailyResetWarning: Bool = false
	@State var weeklyResetWarning: Bool = false
	@State var levelingScheme: LevelingSchemes = .linear
	
	var body: some View {
		NavigationStack {
				List {
					VStack {
						HStack {
							Text("Daily Reset Time:")
							DatePicker("", selection: $dailyResetTime, displayedComponents: .hourAndMinute)
						}
						HStack {
							Text("Daily Reset Warning")
							Spacer()
							Toggle("", isOn: $dailyResetWarning)
						}
					}
					VStack {
						HStack {
							Text("Weekly Reset Day:")
							Picker("", selection: $weeklyResetDay) {
								ForEach(DayOfTheWeek.allCases, id: \.self) {
									Text($0.description)
								}
							}
						}
						HStack {
							Text("Weekly Reset Warning:")
							Spacer()
							Toggle("", isOn: $weeklyResetWarning)
						}
					}
					HStack {
						Text("Level Scaling:")
						Picker("", selection: $levelingScheme) {
							ForEach(LevelingSchemes.allCases, id: \.self) {
								Text($0.description)
							}
						}
					}
					HStack {
						Spacer()
						
						Button("Manage Rewards") {
							
						}.buttonStyle(.borderedProminent)
						Spacer()
					}
				}
				.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
				Button("Manage Rewards") {
					
				}.buttonStyle(.borderedProminent)
			}
		}
    }

#Preview {
    SettingsView()
}
