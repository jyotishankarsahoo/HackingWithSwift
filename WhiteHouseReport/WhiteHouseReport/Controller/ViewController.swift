//
//  ViewController.swift
//  WhiteHouseReport
//
//  Created by Jyoti Sahoo on 6/9/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

final class ViewController: UITableViewController {
	var recentPetitions = [Petition]()
	var filteredPetitions = [Petition]()
	
	@IBOutlet weak var searchBar: UISearchBar!
	//MARK: - View Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		setupNavbar()
		searchBar.delegate = self
	}
	
	//MARK: - Private Setup methods
	fileprivate func setupNavbar() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
	}
	fileprivate func loadData() {
		let urlString: String
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseData(data: data)
				return
			}
		}
		showError()
	}
	private func parseData(data: Data) {
		let decode = JSONDecoder()
		if let decodedJson = try? decode.decode(Petitions.self, from: data) {
			recentPetitions = decodedJson.results
			filteredPetitions = recentPetitions
			tableView.reloadData()
		}
	}
	private func showError() {
		let alertController = UIAlertController(title: "Error", message: "Unable to load results", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default))
		present(alertController, animated: true)
	}
	
	//MARK: - Objective C Selector
	@objc func showCredits() {
		let alertController = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the White house", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default))
		present(alertController, animated: true)
	}
	
	//MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredPetitions.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
		cell.textLabel?.text = filteredPetitions[indexPath.row].title
		cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
		return cell
	}

	//MARK: - Table View Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailedVC = DetailedViewController()
		detailedVC.petitionBody = filteredPetitions[indexPath.row].body
		navigationController?.pushViewController(detailedVC, animated: true)
	}
}

extension ViewController: UISearchBarDelegate {
	//MARK: - Search Bar Delegate
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		performSearch(searchBar, text: searchText)
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.text = ""
		searchBar.resignFirstResponder()
		filteredPetitions = recentPetitions
		tableView.reloadData()
	}
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = true
	}
	
	private func performSearch(_ searchBar: UISearchBar, text: String) {
		filteredPetitions = text.isEmpty ? recentPetitions : recentPetitions.filter({ $0.body.range(of: text, options: .caseInsensitive) != nil })
		tableView.reloadData()
	}

}
