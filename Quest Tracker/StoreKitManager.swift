//
//  StoreKitManager.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 8/7/24.
//

import Foundation
import StoreKit

class StoreKitManager: ObservableObject {

  @Published var storeProducts: [Product] = []
  @Published var purchasedProducts: [Product] = []

  var updateListenerTask: Task<Void, Error>?

  private let productDictionary: [String: String]

  init() {
    if let plistPath = Bundle.main.path(forResource: "ProductPropertyList",
                                        ofType: "plist"),
       let plist = FileManager.default.contents(atPath: plistPath) {
      productDictionary = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
    } else {
      productDictionary = [:]
    }

    updateListenerTask = listenForTransactions()

    Task {
      await fetchProducts()

      await updateCustomerProductStatus()
    }
  }

  deinit {
    updateListenerTask?.cancel()
  }

  @MainActor
  func fetchProducts() async {
    do {
      storeProducts = try await Product.products(for: productDictionary.values)
    } catch {
      print("Failed to retrieve products \(error)")
    }
  }

  func purchase(product: Product) async throws -> Transaction? {
    let result = try await product.purchase()

    switch result {
    case .success(let verificationResult):
      let transaction = try checkVerified(verificationResult)
      await updateCustomerProductStatus()
      await transaction.finish()
      return transaction

    case .userCancelled, .pending: return nil

    default: return nil
    }
  }

  func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
    switch result {
    case .unverified: throw StoreError.failedVerification
    case .verified(let signedType): return signedType
    }
  }

  @MainActor
  func updateCustomerProductStatus() async {
    var purchasedProducts: [Product] = []

    for await result in Transaction.currentEntitlements {
      do {
        let transaction = try checkVerified(result)

        if let product = storeProducts.first(where: {$0.id == transaction.productID}) {
          purchasedProducts.append(product)
        }
      } catch {
        print("Transaction failed verification.")
      }
    }

    self.purchasedProducts = purchasedProducts
  }

  func customerHasPurchased(product: Product) async throws -> Bool {
    return purchasedProducts.contains(product)
  }

  func listenForTransactions() -> Task<Void, Error> {
    return Task.detached {
      for await result in Transaction.updates {
        do {
          let transaction = try self.checkVerified(result)
          await self.updateCustomerProductStatus()
          await transaction.finish()
        } catch {
          print("Transaction failed verification")
        }
      }
    }
  }
}

public enum StoreError: Error {
  case failedVerification
}
