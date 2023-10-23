//
//  NewQuestPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/7/23.
//

import SwiftUI

struct NewQuestPopUpMenu: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	@FetchRequest(sortDescriptors: []) var resetDates: FetchedResults<Settings>
		
	@State var selectedType: QuestType = .mainQuest
	@State var questName: String = ""
	@State var questDescription: String = ""
	@State var selectedDifficulty: QuestDifficulty = .average
	@State var selectedLength: QuestLength = .average
	@State var questBonusReward: String = ""
	@State var hasDueDate: Bool = false
	@State var dueDate: Date?
	@State var datePickerIsExpanded: Bool = false
	
	var body: some View {
		NavigationStack {
			Form {
				typeSection
				nameSection
				questDescriptionSection
				advancedSettingsSection
			}
			.navigationTitle("New Quest")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						var selectedDate: Date? {
							if hasDueDate {
								return dueDate
							}
							else {
								return nil
							}
						}
						
						DataController().addNewQuest(
							name: questName,
							type: selectedType,
							description: questDescription,
							bonusReward: questBonusReward,
							bonusExp: 0,
							length: selectedLength,
							dueDate: selectedDate,
							difficulty: selectedDifficulty,
							context: moc
						)
						dismiss()
					}
				}
			}
		}
	}
	
	var typeSection: some View {
		Section {
			Picker("Quest Type", selection: $selectedType) {
				ForEach(QuestType.allCases, id: \.self) {questType in
					let menuText = questType.description
					Text("\(menuText)")
				}.onChange(of: selectedType) { value in
					if value == .dailyQuest {
						let resetDate = resetDates.first!
						var components = DateComponents()
						components.hour = Calendar.current.component(.hour, from: resetDate.time ?? Date())
						components.minute = Calendar.current.component(.minute, from: resetDate.time ?? Date())
						components.second = Calendar.current.component(.second, from: resetDate.time ?? Date())
						
						let nextResetTime = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
						dueDate = nextResetTime
						hasDueDate = true
					}
					else if value == .weeklyQuest {
						let resetDate = resetDates.first!

						var components = DateComponents()
						components.weekday = Int(resetDate.dayOfTheWeek)
						components.hour = Calendar.current.component(.hour, from: resetDate.time ?? Date())
						components.minute = Calendar.current.component(.minute, from: resetDate.time ?? Date())
						
						let nextResetDay = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
						
						dueDate = nextResetDay
						hasDueDate = true
					}
				}
			}
		}
	}
	
	var nameSection: some View {
		Section(header: Text("Quest Name")) {
			TextField("Quest Name", text: $questName)
		}
	}
	
	var questDescriptionSection: some View {
		Section(header: Text("Quest Description")) {
			TextField("Quest Description (Optional)", text: $questDescription)
		}
	}
	
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
				TextField("Add optional bonus here", text: $questBonusReward)
			}
			dueDateView
			
		}
	}
	var dueDateView: some View {
		VStack {
			switch selectedType {
			case .weeklyQuest:
				HStack {
					Text("Weekly Reset:")
					Text(dueDate.dayOnly)
					Spacer()
					Toggle("", isOn: $hasDueDate)
						.onChange(of: hasDueDate) { value in
							if value == true {
								dueDate = Date()
							}
							else {
								dueDate = nil
							}
						}
						.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
				}
			case .dailyQuest:
				HStack {
					Text("Daily Reset:")
					Text(dueDate.timeOnly)
					Spacer()
					Toggle("", isOn: $hasDueDate)
						.onChange(of: hasDueDate) { value in
							if value == true {
								dueDate = Date()
							}
							else {
								dueDate = nil
							}
						}
						.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
				}
			default:
				HStack {
					Text("Due:")
						.onTapGesture {
							if hasDueDate {
								datePickerIsExpanded.toggle()
							}
						}
					Text(dueDate.dayOnly)
						.onTapGesture {
							if hasDueDate {
								datePickerIsExpanded.toggle()
							}
						}
					Text(dueDate.timeOnly)
						.onTapGesture {
							if hasDueDate {
								datePickerIsExpanded.toggle()
							}
						}
					Spacer()
					Toggle("", isOn: $hasDueDate)
						.onChange(of: hasDueDate) { value in
							if value == true {
								dueDate = Date()
							}
							else {
								dueDate = nil
							}
							datePickerIsExpanded = hasDueDate
						}
				}
				
				if hasDueDate, datePickerIsExpanded == true {
					DatePicker(
						"" ,
						selection: $dueDate.bound,
						displayedComponents: [.date, .hourAndMinute]
					)
					.datePickerStyle(.graphical)
				}
			}
		}
	}
}

struct NewQuestPopUpMenu_Previews: PreviewProvider {
	static var previews: some View {
		
		NewQuestPopUpMenu(selectedType: .mainQuest, questName: "Test", questDescription: "Test", selectedDifficulty: .average, selectedLength: .average, questBonusReward: "Test", hasDueDate: false, dueDate: Date())
	}
}
