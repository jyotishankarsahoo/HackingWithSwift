//
//  Person.swift
//  NameToFace
//
//  Created by Jyoti Sahoo on 6/12/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class Person: NSObject {
	var name: String
	var imageString: String
	init(name: String, imageString: String) {
		self.name = name
		self.imageString = imageString
	}
}
