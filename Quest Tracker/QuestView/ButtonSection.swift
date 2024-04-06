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
    GeometryReader { geometry in
      HStack {
        if !editingQuest {
          Spacer()

          Button("Cancel") {
            dismiss()
          }
          .frame(width: geometry.size.width / 3, height: 30)

          Divider()
            .frame(height: 30)
            .overlay(.black)

          Button("Create") {
            quest.isSelected = false

            quest.isCompleted = false

            modelContext.insert(quest)

            dismiss()
          }
          .frame(width: geometry.size.width / 3, height: 30)

          Spacer()
        } else {
          if quest.isCompleted {
            Spacer()

            Button("Delete") {
              modelContext.delete(quest)
              dismiss()
            }
            .frame(width: geometry.size.width / 4, height: 30)

            Divider()
              .frame(height: 30)
              .overlay(.black)

            Button("Confirm") {
              dismiss()
            }
            .frame(width: geometry.size.width / 4, height: 30)

            Divider()
              .frame(height: 30)
              .overlay(.black)

            Button("Restore") {
              quest.isCompleted = false
              quest.timeCreated = Date.now

              dismiss()
            }
            .frame(width: geometry.size.width / 4, height: 30)

            Spacer()
          } else {
            if quest.type == .mainQuest || quest.type == .sideQuest {
              Spacer()

              Button("Delete") {
                modelContext.delete(quest)
                dismiss()
              }
              .frame(width: geometry.size.width / 4, height: 30)

              Divider()
                .frame(height: 30)
                .overlay(.black)

              Button("Confirm") {
                dismiss()
              }
              .frame(width: geometry.size.width / 4, height: 30)

              Divider()
                .frame(height: 30)
                .overlay(.black)

              Button("Complete") {
                quest.isCompleted = true

                quest.timeCompleted = Date.now

                user.giveExp(quest: quest, settings: settings, context: modelContext)

                dismiss()
              }
              .frame(width: geometry.size.width / 4, height: 30)

              Spacer()
            } else {
              Spacer()

              Button("Delete") {
                modelContext.delete(quest)
                dismiss()
              }
              .frame(width: geometry.size.width / 5, height: 30)

              Divider()
                .frame(height: 30)
                .overlay(.black)

              Button("Skip") {
                quest.isCompleted = true
                quest.timeCompleted = Date.now

                dismiss()
              }
              .frame(width: geometry.size.width / 5.5, height: 30)

              Divider()
                .frame(height: 30)
                .overlay(.black)

              Button("Confirm") {
                dismiss()
              }
              .frame(width: geometry.size.width / 5.5, height: 30)

              Divider()
                .frame(height: 30)
                .overlay(.black)

              Button("Complete") {
                quest.isCompleted = true

                quest.timeCompleted = Date.now

                user.giveExp(quest: quest, settings: settings, context: modelContext)

                dismiss()
              }
              .frame(width: geometry.size.width / 5, height: 30)

              Spacer()
            }
          }
        }
      }
      .foregroundStyle(.white)
      .padding(.horizontal)
    }
    .background(.cyan)
  }
}

#Preview {
  ButtonSection(editingQuest: true,
                quest: PreviewSampleData.previewQuest,
                settings: PreviewSampleData.previewSettings,
                user: PreviewSampleData.previewUser)
    .modelContainer(PreviewSampleData.container)
}
