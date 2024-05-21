//
//  QuestViewButtonSection.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 4/6/24.
//

import SwiftUI

struct ButtonSection: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) var modelContext

  @State var editingQuest: Bool
  @State var quest: Quest
  @State var settings: Settings
  @State var user: User

  var body: some View {
    HStack {
      if editingQuest {
        deleteButton
      } else {
        cancelButton
      }
      Divider()

      if quest.type == .dailyQuest || quest.type == .weeklyQuest {
        skipButton
        Divider()
      }

      if editingQuest {
        confirmButton
        Divider()

        if quest.isCompleted {
          restoreButton
        } else {
          completeButton
        }

      } else {
        createButton
      }

//        if !editingQuest {
//
//          cancelButton
//
//          Divider()
//
//          createButton
//        } else {
//          if quest.isCompleted {
//            deleteButton
//
//            Divider()
//
//            confirmButton
//
//            Divider()
//
//            restoreButton
//          } else {
//            if quest.type == .mainQuest || quest.type == .sideQuest {
//              deleteButton
//
//              Divider()
//
//              confirmButton
//
//              Divider()
//
//              completeButton
//            } else {
//              deleteButton
//
//              Divider()
//
//              skipButton
//
//              Divider()
//
//              confirmButton
//
//              Divider()
//
//              completeButton
//            }
//          }
//        }
      }
      .foregroundStyle(.white)
      .padding()
  }

  var cancelButton: some View {
    Button("Cancel") {
      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var completeButton: some View {
    Button("Complete") {
      quest.isCompleted = true

      quest.timeCompleted = Date.now

      user.giveExp(quest: quest, settings: settings, context: modelContext)

      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var confirmButton: some View {
    Button("Confirm") {
      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var createButton: some View {
    Button("Create") {
      quest.isSelected = false

      quest.isCompleted = false

      modelContext.insert(quest)

      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var deleteButton: some View {
    Button("Delete") {
      modelContext.delete(quest)
      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var restoreButton: some View {
    Button("Restore") {
      quest.isCompleted = false
      quest.timeCreated = Date.now

      dismiss()
    }
    .frame(maxWidth: .infinity)
  }

  var skipButton: some View {
    Button("Skip") {
      quest.isCompleted = true
      quest.timeCompleted = Date.now

      dismiss()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ButtonSection(editingQuest: true,
                quest: PreviewSampleData.previewQuest,
                settings: PreviewSampleData.previewSettings,
                user: PreviewSampleData.previewUser)
    .modelContainer(PreviewSampleData.container)
}
