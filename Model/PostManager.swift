//
//  PostManager.swift
//  Together
//
//  Created by lcx on 2021/11/25.
//

import UIKit
import Amplify

class PostManager {
    var posts = [Post]()
    private var imageCache = [String:UIImage]()
    private let sort: QuerySortInput?
    private let predicate: QueryPredicate?
    private var table: UITableView
    private let defaultImage = UIImage(systemName: "person")
    private var reloadCompletion: (() -> Void)?
    
    var postCount: Int {
        get {
            return posts.count
        }
    }
    
    init(table: UITableView, predicate: QueryPredicate? = nil, sort: QuerySortInput? = nil, reloadCompletion: (() -> Void)? = nil) {
        self.reloadCompletion = reloadCompletion
        self.predicate = predicate
        self.sort = sort
        self.table = table
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
        self.table.refreshControl?.attributedTitle = NSAttributedString(string: "loading...")
        reloadPosts()
    }
    
    @objc func reloadPosts() {
        DispatchQueue.main.async { [self] in
            table.refreshControl?.beginRefreshing()
        }
        DispatchQueue.global().async { [self] in
            posts = API.getAll(where: predicate, sort: sort)
            DispatchQueue.main.async {
                table.refreshControl?.endRefreshing()
                table.reloadData()
                if let completion = reloadCompletion {
                    completion()
                }
            }
        }
    }
    
    func getCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let postCell = cell as? PostTableViewCell else { return cell }
        postCell.postTitle.text = posts[indexPath.row].title
        postCell.from.text = posts[indexPath.row].departurePlace?.components(separatedBy: .newlines).joined(separator: " ")
        postCell.to.text = posts[indexPath.row].destination?.components(separatedBy: .newlines).joined(separator: " ")
        postCell.numOfMembers.text = "\(posts[indexPath.row].members!.count) / \(posts[indexPath.row].maxMembers!)"
        
        if(posts[indexPath.row].members!.count == posts[indexPath.row].maxMembers!){
            postCell.numOfMembers.textColor = UIColor.systemRed
            postCell.State.backgroundColor = UIColor.systemRed
            
        }else {
            postCell.numOfMembers.textColor = UIColor.white
            postCell.State.backgroundColor = UIColor.white
        }
        
        if let setTime = posts[indexPath.row].departureTime {
            if(setTime > Temporal.DateTime(Date())){
                postCell.State.backgroundColor = UIColor.white
                postCell.when.textColor = UIColor.white
            }else {
                postCell.State.backgroundColor = UIColor.systemRed
                postCell.when.textColor = UIColor.systemRed
            }
        }
        
        postCell.when.text = posts[indexPath.row].departureTime.toString()
        guard let owner = posts[indexPath.row].owner else { return postCell }
        if imageCache[owner] == nil {
            Amplify.Storage.downloadData(key: owner) { [self]
                result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        imageCache[owner] = UIImage(data: data)
                        postCell.userAvatar.image = imageCache[owner]
                    }
                case .failure(_):
                    imageCache[owner] = defaultImage
                }
            }
        } else {
            postCell.userAvatar.image = imageCache[owner]
        }
        return postCell
    }
    
    func showPostDetailViewController(controller: UIViewController, indexPath: IndexPath) {
        DispatchQueue.global().async {
            Amplify.DataStore.query(Post.self, byId: self.posts[indexPath.row].id) {
                result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let post):
                            guard let viewController = controller.storyboard?.instantiateViewController(identifier: "PostDetailViewController"),
                                  let postDetailViewController = viewController as? PostDetailViewController,
                                  let item = post
                            else {
                                break
                            }
                            postDetailViewController.post = item
                            if item.owner != nil {
                                postDetailViewController.ceatorAvatar = self.imageCache[item.owner!]
                            } else {
                                postDetailViewController.ceatorAvatar = UIImage(systemName: "person")
                            }
                            controller.navigationController?.pushViewController(postDetailViewController, animated: true)
                            return
                        case .failure(_):
                            break
                    }
                    Alert.showWarning(controller, "This Post has been deleted") {
                        _ in
                        self.reloadPosts()
                    }
                }
            }
        }
    }
}
