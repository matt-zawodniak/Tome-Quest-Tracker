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
	@State var hasDueDate: Bool
	
	var body: some View {
		
		NavigationStack {
			Form {
				typeSection
				nameSection
				questDescriptionSection
				advancedSettingsSection
			}
			.navigationTitle("Edit Quest")
		}.onDisappear(perform: {
			DataController().editQuest(quest: quest,
									   name: quest.questName ?? "",
									   type: quest.type,
									   description: quest.questDescription,
									   bonusReward: quest.questBonusReward,
									   bonusExp: quest.questBonusExp,
									   length: quest.questLength,
									   dueDate: quest.dueDate,
									   difficulty: quest.questDifficulty,
									   context: moc)
		})
	}
	
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
	
	var nameSection: some View {
		Section(header: Text("Quest Name")) {
			TextField("Quest Name", text: $quest.questName.bound)
		}
	}
	
	var questDescriptionSection: some View {
		Section(header: Text("Quest Description")) {
			TextField("Quest Description (Optional)", text: $quest.questDescription.bound)
		}
	}
	
	var advancedSettingsSection: some View {
		Section(header: Text("Advanced Settings")) {

			HStack {
				Text("Difficulty")
				Picker("Quest Difficulty", selection: $quest.questDifficulty) {
					ForEach(QuestDifficulty.allCases, id: \.self) { difficulty in
						let pickerText = difficulty.description
						Text("\(pickerText)")
					}
				}.pickerStyle(.segmented)
			}
			HStack {
				Text("Time")
				Picker("Quest Length", selection: $quest.questLength) {
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
				Toggle("Date", isOn: $hasDueDate)
					.onChange(of: hasDueDate) {value in
						if value == true {
							quest.dueDate = Date()
						}
						else {
							quest.dueDate = nil
						}
					}
				if hasDueDate {
					Text(quest.dueDate.string)
							DatePicker(
								"" ,
							selection: $quest.dueDate.bound,
							displayedComponents: [.date]
						)
						.datePickerStyle(.graphical)
				}
			}
			// TODO: Adjust Due Date picker, toggle, etc to work with just importing the quest itself.
		}
	}
}



struct EditPopUpMenu_Previews: PreviewProvider {
	
	static var previews: some View {
		let previewContext = DataController().container.viewContext
		let quest = DataController().addPreviewQuest(context: previewContext)
		EditPopUpMenu(quest: quest, hasDueDate: false)
	}
}
