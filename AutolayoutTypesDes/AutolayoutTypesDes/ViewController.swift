//
//  ViewController.swift
//  AutolayoutTypesDes
//
//  Created by Jyoti Sahoo on 6/8/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		let label1 = UILabel()
		label1.translatesAutoresizingMaskIntoConstraints = false
		label1.text = "These"
		label1.backgroundColor = .brown
		label1.sizeToFit()
		let label2 = UILabel()
		label2.translatesAutoresizingMaskIntoConstraints = false
		label2.text = "Are"
		label2.sizeToFit()
		label2.backgroundColor = .orange
		let label3 = UILabel()
		label3.translatesAutoresizingMaskIntoConstraints = false
		label3.text = "Awsome"
		label3.sizeToFit()
		label3.backgroundColor = .purple
		let label4 = UILabel()
		label4.translatesAutoresizingMaskIntoConstraints = false
		label4.text = "Labels"
		label4.sizeToFit()
		label4.backgroundColor = .cyan
		let label5 = UILabel()
		label5.translatesAutoresizingMaskIntoConstraints = false
		label5.text = "From code"
		label5.sizeToFit()
		label5.backgroundColor = .green
		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
		view.addSubview(label4)
		view.addSubview(label5)
		//setupVFL(label1, label2, label3, label4, label5)
		setupAnchors(label1, label2, label3, label4, label5)

	}
	
	fileprivate func setupVFL(_ label1: UILabel, _ label2: UILabel, _ label3: UILabel, _ label4: UILabel, _ label5: UILabel) {
		let viewDict = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
		let matrix = ["labelHeight": 88]
		for label in viewDict.keys {
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[\(label)]-|", options: [], metrics: nil, views: viewDict))
		}
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-|", options: [], metrics: matrix, views: viewDict))
	}
	
	fileprivate func setupAnchors(_ label1: UILabel, _ label2: UILabel, _ label3: UILabel, _ label4: UILabel, _ label5: UILabel) {
		var previousLabel: UILabel?
		for label in [label1, label2, label3, label4, label5] {
			label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
			label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
			let heightConstraint = label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15, constant: 10)
			heightConstraint.priority = .init(rawValue: 999)
			heightConstraint.isActive = true
			if let previous = previousLabel {
				label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
			} else {
				label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
			}
			previousLabel = label
		}
	}
}

