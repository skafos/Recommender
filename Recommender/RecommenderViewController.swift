//
//  RecommenderViewController.swift
//  Recommender
//
//  Created by Kevin Musselman on 1/7/19.
//  Copyright © 2019 Kevin Musselman. All rights reserved.
//

import UIKit
import Skafos

struct Movie {
  let movieId: String
  let name: String
  let genre: String
}

class RecommenderViewController: ViewController {
  
    private let modelName:String = "Recommender.mlmodel.gz"
    private var myRecommender:Recommender! = Recommender()
    private var detectionOverlay: CALayer! = nil
  
    var movies: [String:[String]]! = nil
  
   // The user interactions are passed in to the recommender with format: [Movie ID: Rating]
    var userInteractions: [Int64: Double]! = [2: 1, 10: 8]
    
  
    override func viewDidLoad() {
      super.viewDidLoad()

      if let contents = readDataFromCSV(fileName: "movies", fileType: "csv") {
        self.movies = csv(data: contents)
      }
      
      self.button.addTarget(self, action: #selector(recommendButtonAction(_:)), for: .touchUpInside)

      /***
       Receive Notification When New Model Has Been Downloaded And Compiled
       ***/
      
      NotificationCenter.default.addObserver(self, selector: #selector(RecommenderViewController.reloadModel(_:)), name: Skafos.Notifications.modelUpdateNotification(modelName), object: nil)
  
      /** Receive Notifications for all model updates  **/
      //    NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.reloadModel(_:)), name: Skafos.Notifications.modelUpdated, object: nil)
    }


    @objc func reloadModel(_ notification:Notification) {
      debugPrint("Model Reloaded")
      debugPrint(notification)
      Skafos.load(self.modelName) { (model) in
        guard let model = model else {
          print("No model available")
          return
        }
  
        self.myRecommender.model = model
      }
    }
  
  @objc func recommendButtonAction(_ sender:Any? = nil) {
      do {
        let prediction = try self.myRecommender.prediction(interactions: self.userInteractions, k: 10)
        formatResults(probabilities: prediction.probabilities)
        
      } catch let err as NSError {
        self.errLabel.text = "Error: \(err.localizedDescription)"
        return
      }
  }
  
  func formatResults(probabilities: [Int64: Double]) {
    let titleParagraph = NSMutableParagraphStyle()
    titleParagraph.alignment = .center
    let titleAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26),
                            NSAttributedString.Key.paragraphStyle: titleParagraph]
    let titleString = NSAttributedString(string: "Predection Probabilities:\n", attributes: titleAttributes)
    
    let resultString = NSMutableAttributedString()
    resultString.append(titleString)
    let probs = probabilities.reduce(into: resultString) { (resstr, res1) in
      let (key, value) = res1
      let name = self.movies["\(key)"]?[1] ?? "Unknown"
      let nameAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.blue]
      let attrName = NSMutableAttributedString(string: name, attributes: nameAttributes)
      
      attrName.append(NSAttributedString(string: String(format: ": %.3f \n", value)))
      resstr.append(attrName)
    }

    self.results.attributedText = probs
  }
  
  func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
      else {
        return nil
    }
    do {
      let contents = try String(contentsOfFile: filepath, encoding: .utf8)
      
      return contents
    } catch {
      print("File Read Error for file \(filepath)")
      return nil
    }
  }
  
  func csv(data: String) -> [String: [String]] {
    let rows: [String] = data.components(separatedBy: "\n")
    return rows.reduce(into: [String: [String]]()) {
      let row: [String] = $1.components(separatedBy: ",")
      $0[row[0]] = row
    }
  }

}
