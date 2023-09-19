//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
	
	@State var questList: [Quest] = [
		Quest(questType: .sideQuest, questName: "Do Dishes", timeCreated: Date(timeIntervalSince1970: 1)),
		Quest(questType: .mainQuest, questName: "Work on TableView", timeCreated: Date(timeIntervalSince1970: 5)),
		Quest(questType: .dailyQuest, questName: "Exercise Ankle", timeRemaining: 50, questDescription: "Trace the alphabet, once with each foot.", timeCreated: Date(timeIntervalSince1970: 7)),
		Quest(questType: .weeklyQuest, questName: "Food Shopping", timeRemaining: 500, timeCreated: Date(timeIntervalSince1970: 9)),
		Quest(questType: .dailyQuest, questName: "Brush Teeth", timeRemaining: 50, timeCreated: Date(timeIntervalSince1970: 11))
	]
	
	var body: some View {
		NavigationStack {
			List {
				ForEach($questList, id: \.self) { $quest in
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
								Text(String(quest.timeRemaining!))  // This needs to actually be hours and minutes eventually
							}
						}
						
						if quest.isSelected {
							Text(quest.questDescription ?? "")
							
							Text("Quest EXP:")
							
							Text("Quest Reward:")
							HStack {
								Button(action: {}, label: {Text("Edit")})
								Spacer()
								Button(action: {}, label: {Text("Complete")})
							}
							
						}
						
					}
					.onTapGesture {
						quest.isSelected.toggle()
					}
					
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Menu {
						Button {
							sortByType()
						} label: {Text("Quest Type")}
						Button {
							sortByName()
						} label: {Text("Quest Name")}
						Button {
							sortByRecent()
						} label: {Text("Recent")}
						Button {
							sortByTimeRemainingAscending()
						} label: {Text("Time Remaining (ascending)")}
						Button {
							sortByTimeRemainingDescending()
						} label: {Text("Time Remaining (descending)")}
					} label: {Text("Sort by:")}
				}
			}
		}
		
	}
	
	func sortByType() {
		questList = questList.sorted {
			$0.questType.rawValue < $1.questType.rawValue
		}
	}
	
	func sortByName() {
		questList = questList.sorted {
			$0.questName < $1.questName
		}
	}
	
	func sortByRecent() {
		questList = questList.sorted {
			$0.timeCreated < $1.timeCreated
		}
	}
	
	func sortByTimeRemainingAscending() {
		questList = questList.sorted {
			$0.timeRemaining ?? 999999999999 < $1.timeRemaining ?? 99999999999
		}
	}
	
	func sortByTimeRemainingDescending() {
		questList = questList.sorted {
			$0.timeRemaining ?? 0 > $1.timeRemaining ?? 0
		}
	}
}

struct QuestTableView_Previews: PreviewProvider {
	static var previews: some View {
		QuestTableView()
	}
}
