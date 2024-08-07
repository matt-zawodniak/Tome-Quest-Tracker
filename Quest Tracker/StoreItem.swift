//
//  StoreItem.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 8/7/24.
//

import SwiftUI
import StoreKit

struct StoreItem: View {
  @ObservedObject var storeKit: StoreKitManager
  @State var isPurchased: Bool = false
  var product: Product

  var body: some View {
    if isPurchased {

      Button(action: {

      },
             label: {
        HStack {
          Spacer()
          Text("Thank you for supporting us!")
            .foregroundStyle(.cyan)
          Spacer()
        }
      })
    } else {

      Button(action: {
        Task {
          try await storeKit.purchase(product: product)
        }
      }, label: {
        HStack {
          Text(product.displayName)
          Spacer()
          Text(product.displayPrice)
        }
        .foregroundStyle(.white)
        .onChange(of: storeKit.purchasedProducts) {
          Task {
            isPurchased = (try? await storeKit.isPurchased(product: product)) ?? false
          }
        }
      })
    }
  }
}
