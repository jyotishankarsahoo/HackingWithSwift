//
//  ViewController.swift
//  WordScramble
//
//  Created by Jyoti Sahoo on 6/7/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	var anagramLetters = [String]()
	var answersList = [String]()

	//MARK: - View life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupStartData()
		startGame()
		setupNavBar()
	}

	//MARK: - Private Setup methods
	private func setupStartData() {
		guard let path = Bundle.main.path(forResource: "start", ofType: ".txt") else { return }
		guard let content = try? String(contentsOfFile: path) else { return }
		content.components(separatedBy: "\n").forEach({ anagramLetters.append($0) })
	}

	private func setupNavBar() {
		let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		navigationItem.rightBarButtonItem = rightBarButtonItem
		let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
		navigationItem.leftBarButtonItem = leftBarButtonItem
	}
	
	@objc private func startGame() {
		guard let navTitle = anagramLetters.randomElement() else { return }
		title = navTitle
		answersList.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	@objc func promptForAnswer() {
		let alertController = UIAlertController(title: "Answer", message: nil, preferredStyle: .alert)
		alertController.addTextField(configurationHandler: nil)
		let alertAction = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alertController] action in
			guard let self = self, let ac = alertController else { return }
			guard let ansTextField = ac.textFields, let answer = ansTextField[0].text else { return }
			guard self.isPossible(word: answer) else {
				self.showAlert(with: "Not Possible", msg: "Create a word using letters in \(self.title!)")
				return
			}
			guard self.isOriginal(word: answer) else {
				self.showAlert(with: "Not Original", msg: "Answer already Selected")
				return
			}
			guard self.isValid(word: answer) else {
				self.showAlert(with: "Not Valid", msg: "Word not Valid in English")
				return
			}
			self.updateTableView(answer)
		}
		alertController.addAction(alertAction)
		present(alertController, animated: true)
	}

	fileprivate func updateTableView(_ answer: String) {
		answersList.insert(answer, at: 0)
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	//MARK: - Table view data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answersList.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
		cell.textLabel?.text = answersList[indexPath.row]
		return cell
	}

	//MARK: - Check Answer
	func isPossible(word: String) -> Bool {
		guard word.count > 2 else { return false }
		guard var navTitle = title else { return  false }
		navTitle = navTitle.lowercased()
		for letter in word.lowercased() {
			if let pos = navTitle.firstIndex(of: letter) {
				navTitle.remove(at: pos)
			} else {
				return false
			}
		}
		return true
	}
	func isOriginal(word: String) -> Bool {
		guard title! != word else { return  false }
		let matchingList = answersList.contains { (str) -> Bool in
			str.lowercased() == word.lowercased()
		}
		return !matchingList
	}
	func isValid(word: String) -> Bool {
		let lowerCasesWord = word.lowercased()
		let textChecker = UITextChecker()
		let range = NSMakeRange(0, lowerCasesWord.utf16.count)
		let misspelledRange = textChecker.rangeOfMisspelledWord(in: lowerCasesWord, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	
	//MARK: - Handle Error Msg
	
	func showAlert(with title: String, msg: String) {
		let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
	
}

