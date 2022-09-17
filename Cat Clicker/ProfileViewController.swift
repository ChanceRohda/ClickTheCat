//
//  ProfileViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/9/22.
//

import UIKit
import SDWebImage
import FirebaseStorage
import Firebase
import FirebaseDatabase
import SwiftUI
import FirebaseAuth
class ProfileViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var uploadTask: StorageUploadTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        avatarImageView.addGestureRecognizer(tap)
        avatarImageView.isUserInteractionEnabled = true
        progressBar.isHidden = true
        progressBackgroundView.isHidden = true
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            print("Snapshot \(snapshot)")
            guard let userModel = UserModel(snapshot: snapshot) else {return}
            self.usernameLabel.text = userModel.username
            if let avatar = userModel.avatar {
                self.avatarImageView.sd_setImage(with: avatar, placeholderImage: UIImage(systemName: "person.fill"))
            }
            
            
            
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    @objc func selectImage() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
             imagePicker.allowsEditing = true
             imagePicker.sourceType = .camera
             imagePicker.delegate = self
             self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let selectImageAction = UIAlertAction(title: "Select Image", style: .default) { action in
           let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(selectImageAction)
        alert.addAction(takePhotoAction)
        present(alert, animated: true, completion: nil)
    }
    

    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("could not convert image to jpeg")
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {return}
        progressBar.progress = 0
        progressBar.isHidden = false
        progressBackgroundView.isHidden = false
        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = imageID + ".jpeg"
        let pathToImage = "images/\(userID)/\(imageName)"
        let storageRef = Storage.storage().reference(withPath: pathToImage)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        uploadTask = storageRef.putData(imageData, metadata: metaData, completion: { metadata, error in
            self.progressBar.isHidden = true
            self.progressBackgroundView.isHidden = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    let imageUpdate = ["avatar" : url.absoluteString]
                    UserModel.collection.child(userID).updateChildValues(imageUpdate)
                }
            }
        })
        uploadTask!.observe(.progress) { snapshot in
            let percentComplete = 100.0 * (Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount))
            DispatchQueue.main.async {
                self.progressBar.setProgress(Float(percentComplete), animated: true)
            }
        }
    }
    
    
    
    
}




extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        avatarImageView.image = image
        uploadImage(image: image)
        dismiss(animated: true)
    }
    
    
    
}
