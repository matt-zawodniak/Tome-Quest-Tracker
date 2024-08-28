//
//  LevelUpNotification.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI

struct LevelUpNotification: View {

  @State var user: User

  @Binding var navigateToRewardsView: Bool

  var body: some View {
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

        GeometryReader { geometry in
          HStack(spacing: 0) {
            Spacer()
            Button(action: {
              user.leveledUpRecently = false
            }, label: {
              Text("Dismiss")
            })
            .frame(width: geometry.size.width * 0.4, height: 50)

            Button(action: {
              navigateToRewardsView = true

              user.leveledUpRecently = false
            }, label: {
              Text("View Rewards")
                .foregroundStyle(.black)
            })
            .buttonStyle(.borderedProminent)
            .frame(width: geometry.size.width * 0.4, height: 50)
            Spacer()
          }
        }
        }
      .frame(maxHeight: 100)
      .padding()
      .background(.black)
      .foregroundStyle(.cyan)
      .cornerRadius(20)
      .overlay(RoundedRectangle(cornerRadius: 20).stroke(.cyan))
  }
}

#Preview {
    LevelUpNotification(
      user: PreviewSampleData.previewUser,
      navigateToRewardsView: .constant(false))
    .modelContainer(PreviewSampleData.container)
}
