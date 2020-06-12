//
//  ViewController.swift
//  StromeViewer
//
//  Created by Jyoti Sahoo on 6/4/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

final class ViewController: UITableViewController {

	var images = [String]()

	//MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpNavBar()
		setUpDatasource()
	}
	
	private func setUpNavBar() {
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(shareApp))
	}

	fileprivate func setUpDatasource() {
		let fileManager = FileManager.default
		let resourcesPath = Bundle.main.resourcePath!
		DispatchQueue.global(qos: .userInitiated).async {
			let content = try! fileManager.contentsOfDirectory(atPath: resourcesPath)
			DispatchQueue.main.async { [weak self] in
				_ = content.filter({ $0.hasPrefix("nssl")}).map({
					self?.images.append($0)
					self?.tableView.reloadData()
				})
			}
		}
	}

	@objc func shareApp() {
		let activityController = UIActivityViewController(activityItems: ["Share with friends"], applicationActivities: [])
		activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activityController, animated: true, completion: nil)
	}

	//MARK: - Table View Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
		cell.textLabel?.text = images[indexPath.row]
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	//MARK: - Table View Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let detailedVC = storyboard?.instantiateViewController(withIdentifier: "detailedViewController") as? DetailedViewController else { return }
		detailedVC.imageName = images[indexPath.row]
		detailedVC.imageCount = images.count
		detailedVC.imageIndex = indexPath.row + 1
		navigationController?.pushViewController(detailedVC, animated: true)
	}
	
}

