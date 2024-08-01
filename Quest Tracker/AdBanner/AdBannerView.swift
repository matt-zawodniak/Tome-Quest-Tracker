//
//  AdBannerView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 7/31/24.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewControllerRepresentable {
  @State private var viewWidth: CGFloat = .zero
  private let bannerView = GADBannerView()
  // This is the test ad unit ID - change for production.
  private let adUnitID = "ca-app-pub-3940256099942544/2435281174"

  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = bannerViewController
    bannerViewController.view.addSubview(bannerView)

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    // Request a banner ad with the updated viewWidth.
    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }
}
