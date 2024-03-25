//
//  EditPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI
import CoreData

struct QuestView: View {

  @Environment(\.modelContext) var modelContext

  @State var quest: Quest
  @State var hasDueDate: Bool = false
  @State var datePickerIsExpanded: Bool = false
  @State var settings: Settings

  var body: some View {
    List {
      nameSection
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

      typeSection
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

      questDescriptionSection
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

      advancedSettingsSection
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

    }
    .onDisappear(
      perform: {
        if quest.questName.count > 0 {
          quest.isSelected = false

          quest.isCompleted = false

          modelContext.insert(quest)
        }
      }
    )
    .padding()
    .listStyle(.grouped)
    .listRowSeparator(.hidden)
    .listRowSpacing(5)
    .scrollContentBackground(.hidden)
    .foregroundStyle(.cyan)
  }

  var typeSection: some View {
    Section {
      Picker("Quest Type", selection: $quest.type) {
        ForEach(QuestType.allCases, id: \.self) {questType in
          let menuText = questType.description

          Text("\(menuText)")
        }
        .onChange(of: quest.type) {
          if quest.type == .dailyQuest {
            quest.setDateToDailyResetTime(settings: settings)

            hasDueDate = true
          } else if quest.type == .weeklyQuest {
            quest.setDateToWeeklyResetDate(settings: settings)

            hasDueDate = true
          }
        }
      }
    }
  }

  var nameSection: some View {
    Section(header: Text("Quest Name")) {
      TextField("Quest Name", text: $quest.questName)
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
        }
        .pickerStyle(.segmented)
      }

      HStack {
        Text("Time")

        Picker("Quest Length", selection: $quest.questLength) {
          ForEach(QuestLength.allCases, id: \.self) { length in
            let pickerText = length.description

            Text("\(pickerText)")
          }
        }
        .pickerStyle(.segmented)
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
            .onChange(of: hasDueDate) {
              quest.setDateToWeeklyResetDate(settings: settings)
            }
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
      case .dailyQuest:
        HStack {
          Text("Daily Reset:")

          Text(quest.dueDate.timeOnly)

          Spacer()

          Toggle("", isOn: $hasDueDate)
            .onChange(of: hasDueDate) {
              quest.setDateToDailyResetTime(settings: settings)
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
            .onChange(of: hasDueDate) {
              QuestTrackerViewModel().trackerModel.setDate(quest: quest, value: hasDueDate)

              datePickerIsExpanded = hasDueDate
            }
            .tint(.cyan)
        }

        if hasDueDate, datePickerIsExpanded == true {
          DatePicker(
            "",
            selection: $quest.dueDate.bound,
            displayedComponents: [.date, .hourAndMinute]
          )
          .datePickerStyle(.graphical)
          .tint(.cyan)
        }
      }
    }
  }
}

#Preview {
    QuestView(quest: PreviewSampleData.previewQuest, settings: PreviewSampleData.previewSettings)
      .modelContainer(PreviewSampleData.container)
}
