//
//  Petition.swift
//  WhiteHouseReport
//
//  Created by Jyoti Sahoo on 6/9/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import Foundation

struct Petition: Codable {
	let title: String
	let body: String
	let signatureCount: Int
}

struct Petitions: Codable {
	let results: [Petition]
}
