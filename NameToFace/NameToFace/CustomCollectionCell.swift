//
//  CustomCollectionCell.swift
//  NameToFace
//
//  Created by Jyoti Sahoo on 6/12/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class CustomCollectionCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.borderWidth = 1
		imageView.layer.cornerRadius = 10
	}
}
