//
//  ViewController.swift
//  NameToFace
//
//  Created by Jyoti Sahoo on 6/12/20.
//  Copyright © 2020 Jyoti Sahoo. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
	var personInfoList = [Person]()

	//MARK: - View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
	}

	//MARK: - @objc Selector
	@objc func addPhoto() {
		let photoPicker = UIImagePickerController()
		photoPicker.delegate = self
		photoPicker.allowsEditing = true
		present(photoPicker, animated: true)
	}

	//MARK: - Collectionview Datasource
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return personInfoList.count
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? CustomCollectionCell else { fatalError("Unable to Type cast to custom Cell")}
		let personInfo = personInfoList[indexPath.row]
		cell.nameLabel.text = personInfo.name
		let imageURL = getDocumentDirectory().appendingPathComponent(personInfo.imageString)
		cell.imageView.image = try? UIImage(data: Data(contentsOf: imageURL))
		return cell
	}

	//MARK: - Collection view Data source
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let ac = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
		ac.addTextField(configurationHandler: nil)
		ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak ac] _ in
			guard let sself = self, let ansTextField = ac?.textFields, let enteredName = ansTextField[0].text else { return }
			let personModel = sself.personInfoList[indexPath.row]
			personModel.name = enteredName
			sself.collectionView.reloadData()
		}))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let imageData = info[.editedImage] as? UIImage else { return }
		if let jpegData = imageData.jpegData(compressionQuality: 0.8) {
			let imageName = UUID().uuidString
			let imageFilePath = getDocumentDirectory().appendingPathComponent(imageName)
			if let _ = try? jpegData.write(to: imageFilePath) {
				personInfoList.append(Person(name: "Unknown", imageString: imageName))
				collectionView.reloadData()
			}
		}
		dismiss(animated: true)
	}
	
	func getDocumentDirectory() -> URL {
		let documentsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		print("\(documentsFilePath[0])")
		return documentsFilePath[0]
	}
}
