//
//  FirebaseManager.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {
        dataBaseRef = Database.database().reference()
        postReference = dataBaseRef.child("post")
        
    }
    private var dataBaseRef: DatabaseReference!
    private var postReference: DatabaseReference!
    
    public func addPost(comment: String, image: UIImage?) {
        let childByAutoId = postReference.childByAutoId()
        guard let userId = AuthUserService.getCurrentUser()?.uid else { fatalError("uid is nil")}
        guard let image = image else {return}
        FirebaseStorageManager.shared.storeImage(postId: childByAutoId.key, image: image)
        childByAutoId.setValue(Post(postUID: childByAutoId.key, comment: comment, userUID: userId, image: "images/\(childByAutoId.key).jpg").postToJson())
    }
    
    public func loadPosts(completionHandler: @escaping ([Post]?, Error?) -> Void){
        // getting the reference for the node that is Posts
        let dbReference = Database.database().reference().child("post")
        dbReference.observe(.value){(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {print("post node has no children");return}
            var allPosts = [Post]()
            for snap in snapshots {
                //convert to json
                guard let rawJSON = snap.value else {continue}
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let post = try JSONDecoder().decode(Post.self, from: jsonData)
                    allPosts.append(post)
                    print("post added to Post array")
                }catch{
                    print(error)
                }
            }
            completionHandler(allPosts, nil)
            
            //refactor with custom delegate methods
            if allPosts.isEmpty {
                print("There are no posts in the database")
            } else {
                print("posts loaded successfully!")
            }
        }
    }
    
}
