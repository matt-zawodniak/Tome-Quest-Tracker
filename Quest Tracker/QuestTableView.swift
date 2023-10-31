//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
	@ObservedObject var tracker: QuestTrackerViewModel
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isCompleted == false") ) var quests: FetchedResults<Quest>
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(quests, id: \.self) { (quest: Quest) in
					VStack {
						HStack {
							switch quest.type {
							case .mainQuest : Text("!").foregroundStyle(.red)
							case .sideQuest : Text("!").foregroundStyle(.yellow)
							case .dailyQuest : Text("!").foregroundStyle(.green)
							case .weeklyQuest : Text("!").foregroundStyle(.purple)
							}
							Text(quest.questName ?? "")
							Spacer()
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
									quest: quest, hasDueDate: quest.dueDate.exists)) {
										Button(action: {
											
										}, label: {
											Text("Edit")
										}
										)
									}
								
								Spacer()
								
								Button(action: {
								},
									   label: {Text("Complete")})
							}
							
						}
						
					}
					.swipeActions(edge: .leading) { 
						Button(role: .destructive) {
						DataController().deleteQuest(quest: quest, context: managedObjectContext)
					} label: {
						Label("Delete", systemImage: "trash")
					}
						NavigationLink(destination: EditPopUpMenu(
							quest: quest, hasDueDate: quest.dueDate.exists)) {
								Button(action: {
									
								}, label: {
									Text("Edit")
								}
								)
							}
					}
					.swipeActions(edge: .trailing) { Button() {
						DataController().completeQuest(quest: quest, context: managedObjectContext)
					} label: {
						Image(systemName: "checkmark")
					}
						.tint(.green)					}
				}
				
				HStack {
					Spacer()
					NavigationLink(destination: NewQuestPopUpMenu()) {
						
						Button(
							action: {
							},
							label: {
								Image(systemName: "plus.circle")
							})
					}
					Spacer()
				}
			}
			.navigationTitle("Quest Tracker").navigationBarTitleDisplayMode(.inline)
		}
		
	}
}

struct QuestTableView_Previews: PreviewProvider {
	static var previews: some View {
		QuestTableView(tracker: QuestTrackerViewModel())
	}
}
