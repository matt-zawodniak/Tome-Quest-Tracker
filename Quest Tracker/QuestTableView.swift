//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
	@ObservedObject var tracker: QuestTrackerViewModel
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var quests: FetchedResults<Quest>
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(quests, id: \.self) { (quest: Quest) in
					
					VStack{
						HStack {
							switch quest.type {
							case .mainQuest : Text("!").foregroundStyle(.red)
							case .sideQuest : Text("!").foregroundStyle(.yellow)
							case .dailyQuest : Text("!").foregroundStyle(.green)
							case .weeklyQuest : Text("!").foregroundStyle(.purple)
							}
							Text(quest.questName ?? "")
							Spacer()
//							if (quest.timeRemaining != nil) {
//								Text(String(quest.timeRemaining!))  // TODO: Calculate this as the difference between due date and current date1
//							}
						}
						.onTapGesture {
							quest.isSelected.toggle()
						}
						
						if quest.isSelected {
							Text(quest.questDescription ?? "")
							
							Text("Quest EXP:")
							HStack {
								Text("Quest Reward:")
								Text(quest.questBonusReward ?? "")
							}
							HStack {

								NavigationLink(destination: EditPopUpMenu(
									quest: quest,
									selectedType: QuestType(rawValue: quest.questType)!,
									questName: quest.questName ?? "",
									questDescription: quest.questDescription ?? "",
									selectedDifficulty: QuestDifficulty(rawValue: quest.difficulty)!,
									selectedLength: QuestLength(rawValue: quest.length as! Int64)!,
									questBonusReward: quest.questBonusReward ?? "",
									hasDueDate: quest.dueDate.exists,
									dueDate: quest.dueDate ?? Date())) {
									Button(action: {
										
									}, label: {
										Text("Edit")
									}
									)
								}
								
								Spacer()
								
								Button(action: {}, label: {Text("Complete")})
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
