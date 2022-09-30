//
//  FeedViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdulsamet Bakmaz on 28.09.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    /*var emailArray = [String]()
    var commentArray = [String]()
    var imageArray = [String]()*/
    
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()

    }
    func firebaseVerileriAl() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { (snapshot, error) in //Tarihe göre veritabanından(Post) çek
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    /*self.emailArray.removeAll(keepingCapacity: false)//bir sonraki uploadda listeyi boşalt görsel tekrarı olmasın
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)*/
                    self.postArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents { // verileri çek her biri için for loopta documente ata
                        let documentId = document.documentID
                        print(documentId)
                        if let imagelUrl = document.get("gorsel") as? String {
                            
                            if let comment = document.get("yorum") as? String {
                                
                                if let email = document.get("email") as? String {
                                    
                                    let post = Post(email: email, comment: comment, imageUrl: imagelUrl)
                                    self.postArray.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //kayıtlı veri sayısı kadar liste elemanı göster
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // veri içeriğini liste elemanını indexe göre bas
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = postArray[indexPath.row].email
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        cell.postCommentText.text = postArray[indexPath.row].comment
        return cell
    }
}
