//
//  LevelUpNotification.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI

struct LevelUpNotification: View {

  @State var user: User

  @Binding var isPresented: Bool

  @Binding var navigateToRewardsView: Bool

  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Image(systemName: "party.popper")

          Text("Congratulations, you've reached level \(user.level)!").multilineTextAlignment(.center)

          Image(systemName: "party.popper")
            .rotation3DEffect(
              .degrees(180),
              axis: (x: 0.0, y: 1.0, z: 0.0)
            )
        }

        HStack {
          Button(action: {
            isPresented = false
          }, label: {
            Text("Dismiss")
          })

          NavigationLink(destination: RewardsView()) {
            Button(action: {
              navigateToRewardsView = true

              isPresented = false
            }, label: {
              Text("View Rewards")
            })
            .buttonStyle(.borderedProminent)
          }
        }
      }
      .padding()
      .background(.white)
      .cornerRadius(20)
      .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue))
    }
  }
}

#Preview {
    LevelUpNotification(
      user: PreviewSampleData.previewUser,
      isPresented: .constant(true),
      navigateToRewardsView: .constant(false))
    .modelContainer(PreviewSampleData.container)
}
