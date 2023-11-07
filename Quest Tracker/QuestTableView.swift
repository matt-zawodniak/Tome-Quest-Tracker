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
	@FetchRequest(sortDescriptors: [SortDescriptor(\.timeCreated, order: .reverse)]) var quests: FetchedResults<Quest>
	@FetchRequest(sortDescriptors: []) var settings: FetchedResults<Settings>
	@State var sortType: QuestSortDescriptor = .timeCreated
	@State var newQuestView: Bool = false
	
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
								
								NavigationLink(destination: QuestView(
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
					.swipeActions(edge: .leading) { Button(role: .destructive) {
						managedObjectContext.delete(quest)
						DataController().save(context: managedObjectContext)
					} label: {
						Label("Delete", systemImage: "trash")
					}
					}
				}
				
				HStack {
						Button(
							action: {
								newQuestView = true
							},
							label: {
								Image(systemName: "plus.circle")
							})
					}
				HStack {
									Spacer()
									NavigationLink(destination: SettingsView(settings: settings.first!)) {
										
										Button(action: {}, label: {
											Text("Settings")
										})
									}
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
			.navigationDestination(isPresented: $newQuestView) {
							QuestView(quest: Quest.defaultQuest(context: managedObjectContext), hasDueDate: false)
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
