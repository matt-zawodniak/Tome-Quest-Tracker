//
//  BannerViewController.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 7/31/24.
//

import SwiftUI

class BannerViewController: UIViewController {
  weak var delegate: BannerViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Tell the delegate the initial ad width.
    delegate?.bannerViewController(
      self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate { _ in
      // do nothing
    } completion: { _ in
      // Notify the delegate of ad width changes.
      self.delegate?.bannerViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}

// Delegate methods for receiving width update messages.

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}
