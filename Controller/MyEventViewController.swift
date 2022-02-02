//
//  MyEventViewController.swift
//  Together
//
//  Created by 李都 on 2021/10/29.
//

import UIKit
import Amplify

class MyEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var myEventTableView: UITableView!
    @IBOutlet weak var message: MessageLabel!
    private let searchController = UISearchController()
    private var eventManager: PostManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search titles, places and descriptions"
        
        setupTableView()
        guard let user = Amplify.Auth.getCurrentUser() else { return }
        eventManager = PostManager(
            table: myEventTableView,
            predicate: (Post.keys.owner.eq(user.username)
                        || Post.keys.members.contains(user.username)),
            sort: .descending(Post.keys.departureTime)
        )
    }
    
    func setupTableView(){
        myEventTableView.dataSource = self
        myEventTableView.delegate = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        myEventTableView.register(nib, forCellReuseIdentifier: "cell")
        myEventTableView.estimatedRowHeight = 85.0
        myEventTableView.rowHeight = UITableView.automaticDimension
        myEventTableView.separatorColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eventManager.getCell(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventManager.showPostDetailViewController(controller: self, indexPath: indexPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if eventManager != nil {
            eventManager.reloadPosts()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchController.searchBar.text else {return}
        guard let user = Amplify.Auth.getCurrentUser() else { return }
        let p = Post.keys
        eventManager = PostManager(
            table: myEventTableView,
            predicate: ((p.departurePlace.contains(keyword)
                        || p.destination.contains(keyword)
                        || p.title.contains(keyword)
                        || p.description.contains(keyword))
                        && (p.owner.eq(user.username) || p.members.contains(user.username))
            ),
            sort: .descending(Post.keys.departureTime)
        )
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let user = Amplify.Auth.getCurrentUser() else { return }
        eventManager = PostManager(
            table: myEventTableView,
            predicate: Post.keys.owner == user.username
                        || Post.keys.members.contains(user.username)
            ,
            sort: .descending(Post.keys.departureTime)
        )
    }
    
    @IBSegueAction func showNewPostView(_ coder: NSCoder, sender: MyEventViewController?) -> NewPostViewController? {
        return NewPostViewController(coder: coder, delegate: self)
    }
}

extension MyEventViewController: NewPostViewDelegate {
    func handleSuccess() {
        eventManager.reloadPosts()
        message.showSuccessMessage("Post Sent")
    }
    
    func handleFailure() {
        message.showFailureMessage("Fail to send Post")
    }
}
