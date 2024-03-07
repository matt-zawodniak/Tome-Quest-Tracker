//
//  NavigationBar.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI

struct NavigationBar: View {

  @Binding var showingNewQuestView: Bool
  @Binding var showingRewardsView: Bool
  @Binding var showingSettingsView: Bool
  @Binding var showingCompletedQuests: Bool

  var body: some View {
    ZStack {

      VStack(spacing: 15) {

        Divider()
          .frame(height: 2)
          .overlay(.cyan)

        HStack {

          Spacer()

          VStack {
            Image(systemName: "house")
              .onTapGesture {
                showingCompletedQuests = false
                showingNewQuestView = false
                showingRewardsView = false
                showingSettingsView = false
              }
              .foregroundStyle(showingCompletedQuests == false
                               && showingNewQuestView == false
                               && showingRewardsView == false
                               && showingSettingsView == false ? .cyan : .white)
          }

          Spacer()

          VStack {
            Image(systemName: "checkmark.square")
              .onTapGesture {
                showingCompletedQuests = true
                showingNewQuestView = false
                showingRewardsView = false
                showingSettingsView = false
              }
              .foregroundStyle(showingCompletedQuests ? .cyan : .white)
          }

          Spacer()
          Spacer()
          Spacer()
          Spacer()

          VStack {
            Image(systemName: "gift.fill")
              .onTapGesture {
                showingCompletedQuests = false
                showingNewQuestView = false
                showingRewardsView = true
                showingSettingsView = false

              }
              .foregroundStyle(showingRewardsView ? .cyan : .white)
          }

          Spacer()

          VStack {
            Image(systemName: "gearshape")
              .onTapGesture {
                showingCompletedQuests = false
                showingNewQuestView = false
                showingRewardsView = false
                showingSettingsView = true

              }
              .foregroundStyle(showingSettingsView ? .cyan : .white)
          }

          Spacer()

        }
        .foregroundColor(.white)

      }
      .padding()

      PlusNavBackground().fill().foregroundStyle(.black)
      PlusNavBackground().fill().foregroundStyle(.cyan.opacity(0.2))
        .background(PlusNavBackground().stroke(.cyan, lineWidth: 5))

      Image(systemName: "plus.square.dashed").font(.largeTitle)
        .foregroundColor(.cyan)
        .onTapGesture {
          showingCompletedQuests = false
          showingNewQuestView = true
          showingRewardsView = false
          showingSettingsView = false
          print("Tapped +")
        }

    }
    .background(.black)
  }
}

#Preview {
  NavigationBar(showingNewQuestView: .constant(false),
                showingRewardsView: .constant(false),
                showingSettingsView: .constant(false),
                showingCompletedQuests: .constant(false))
}
