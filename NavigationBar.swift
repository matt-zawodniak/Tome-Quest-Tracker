//
//  NavigationBar.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI
import SwiftData

struct NavigationBar: View {

  @Environment(\.modelContext) var modelContext

  @State var showingNewQuestView: Bool = false
  @State var showingRewardsView: Bool = false
  @State var showingSettingsView: Bool = false
  @Binding var showingCompletedQuests: Bool

  @Query() var settingsQueryResults: [Settings]
  var settings: Settings {
    return Settings.fetchFirstOrCreate(context: modelContext)
  }

  @Query() var userQueryResults: [User]
  var user: User {
    return User.fetchFirstOrCreate(context: modelContext)
  }

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
    .sheet(isPresented: $showingNewQuestView) {
      QuestView(quest: Quest.defaultQuest(context: modelContext), editingQuest: false)
        .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showingRewardsView) {
      RewardsView()
        .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showingSettingsView) {
      SettingsView(settings: settings, user: user)
        .presentationDetents([.medium, .large])
    }
  }
}

#Preview {
  NavigationBar(showingNewQuestView: false,
                showingRewardsView: false,
                showingSettingsView: false,
                showingCompletedQuests: .constant(false))
}
