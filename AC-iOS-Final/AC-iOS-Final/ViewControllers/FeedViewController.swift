//
//  FeedViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var authUserService = AuthUserService()
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var posts = [Post]() {
        didSet {
            feedCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        // auto sizing cell
//        if let flowLayout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//        }
        loadPosts()
    }
    
    private func loadPosts() {
        FirebaseManager.shared.loadPosts { (posts, error) in
            if let error = error{
                print(error)
            }else if let posts = posts{
                self.posts = posts
            }
        }
    }
    
    @IBAction func SignoutPressed(_ sender: UIBarButtonItem) {
        authUserService.signOut()
    }
    
}
extension FeedViewController: AuthUserServiceDelegate {
    func didSignOut(_ userService: AuthUserService) {
        self.dismiss(animated: true, completion: nil)
    }
    func didFailSignOut(_ userService: AuthUserService, error: Error) {
        print("didFailSignOut \(error)")
    }
}
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCollectionCell
        let post = posts[indexPath.row]
        cell.feedTextView.text = post.comment
        cell.feedImageView.layer.borderWidth = 1
        cell.feedTextView.layer.borderWidth = 1
        
        if let imageURL = post.image{
            FirebaseStorageManager.shared.retrieveImage(imgURL: imageURL, completionHandler: { (image) in
                print(image)
                cell.feedImageView.image = image
                cell.setNeedsLayout()
            }, errorHandler: {print("dev:", $0)})
        }
        return cell
    }
}
extension FeedViewController: UICollectionViewDelegate {
    
}
