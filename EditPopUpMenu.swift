//
//  EditPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI

struct EditPopUpMenu: View {
	@Environment(\.managedObjectContext) var moc
	
	@ObservedObject var quest: Quest
	
	var body: some View {
		NavigationStack {
			Form {
				typeSection
				nameSection
				questDescriptionSection
				advancedSettingsSection
			}
			.navigationTitle("Edit Quest")
		}
	}
	
	@State var selectedType: QuestType
	
	var typeSection: some View {
		Section {
			Picker("Quest Type", selection: $quest.type) {
				ForEach(QuestType.allCases, id: \.self) {questType in
					let menuText = questType.description
					Text("\(menuText)")
				}
			}
		}
	}
	
	@State var questName: String
	
	var nameSection: some View {
		Section(header: Text("Quest Name")) {
			TextField("Quest Name", text: $questName)
		}
	}
	
	@State var questDescription: String
	
	var questDescriptionSection: some View {
		Section(header: Text("Quest Description")) {
			TextField("Quest Description (Optional)", text: $questDescription)
		}
	}
	
	@State var selectedDifficulty: QuestDifficulty
	@State var selectedLength: QuestLength
	@State var questBonusReward: String
	@State var hasDueDate: Bool
	@State var dueDate: Date
	
	var advancedSettingsSection: some View {
		
		Section(header: Text("Advanced Settings")) {
			HStack {
				Text("Difficulty")
				Picker("Quest Difficulty", selection: $selectedDifficulty) {
					ForEach(QuestDifficulty.allCases, id: \.self) { difficulty in
						let pickerText = difficulty.description
						Text("\(pickerText)")
					}
				}.pickerStyle(.segmented)
			}
			HStack {
				Text("Time")
				Picker("Quest Length", selection: $selectedLength) {
					ForEach(QuestLength.allCases, id: \.self) { length in
						let pickerText = length.description
						Text("\(pickerText)")
					}
				}.pickerStyle(.segmented)
			}
			HStack {
				Text("Bonus Reward:")
				TextField("Add optional bonus here", text: $questBonusReward)
			}
			VStack {
				HStack {
					Text("Due Date?")
					Picker("Due Date", selection: $hasDueDate) {
						Text("No").tag(false)
						Text("Yes").tag(true)
					}.pickerStyle(.segmented)
				}
				if hasDueDate {
					DatePicker(
						"",
						selection: $dueDate,
						displayedComponents: [.date, .hourAndMinute]
					)
				}
			}
		}
	}
}
//
//
//struct EditPopUpMenu_Previews: PreviewProvider {
//	static var previews: some View {
//		let sampleQuest = Quest()
//
//		EditPopUpMenu(quest: sampleQuest, selectedType: .dailyQuest, questName: "Exercise Ankle", questDescription: "", selectedDifficulty: .average, selectedLength: .long, questBonusReward: "", hasDueDate: false, dueDate: Date())
//	}
//}
