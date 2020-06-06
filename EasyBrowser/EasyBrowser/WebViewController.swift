//
//  WebViewController.swift
//  EasyBrowser
//
//  Created by Jyoti Sahoo on 6/5/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
	
	var wkWebview: WKWebView!
	var progressView: UIProgressView!

	var urlString: String?
	//MARK: - View Life Cycle
	override func loadView() {
		super.loadView()
		setupWebView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		loadRequest()
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		setupToolBarItems()
		wkWebview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}
	//MARK: - KVO
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(wkWebview.estimatedProgress)
		}
	}
	//MARK: - UI Set up
	fileprivate func setupWebView() {
		wkWebview = WKWebView()
		wkWebview.navigationDelegate = self
		wkWebview.sizeToFit()
		view = wkWebview
	}
	
	fileprivate func setupToolBarItems() {
		let progressBarButtonItem = UIBarButtonItem(customView: progressView)
		let backBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .rewind, target: wkWebview, action: #selector(wkWebview.goBack))
		let forwardBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .fastForward, target: wkWebview, action: #selector(wkWebview.goForward))
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refreshBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .refresh, target: wkWebview, action: #selector(wkWebview.reload))
		toolbarItems = [backBarButtonItem, forwardBarButtonItem, spacer, progressBarButtonItem, spacer, refreshBarButtonItem]
		navigationController?.isToolbarHidden = false
	}
	//MARK: - Load request
	fileprivate func loadRequest() {
		guard let url = urlString, let urlToLoad = URL(string: "https://\(url)") else { return }
		let urlRequest = URLRequest(url: urlToLoad)
		wkWebview.load(urlRequest)
		wkWebview.allowsBackForwardNavigationGestures = true
	}
}

extension WebViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		if let host = url?.host {
				if host.contains(urlString!) && urlString! != "yahoo.com" {
					decisionHandler(.allow)
					return
				} else {
					showAlert()
					decisionHandler(.cancel)
					return
			}
		}
		decisionHandler(.cancel)
	}

	fileprivate func showAlert() {
		let alert = UIAlertController(title: "Blocked", message: "This site is not allowed", preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}
