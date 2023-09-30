//
//  EditPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI

struct EditPopUpMenu: View {
	
	@Binding var quest: Quest
	
	var body: some View {
		NavigationStack {
			Form {
				typeSection
				nameSection
				questDescriptionSection
				advancedSettingsSection
			}
			.navigationTitle("Edit Quest")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button(
						action: {
							quest.questName = questName
							quest.questType = selectedType
							quest.questDescription = questDescription
							quest.difficulty = selectedDifficulty
							quest.length = selectedLength
							quest.questBonusReward = questBonusReward
							if hasDueDate == true {
								quest.dueDate = dueDate
							} else {
								quest.dueDate = nil
							}
						},
						label: {Text("Save")}
					)
				}
				
			}
		}
	}
	
	@State var selectedType: QuestType
	
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


#Preview {
	EditPopUpMenu(quest: .constant(Quest(questType: .dailyQuest, questName: "Exercise Ankle", timeRemaining: 50, questDescription: "Trace the alphabet, once with each foot.", timeCreated: Date(timeIntervalSince1970: 7))), selectedType: .dailyQuest, questName: "Exercise Ankle", questDescription: "", selectedDifficulty: .average, selectedLength: .long, questBonusReward: "", hasDueDate: false, dueDate: Date())
}
