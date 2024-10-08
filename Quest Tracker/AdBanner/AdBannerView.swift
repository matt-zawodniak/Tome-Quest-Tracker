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
    bannerView.delegate = context.coordinator
    bannerViewController.view.addSubview(bannerView)
    bannerViewController.delegate = context.coordinator

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  internal class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
    let parent: AdBannerView

    init(_ parent: AdBannerView) {
      self.parent = parent
    }

    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
      parent.viewWidth = width
    }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("DID RECEIVE AD")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("DID NOT RECEIVE AD: \(error.localizedDescription)")
    }
  }
}
