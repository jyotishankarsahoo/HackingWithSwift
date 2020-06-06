//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Jyoti Sahoo on 6/5/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	let urlLists = ["apple.com", "hackingwithswift.com", "google.com", "yahoo.com"]

	//MARK: - View life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Easy Browser"
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	//MARK: - Table View Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return urlLists.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
		cell.textLabel?.text = urlLists[indexPath.row]
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	//MARK: - Table view Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let webBrowser = storyboard?.instantiateViewController(identifier: "webBrowser") as? WebViewController else { return }
		webBrowser.urlString = urlLists[indexPath.row]
		navigationController?.pushViewController(webBrowser, animated: true)
	}

}

