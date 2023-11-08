//
//  EditPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI
import CoreData

struct QuestView: View {
 @Environment(\.managedObjectContext) var managedObjectContext
 
 @StateObject var quest: Quest
 @State var hasDueDate: Bool = false
 @State var datePickerIsExpanded: Bool = false
 @State var userSettings: Settings
 
 var body: some View {
  NavigationStack {
   Form {
    nameSection
    typeSection
    questDescriptionSection
    advancedSettingsSection
   }
  }.onDisappear(
   perform: {
    quest.isSelected = false
    DataController().save(context: managedObjectContext)
   }
  )
 }
 
 var typeSection: some View {
  Section {
   Picker("Quest Type", selection: $quest.type) {
    ForEach(QuestType.allCases, id: \.self) {questType in
     let menuText = questType.description
     Text("\(menuText)")
    }.onChange(of: quest.type) { value in
     if value == .dailyQuest {
      quest.setDateToDailyResetTime(quest: quest, settings: userSettings)
      hasDueDate = true
     }
     else if value == .weeklyQuest {
      quest.setDateToWeeklyResetDate(quest: quest, settings: userSettings)
      hasDueDate = true
     }
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
   dueDateView
  }
 }
 
 var dueDateView: some View {
  VStack {
   switch quest.type {
   case .weeklyQuest:
    HStack {
     Text("Weekly Reset:")
     Text(quest.dueDate.dayOnly)
     Spacer()
     Toggle("", isOn: $hasDueDate)
      .onChange(of: hasDueDate) { _ in
       quest.setDateToWeeklyResetDate(quest: quest, settings: userSettings)
      }
      .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
   case .dailyQuest:
    HStack {
     Text("Daily Reset:")
     Text(quest.dueDate.timeOnly)
     Spacer()
     Toggle("", isOn: $hasDueDate)
      .onChange(of: hasDueDate) { _ in
       quest.setDateToDailyResetTime(quest: quest, settings: userSettings)
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
     Text(quest.dueDate.dateOnly)
      .onTapGesture {
       if hasDueDate {
        datePickerIsExpanded.toggle()
       }
      }
     Text(quest.dueDate.timeOnly)
      .onTapGesture {
       if hasDueDate {
        datePickerIsExpanded.toggle()
       }
      }
     Spacer()
     Toggle("", isOn: $hasDueDate)
      .onChange(of: hasDueDate) { value in
       QuestTrackerViewModel().trackerModel.setDate(quest: quest, value: value)
       datePickerIsExpanded = hasDueDate
      }
    }
    
    if hasDueDate, datePickerIsExpanded == true {
     DatePicker(
      "" ,
      selection: $quest.dueDate.bound,
      displayedComponents: [.date, .hourAndMinute]
     )
     .datePickerStyle(.graphical)
    }
   }
  }
 }
}	

struct QuestView_Previews: PreviewProvider {
 static func loadPreviewSettings(context: NSManagedObjectContext) -> Settings {
  let defaultSettings = Settings(context: context)
  
  var components = DateComponents()
  components.day = 1
  components.second = -1
  
  defaultSettings.dayOfTheWeek = 3
  defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))
  defaultSettings.dailyResetWarning = true
  defaultSettings.weeklyResetWarning = false
  defaultSettings.levelingScheme = 2
  
  return defaultSettings
 }
 static var previews: some View {
  let previewContext = DataController().container.viewContext
  let quest = DataController().addPreviewQuest(context: previewContext)
  let settings = loadPreviewSettings(context: previewContext)
  QuestView(quest: quest, hasDueDate: true, datePickerIsExpanded: false, userSettings: settings)
 }
}
