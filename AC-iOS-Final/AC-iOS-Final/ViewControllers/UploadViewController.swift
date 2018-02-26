//
//  UploadViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadTextView: UITextView!
    
    private var tapGesture: UITapGestureRecognizer!
    private let imagePickerView = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadTextView.delegate = self
        uploadTextView.text = "Add a description"
        uploadTextView.textColor = UIColor.lightGray
        imagePickerView.delegate = self
        uploadTextView.layer.borderWidth = 1
        uploadImageView.layer.borderWidth = 1
        TapGestureSetup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaultSetup(textView: uploadTextView)
    }
    private func defaultSetup(textView: UITextView) {
        textView.text = "Add a description"
        textView.textColor = UIColor.lightGray
        uploadImageView.image = #imageLiteral(resourceName: "camera_icon")
        uploadImageView.contentMode = .center
    }
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        //TODO: Write to Firebase
        guard let comment = uploadTextView.text else {return}
        guard !comment.isEmpty || comment != "Add a description" else { showAlert(title: "Error", message: "Add text to the field below"); return}
        guard let image = uploadImageView.image else {return}
        guard image != #imageLiteral(resourceName: "camera_icon") else {showAlert(title: "Error", message: "Please select an image"); return}
        FirebaseManager.shared.addPost(comment: comment, image: image)
        let alertController = UIAlertController(title: "Success", message: "Your post has been uploaded!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.tabBarController?.selectedIndex = 0
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    private func TapGestureSetup() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePickerView.sourceType = .photoLibrary
        present(imagePickerView, animated: true, completion: nil)
    }
        func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

}
extension UploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            defaultSetup(textView: textView)
        }
    }
}
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { print("image is nil"); return }
        uploadImageView.image = image
        uploadImageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
