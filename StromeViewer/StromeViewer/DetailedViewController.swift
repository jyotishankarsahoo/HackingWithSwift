//
//  DetailedViewController.swift
//  StromeViewer
//
//  Created by Jyoti Sahoo on 6/5/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

	@IBOutlet weak var stromImageView: UIImageView!
	var imageCount: Int?
	var imageIndex: Int?
	var imageInfo: ImageInfo?
	weak var delegate: ListUpdatable?

	//MARK: - View Life Cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
		guard let info = imageInfo, let index = imageIndex else { return }
		delegate?.updateViewCount(info, index: index)
	}
	
	@objc func shareTapped() {
		guard let imageData = stromImageView.image?.jpegData(compressionQuality: 0.8) else { return }
		guard let info = imageInfo else { return }
		let activityController = UIActivityViewController(activityItems: [imageData, info.name], applicationActivities: [])
		activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activityController, animated: true, completion: nil)
	}

	fileprivate func setUpUI() {
		guard let info = imageInfo else { return }
		guard let count = imageCount else { return }
		guard let index = imageIndex else { return }
		stromImageView.image = UIImage(named: info.name)
		title = "Image \(index) of \(count)"
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}

}
