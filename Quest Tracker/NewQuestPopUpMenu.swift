//
//  NewQuestPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/7/23.
//

import SwiftUI

struct NewQuestPopUpMenu: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	
	@State var selectedType: QuestType = .mainQuest
	@State var questName: String = ""
	@State var questDescription: String = ""
	@State var selectedDifficulty: QuestDifficulty = .average
	@State var selectedLength: QuestLength = .average
	@State var questBonusReward: String = ""
	@State var hasDueDate: Bool = false
	@State var dueDate: Date = Date()
	
	var body: some View {
		NavigationStack {
			Form {
				typeSection
				nameSection
				questDescriptionSection
				advancedSettingsSection
			}
			.navigationTitle("New Quest")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						var selectedDate: Date? {
							if hasDueDate {
								return dueDate
							}
							else {
								return nil
							}
						}
						
						DataController().addNewQuest(
							name: questName,
							type: selectedType,
							description: questDescription,
							bonusReward: questBonusReward,
							bonusExp: 0, // TODO: Add Bonus EXP to form
							length: selectedLength,
							dueDate: selectedDate,
							difficulty: selectedDifficulty,
							context: moc
						)
						dismiss()
					}
				}
			}
		}
	}
	
	var typeSection: some View {
		Section {
			Picker("Quest Type", selection: $selectedType) {
				ForEach(QuestType.allCases, id: \.self) {questType in
					let menuText = questType.description
					Text("\(menuText)")
				}
			}
		}
	}
	
	
	var nameSection: some View {
		Section(header: Text("Quest Name")) {
			TextField("Quest Name", text: $questName)
		}
	}
	
	
	var questDescriptionSection: some View {
		Section(header: Text("Quest Description")) {
			TextField("Quest Description (Optional)", text: $questDescription)
		}
	}
	
	
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
					Toggle(isOn: $hasDueDate, label: {
						Text("Due Date:")
					})
				if hasDueDate {
					DatePicker(
						"",
						selection: $dueDate,
						displayedComponents: [.date, .hourAndMinute]
					)
				}
			}
			// TODO: Make Due Date reflect Reminder App structure
		}
	}
}

#Preview {
	NewQuestPopUpMenu(selectedType: .mainQuest, questName: "Test", questDescription: "Test", selectedDifficulty: .average, selectedLength: .average, questBonusReward: "Test", hasDueDate: false, dueDate: Date())
}
