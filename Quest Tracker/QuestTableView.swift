//
//  QuestTableView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/18/23.
//

import SwiftUI

struct QuestTableView: View {
	
	@State var questList: [Quest] = [Quest(questType: "Side Quest", questName: "Do Dishes"), Quest(questType: "Main Quest", questName: "Work on TableView"), Quest(questType: "Daily Quest", questName: "Exercise Ankle", questDescription: "Trace the alphabet, once with each foot."), Quest(questType: "Weekly Quest", questName: "Food Shopping", timeRemaining: 50), Quest(questType: "Daily Quest", questName: "Brush Teeth")]
	
	var body: some View {
		NavigationStack {
			List {
				ForEach($questList, id: \.self) { $quest in
					VStack{
						HStack {
							if quest.questType == "Main Quest" {
								Text("!").foregroundStyle(.red)
							} else if quest.questType == "Side Quest" {
								Text("!")
									.foregroundStyle(.yellow)
							} else if quest.questType == "Daily Quest" {
								Text("!")
									.foregroundStyle(.green)
							} else {
								Text("!")
									.foregroundStyle(.purple)
							}
							Text(quest.questName)
							Spacer()
							if (quest.timeRemaining != nil) {
								Text("Time Remaining")  // make this read off of the quest itself and autoupdate
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
					Button(action: {}, label: {
						Text("Sort By:")
					})
				}
			}
		}
		
	}
}

struct QuestTableView_Previews: PreviewProvider {
	static var previews: some View {
		QuestTableView()
	}
}
