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
	
	@ObservedObject var settings: Settings
	var body: some View {
		NavigationStack {
				List {
					VStack {
						HStack {
							Text("Daily Reset Time:")
							DatePicker("", selection: $settings.time.bound, displayedComponents: .hourAndMinute)
						}
						HStack {
							Text("Daily Reset Warning")
							Spacer()
							Toggle("", isOn: $settings.dailyResetWarning)
						}
					}
					VStack {
						HStack {
							Text("Weekly Reset Day:")
							Picker("", selection: $settings.day) {
								ForEach(DayOfTheWeek.allCases, id: \.self) { day in
									let pickerText = day.description
									Text("\(pickerText)")
								}
							}
						}
						HStack {
							Text("Weekly Reset Warning:")
							Spacer()
							Toggle("", isOn: $settings.weeklyResetWarning)
						}
					}
					HStack {
						Text("Level Scaling:")
						Picker("", selection: $settings.scaling) {
							ForEach(LevelingSchemes.allCases, id: \.self) { scheme in
								let pickerText = scheme.description
								Text("\(pickerText)")
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
			}
		.onDisappear(perform: {
			DataController().save(context: moc)
		})
	}
}

struct SettingsView_Previews: PreviewProvider {
	
	static var previews: some View {
		let previewContext = DataController().container.viewContext
		let settings = DataController().loadPreviewSettings(context: previewContext)
		SettingsView(settings: settings)
	}
}
