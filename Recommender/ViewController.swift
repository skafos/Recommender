//
//  ViewController.swift
//  Recommender
//
//  Created by Kevin Musselman on 1/7/19.
//  Copyright © 2019 Kevin Musselman. All rights reserved.
//

import Foundation
import UIKit
import Skafos
import CoreML
import SnapKit


class ViewController: UIViewController {
  
  lazy var label:UILabel = {
    let label           = UILabel()
    label.text          = "Recommender"
    label.font          = label.font.withSize(36)
    label.textAlignment = .center
    self.view.addSubview(label)
    return label
  }()
  
  lazy var about:UILabel = {
    let label           = UILabel()
    label.text          = "This returns movie recommendations based on user interactions (moviedId: rating) that are passed into the model. The interactions are currently hard coded"
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.adjustsFontSizeToFitWidth = true
    label.numberOfLines = 5
    self.view.addSubview(label)
    return label
  }()
  
  lazy var results:UILabel = {
    let label           = UILabel()
    label.textAlignment = .left
    label.textColor     = .black
    label.text          = ""
    label.numberOfLines = 0
    self.view.addSubview(label)
    return label
  }()
  
  lazy var errLabel:UILabel = {
    let label           = UILabel()
    label.textAlignment = .center
    label.textColor     = .red
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    
    self.view.addSubview(label)
    return label
  }()
  
  lazy var button:UIButton = {
    let button        = UIButton(type: .custom)
    button.backgroundColor = .blue
    
    button.setTitle("Check Recommendations", for: .normal)
    button.setTitleColor(.white, for: .normal)
    
    self.view.addSubview(button)
    return button
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func viewDidLayoutSubviews() {
    
    label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(40)
      make.right.left.equalToSuperview().inset(10)
      make.height.equalTo(40)
    }

    about.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(10)
      make.right.left.equalToSuperview().inset(10)
    }
    
    results.snp.makeConstraints { make in
      make.top.equalTo(about.snp.bottom).offset(10)
      make.right.left.equalToSuperview().inset(10)
    }
    
    errLabel.snp.makeConstraints { make in
      make.top.equalTo(results.snp.bottom).offset(10)
      make.right.left.equalTo(label)
    }
    
    button.snp.makeConstraints { make in
      make.top.equalTo(errLabel.snp.bottom).offset(10)
      make.right.left.height.equalTo(label)
    }
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
