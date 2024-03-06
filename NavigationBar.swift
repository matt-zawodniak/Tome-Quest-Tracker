//
//  NavigationBar.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI

struct NavigationBar: View {
  @State var router: Router

  @State var newQuestView: Bool = false
  @State var rewardsView: Bool = false
  @State var settingsView: Bool = false
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
                newQuestView = false
                rewardsView = false
                settingsView = false
                router.navigateToRoot()
              }
              .foregroundStyle(showingCompletedQuests == false
                               && newQuestView == false
                               && rewardsView == false
                               && settingsView == false ? .cyan : .white)
          }
          Spacer()
          VStack {
            Image(systemName: "book.closed")
              .onTapGesture {
                showingCompletedQuests = true
                newQuestView = false
                rewardsView = false
                settingsView = false
                router.navigateToRoot()
              }
              .foregroundStyle(showingCompletedQuests ? .cyan : .white)
          }
          Spacer()
          Spacer()
          Spacer()
          VStack {
            Image(systemName: "gift.fill")
              .onTapGesture {
                showingCompletedQuests = false
                newQuestView = false
                rewardsView = true
                settingsView = false

                router.navigate(to: .rewards)
              }
              .foregroundStyle(rewardsView ? .cyan : .white)
          }
          Spacer()
          VStack {
            Image(systemName: "gearshape")
              .onTapGesture {
                showingCompletedQuests = false
                newQuestView = false
                rewardsView = false
                settingsView = true

                router.navigate(to: .settings)
              }
              .foregroundStyle(settingsView ? .cyan : .white)
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

            router.navigate(to: .newQuestView)
            print("Tapped +")
          }

    }
    .background(.black)
  }
}
