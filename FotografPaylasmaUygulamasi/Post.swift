//
//  Post.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Abdulsamet Bakmaz on 1.10.2022.
//

import Foundation

class Post {
    var email : String
    var comment : String
    var imageUrl : String
    init(email: String , comment: String, imageUrl: String){
        self.email = email
        self.comment = comment
        self.imageUrl = imageUrl
    }
}
