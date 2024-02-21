//
//  NavigationBar.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI

struct NavigationBar: View {

  @Binding var newQuestView: Bool
  @Binding var rewardsView: Bool
  @Binding var settingsView: Bool
  @Binding var showingCompletedQuests: Bool

  var body: some View {
    ZStack {
      VStack(spacing: 15) {

        Divider()
          .frame(height: 2)
          .overlay(.cyan)

        HStack {
          Spacer()
          Image(systemName: "house")
            .onTapGesture {
              showingCompletedQuests = false
              newQuestView = false
              rewardsView = false
              settingsView = false
            }
          Spacer()
          Image(systemName: "book.closed")
            .onTapGesture {
              showingCompletedQuests = true
              newQuestView = false
              rewardsView = false
              settingsView = false
            }
          Spacer()
          Spacer()
          Spacer()
          Image(systemName: "gift.fill")
            .onTapGesture {
              showingCompletedQuests = false
              newQuestView = false
              rewardsView = true
              settingsView = false
            }
          Spacer()
          Image(systemName: "gearshape")
            .onTapGesture {
              showingCompletedQuests = false
              newQuestView = false
              rewardsView = false
              settingsView = true
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
            newQuestView = true
            rewardsView = false
            settingsView = false
            print("Tapped +")
          }

    }
    .background(.black)
  }
}
