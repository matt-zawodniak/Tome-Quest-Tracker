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
}

#Preview {
	EditPopUpMenu(quest: .constant(Quest(questType: .dailyQuest, questName: "Exercise Ankle", timeRemaining: 50, questDescription: "Trace the alphabet, once with each foot.", timeCreated: Date(timeIntervalSince1970: 7))), selectedType: .dailyQuest)
}
