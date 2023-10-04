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
				// TODO:			difficultySection?
				// TODO:			bonusRewardSection
				// TODO:			dueDateSection
			}
			.navigationTitle("Edit Quest")
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
	
	var nameSection: some View {
		Section(header: Text("Quest Name")) {
			TextField("Quest Name", text: $quest.questName)
		}
	}
	
	var questDescriptionSection: some View {
		Section(header: Text("Quest Description")) {
			TextField("Quest Description (Optional)", text: $quest.questDescription.bound)
		}
	}
	
	@State var selectedDifficulty: QuestDifficulty
	@State var selectedLength: QuestLength
	@State var date = Date()
	@State var hasDueDate: Bool
	
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
				TextField("Add optional bonus here", text: $quest.questBonusReward.bound)
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
						selection: $date,
						displayedComponents: [.date, .hourAndMinute]
					)
				}
			}
		}
	}
}

#Preview {
	EditPopUpMenu(quest: .constant(Quest(questType: .dailyQuest, questName: "Exercise Ankle", timeRemaining: 50, questDescription: "Trace the alphabet, once with each foot.", timeCreated: Date(timeIntervalSince1970: 7))), selectedType: .dailyQuest, selectedDifficulty: .average, selectedLength: .long, hasDueDate: true)
}
