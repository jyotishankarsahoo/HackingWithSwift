//
//  CommentsViewController.swift
//  StoryBoards
//
//  Created by Jyoti Sahoo on 6/15/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

	@IBOutlet weak var commentsView: UIView!
	@IBOutlet weak var commetTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		commetTextField.becomeFirstResponder()
	}
	override var inputAccessoryView: UIView? {
		return commentsView
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}

}
