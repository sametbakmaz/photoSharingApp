//
//  ViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdulsamet Bakmaz on 27.09.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //login işlemi
    @IBAction func girisYapTiklandi(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField!.text!) { (authDataResult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "hata", messageInput: error?.localizedDescription ?? "Hata Aldınız Giriş Başarısız")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    //kayıt işlemi
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız Tekrar Deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            hataMesaji(titleInput: "Hata", messageInput: "Kullanıcı Adı ve Şifre Giriniz!")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
 }
}

