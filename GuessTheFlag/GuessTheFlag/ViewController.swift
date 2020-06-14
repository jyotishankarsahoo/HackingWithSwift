//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Jyoti Sahoo on 6/4/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	//MARK: - OutLets
	@IBOutlet weak var button3: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button1: UIButton!
	//MARK: - Member vars
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var numberOfQuestionAsked = 0
	let userDefault = UserDefaults.standard
	//MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		setUpButtons()
		askQuestion()
		saveScore(score: score)
	}
//MARK: -  Private Methods
	fileprivate func setUpButtons() {
		_ = [button1, button2, button3].map({
			$0?.layer.borderWidth = 1
			$0?.layer.borderColor = UIColor.gray.cgColor
		})
	}
	fileprivate func resetQuestion(sender: UIAlertAction! = nil) {
		numberOfQuestionAsked = 0
		score = 0
		askQuestion()
	}
	fileprivate func askQuestion(sender: UIAlertAction! = nil) {
		guard numberOfQuestionAsked <= 5 else {
			showAlert(with: "Final Result", msg: "Your Final Score is \(score) of \(numberOfQuestionAsked)", handler: resetQuestion)
			return
		}
		numberOfQuestionAsked += 1
		countries.shuffle()
		correctAnswer = Int.random(in: 0 ... 2)
		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
		title = "\(countries[correctAnswer].uppercased() ) Score: \(score)"
		
	}
	fileprivate func showAlert(with title: String, msg: String, handler: ((UIAlertAction) -> Void)?) {
		if let currentAlertVC = self.presentedViewController as? UIAlertController {
			currentAlertVC.message = msg
			currentAlertVC.title = title
			return
		}
		let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: handler))
		present(alertController, animated: true, completion: nil)
	}
	//MARK: - IB Action
	@IBAction func flagSelected(_ sender: UIButton) {
		var title = ""
		var msg = ""
		if sender.tag == correctAnswer {
			score += 1
			title = "Correct"
			msg = "Score is \(score)"
		} else {
			//score -= 1
			title = "Wrong"
			msg = "Thats the flag for \(countries[sender.tag])"
		}
		showAlert(with: title, msg: msg, handler: askQuestion)
		saveScore(score: score)
	}
	func saveScore(score: Int) {
		if score > userDefault.integer(forKey: "heightScore") {
			userDefault.set(score, forKey: "heightScore")
			showAlert(with: "New HighScore", msg: "Score: \(score)", handler: nil)
		}
	}
}

