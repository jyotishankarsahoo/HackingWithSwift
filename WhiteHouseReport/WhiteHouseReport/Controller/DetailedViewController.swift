//
//  DetailedViewController.swift
//  WhiteHouseReport
//
//  Created by Jyoti Sahoo on 6/9/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit
import WebKit

final class DetailedViewController: UIViewController {
	var webView: WKWebView!
	var petitionBody: String?
	//MARK: - View Life cycle
	override func loadView() {
		super.loadView()
		webView = WKWebView()
		view = webView
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		loadWebView()
    }
	//MARK: - Setting up UI
	private func loadWebView() {
		guard let body = petitionBody else { return }
		let html = """
		<html>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style> body { font-size: 150%; } </style>
		</head>
		<body>
		\(body)
		</body>
		</html>
		"""
		webView.loadHTMLString(html, baseURL: nil)
	}

}
