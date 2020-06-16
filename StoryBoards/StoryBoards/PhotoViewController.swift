//
//  PhotoViewController.swift
//  StoryBoards
//
//  Created by Jyoti Sahoo on 6/15/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

}
