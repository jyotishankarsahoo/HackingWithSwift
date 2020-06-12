//
//  ViewController.swift
//  SwiftWords
//
//  Created by Jyoti Sahoo on 6/10/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var scoreLabel: UILabel!
	var clueLabel: UILabel!
	var answerLabel: UILabel!
	var correctAnswerTextField: UITextField!
	var submitButton: UIButton!
	var cancelButton: UIButton!
	var buttonsView: UIView!
	var optionButtons = [UIButton]()
	var activatedButtons = [UIButton]()

	var level = 1
	var solutions = [String]()
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	override func loadView() {
		super.loadView()
		view = UIView()
		view.backgroundColor = .white
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.text = "Score: 0"
		scoreLabel.textAlignment = .right

		clueLabel = UILabel()
		clueLabel.translatesAutoresizingMaskIntoConstraints = false
		clueLabel.text = "CLUE"
		clueLabel.numberOfLines = 0
		clueLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

		answerLabel = UILabel()
		answerLabel.translatesAutoresizingMaskIntoConstraints = false
		answerLabel.text = "ANSWER"
		answerLabel.textAlignment = .right
		answerLabel.numberOfLines = 0
		answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

		correctAnswerTextField = UITextField()
		correctAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
		correctAnswerTextField.placeholder = "Tap letters to guess"
		correctAnswerTextField.font = UIFont.systemFont(ofSize: 44)
		correctAnswerTextField.isUserInteractionEnabled = false
		
		submitButton = UIButton(type: .system)
		submitButton.translatesAutoresizingMaskIntoConstraints = false
		submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
		submitButton.setTitle("Submit", for: .normal)
		submitButton.addTarget(self, action:  #selector(submitTapped), for: .touchUpInside)
		
		cancelButton = UIButton(type: .system)
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
		cancelButton.setTitle("Cancel", for: .normal)
		cancelButton.addTarget(self, action:  #selector(cancelTapped), for: .touchUpInside)

		buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		buttonsView.layer.borderWidth = 1
		buttonsView.layer.borderColor = UIColor.gray.cgColor
	
		view.addSubview(scoreLabel)
		view.addSubview(clueLabel)
		view.addSubview(answerLabel)
		view.addSubview(correctAnswerTextField)
		view.addSubview(submitButton)
		view.addSubview(cancelButton)
		view.addSubview(buttonsView)

		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

			clueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			clueLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
			clueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),

			answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
			answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
			answerLabel.heightAnchor.constraint(equalTo: clueLabel.heightAnchor),

			correctAnswerTextField.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 20),
			correctAnswerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			correctAnswerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),

			submitButton.topAnchor.constraint(equalTo: correctAnswerTextField.bottomAnchor, constant: 10),
			submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
			submitButton.heightAnchor.constraint(equalToConstant: 44),

			cancelButton.topAnchor.constraint(equalTo: correctAnswerTextField.bottomAnchor, constant: 10),
			cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
			cancelButton.heightAnchor.constraint(equalToConstant: 44),

			buttonsView.heightAnchor.constraint(equalToConstant: 320),
			buttonsView.widthAnchor.constraint(equalToConstant: 750),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
			buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])
		let buttonWidth = 150
		let buttonHeight = 80
		for column in 0 ..< 5 {
			for row in 0 ..< 4 {
				let button = UIButton(type: .system)
				button.setTitle("WWW", for: .normal)
				button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				let buttonFrame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
				button.addTarget(self, action:  #selector(answerButtonTapped), for: .touchUpInside)
				button.frame = buttonFrame
				optionButtons.append(button)
				buttonsView.addSubview(button)
			}
		}
	}

	fileprivate func loadLabels() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()
		if let fileURL = Bundle.main.url(forResource: "level\(level)", withExtension: ".txt") {
			if let content = try? String(contentsOf: fileURL) {
				var lines = content.components(separatedBy: "\n")
				lines.shuffle()
				for (index, value) in lines.enumerated() {
					let parts = value.components(separatedBy: ": ")
					let answer = parts[0]
					let clue = parts[1]
					clueString += "\(index + 1). \(clue) \n"
					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionString += "\(solutionWord.count) Letters \n"
					solutions.append(solutionWord)
					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
			}
		}
		clueLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
		answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
		optionButtons.shuffle()
		if optionButtons.count == letterBits.count {
			for i in 0 ..< optionButtons.count {
				optionButtons[i].setTitle(letterBits[i], for: .normal)
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadLabels()
	}

	@objc func submitTapped(sender: UIButton) {
		print("Submit Button tapped")
		guard let answerText = correctAnswerTextField.text else { return }
		if let index = solutions.firstIndex(of: answerText) {
			if let currentAnswerStrings = answerLabel.text {
				activatedButtons.removeAll()
				var separatedAnswer = currentAnswerStrings.components(separatedBy: "\n")
				separatedAnswer[index] = answerText
				answerLabel.text = separatedAnswer.joined(separator: "\n")
				score += 1
				if score  == 7 {
					let ac = UIAlertController(title: "Complete", message: "Proceed to Label 2", preferredStyle: .alert)
					let alertAction = UIAlertAction(title: "Go", style: .default, handler: labelUp)
					ac.addAction(alertAction)
					present(ac, animated: true)
				}
			}
		} else {
			score -= 1
			let ac = UIAlertController(title: "Wrong", message: "Your answer is wrong", preferredStyle: .alert)
			let alertAction = UIAlertAction(title: "Ok", style: .default)
			ac.addAction(alertAction)
			present(ac, animated: true)
		}
		for button in activatedButtons {
			button.isEnabled = true
		}
		correctAnswerTextField.text = ""
	}
	func labelUp(sender: UIAlertAction) {
		self.level += 1
		solutions.removeAll(keepingCapacity: true)
		loadLabels()
		optionButtons.forEach({ $0.isEnabled = true})
	}
	@objc func cancelTapped(sender: UIButton) {
		print("Cancel Button tapped")
		correctAnswerTextField.text = ""
		for button in activatedButtons {
			button.isEnabled = true
		}
		activatedButtons.removeAll()
	}
	
	@objc func answerButtonTapped(sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
		correctAnswerTextField.text?.append(title)
		sender.isEnabled = false
		activatedButtons.append(sender)
	}

}

