//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
	@ObservedObject var tracker: QuestTrackerViewModel
	
	var body: some View {
		NavigationStack {
			List {
				ForEach($tracker.trackerModel.questList, id: \.self) { $quest in
					
					VStack{
						HStack {
							switch quest.questType {
							case .mainQuest : Text("!").foregroundStyle(.red)
							case .sideQuest : Text("!").foregroundStyle(.yellow)
							case .dailyQuest : Text("!").foregroundStyle(.green)
							case .weeklyQuest : Text("!").foregroundStyle(.purple)
							}
							Text(quest.questName)
							Spacer()
							if (quest.timeRemaining != nil) {
								Text(String(quest.timeRemaining!))  // TODO: This needs to actually be hours and minutes eventually
							}
						}
						.onTapGesture {
							quest.isSelected.toggle()
						}
						// TODO: Let you tap anywhere to expand the view instead of just on text
						
						if quest.isSelected {
							Text(quest.questDescription ?? "")
							
							Text("Quest EXP:")
							HStack {
								Text("Quest Reward:")
								Text(quest.questBonusReward ?? "")
							}
							HStack {
								Text("Edit").foregroundStyle(.blue)
									.background(
										NavigationLink("", destination: EditPopUpMenu(
											quest: $quest,
											selectedType: quest.questType,
											questName: quest.questName,
											questDescription: quest.questDescription ?? "",
											selectedDifficulty: quest.difficulty,
											selectedLength: quest.length,
											questBonusReward: quest.questBonusReward ?? "",
											hasDueDate: quest.dueDate.exists,
											dueDate: quest.dueDate ?? Date()))
										.opacity(0)
										.buttonStyle(BorderlessButtonStyle())
									)
								// TODO: Fix so only clicking on edit navigates instead of entire expanded description
								Spacer()
								
								Button(action: {
									tracker.completeQuest(quest: quest)
									print(tracker.trackerModel.completedQuests)
								}, label: {Text("Complete")}).buttonStyle(BorderlessButtonStyle())
							}
							
						}
						
					}
					
					
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Menu {
						Button {
							tracker.sortByType()
						} label: {Text("Quest Type")}
						Button {
							tracker.sortByName()
						} label: {Text("Quest Name")}
						Button {
							tracker.sortByRecent()
						} label: {Text("Recent")}
						Button {
							tracker.sortByTimeRemainingAscending()
						} label: {Text("Time Remaining (ascending)")}
						Button {
							tracker.sortByTimeRemainingDescending()
						} label: {Text("Time Remaining (descending)")}
					} label: {Text("Sort by:")}
				}
			}
		}
		
	}
}

struct QuestTableView_Previews: PreviewProvider {
	static var previews: some View {
		QuestTableView(tracker: QuestTrackerViewModel())
	}
}
