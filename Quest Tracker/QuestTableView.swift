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
	@FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)], predicate: NSPredicate(format: "isCompleted == false")) var quests: FetchedResults<Quest>
  @State var sortType: QuestSortDescriptor = .timeCreated

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
					.swipeActions(edge: .trailing) {
						Button(role: .destructive) {
						CoreDataController().deleteQuest(quest: quest, context: managedObjectContext)
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
					.swipeActions(edge: .leading) { Button() {
						CoreDataController().completeQuest(quest: quest, context: managedObjectContext)
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
    HStack {
     Spacer()
     NavigationLink(destination: CompletedQuestView()) {
      
      Button(
       action: {
       },
       label: {
        Text("Completed Quests")
       })
     }
     Spacer()
    }
			}
			.navigationTitle("Quest Tracker").navigationBarTitleDisplayMode(.inline)
			.onChange(of: sortType) {_ in
				setSortType()
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					HStack {
						Text("Sort:")
						Picker("", selection: $sortType) {
							ForEach(QuestSortDescriptor.allCases, id: \.self) {
								Text($0.description)
							}
							
						}
					}
				}
			}
		}
	}
	func setSortType() {
		switch sortType {
		case .dueDate: quests.sortDescriptors = [SortDescriptor(\Quest.dueDate)]
		case .oldest: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .forward)]
		case .timeCreated: quests.sortDescriptors = [SortDescriptor(\Quest.timeCreated, order: .reverse)]
		case .questName: quests.sortDescriptors = [SortDescriptor(\Quest.questName, comparator: .lexical)]
		case .questType: quests.sortDescriptors = [SortDescriptor(\Quest.questType)]
		}
	}
}

struct QuestTableView_Previews: PreviewProvider {
	static var previews: some View {
		QuestTableView(tracker: QuestTrackerViewModel())
	}
}
