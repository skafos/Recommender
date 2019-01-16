//
//  AppController.swift
//  Recommender
//
//  Created by Kevin Musselman on 1/7/19.
//  Copyright © 2019 Kevin Musselman. All rights reserved.
//

import Foundation
import UIKit

class AppController : NSObject {
  fileprivate static let instance = AppController()

  let window:UIWindow

  private var launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil

  override init() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window.rootViewController = RecommenderViewController()

    super.init()
  }

  func dispatch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.launchOptions = launchOptions
    
    self.window.makeKeyAndVisible()

    return true
  }
}

let app = AppController.instance