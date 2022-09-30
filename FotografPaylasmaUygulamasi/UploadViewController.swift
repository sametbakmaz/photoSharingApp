//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdulsamet Bakmaz on 28.09.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadTiklandi(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpeg")
            imageReferance.putData(data, metadata: nil) { (storageMetaData, error) in
                if error != nil{
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz!")
                }else{
                    imageReferance.downloadURL { (url, error) in
                        if error == nil {//firestore bağlantısı yaparak document oluşturma ve verileri kaydetme işlemi
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {
                                let firestoreDatabase = Firestore.firestore()
                                let firestorePost = ["gorsel" : imageUrl, "yorum" : self.commentText.text!, "email" : Auth.auth().currentUser!.email, "tarih" : FieldValue.serverTimestamp() ] as [String : Any]
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz! ")
                                    }else{
                                        self.imageView.image = UIImage(named: "upload")
                                        self.commentText.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                                
                            }

                            
                        }
                    }
                }
            }
            
        }
    }
    func hataMesajiGoster(title: String , message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
