//
//  EditPopUpMenu.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 9/20/23.
//

import SwiftUI
import SwiftData

struct QuestView: View {

  @Environment(\.modelContext) var modelContext

  @Environment(\.dismiss) var dismiss

  @ObservedObject var sections: SectionsModel

  @State var quest: Quest
  @State var hasDueDate: Bool = false
  @State var datePickerIsExpanded: Bool = false

  @State var advancedSettingsVisible: Bool = false

  @State var editingQuest: Bool

  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
    return settingsQueryResults.first ?? Settings.fetchFirstOrCreate(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return userQueryResults.first ?? User.fetchFirstOrCreate(context: modelContext)
  }

  var body: some View {
    VStack {
      List {
        nameSection
          .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
          .listRowSeparator(.hidden)

        typeSection
          .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
          .listRowSeparator(.hidden)

        questDescriptionSection
          .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
          .listRowSeparator(.hidden)

        HStack {
          Spacer()
          Text("\(Int(quest.completionExp)) EXP")
          Spacer()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)

        advancedSettingsSection
          .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
          .listRowSeparator(.hidden)
      }
    }
      .padding()
      .listStyle(.grouped)
      .listRowSpacing(5)
      .scrollContentBackground(.hidden)
      .foregroundStyle(.cyan)
    .layoutPriority(1)

    ButtonSection(editingQuest: editingQuest, quest: quest, settings: settings, user: user)
      .background(Rectangle().foregroundStyle(.cyan))
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
    Section(header: CategoryHeader(title: "Advanced Settings",
                                   model: sections,
                                   shouldBeExpanded: false)) {
      if sections.isExpanded(title: "Advanced Settings") {
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

        dueDateView
      } else {
        EmptyView()
      }
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
              if hasDueDate {
                quest.dueDate = Date()
              } else {
                quest.dueDate = nil
              }

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
  QuestView(sections: SectionsModel(), quest: PreviewSampleData.previewQuest, editingQuest: true)
      .modelContainer(PreviewSampleData.container)
}
