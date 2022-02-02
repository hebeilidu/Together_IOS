//
//  MembersViewController.swift
//  Together
//
//  Created by Bingxin Liu on 11/19/21.
//

import UIKit
import Amplify
import AWSPluginsCore

class MembersViewController: UIViewController {
    
    var post : Post!
    var isOwner : Bool!
    var memberAvatarsCache : [String : UIImage?]!
    var creatorAvatar : UIImage!
    var userAttributesCache : [String : Attributes?]!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        print("register member ")
        table.register(MembersTableViewCell.nib(), forCellReuseIdentifier: MembersTableViewCell.identifier)
        print("register member done")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        print("load table done")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MembersViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // members and applicants
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let memebers = post.members else {
                print("Error: this post doesn't have members")
                return 0
            }
            return memebers.count
        case 1:
            if post.applicants == nil {
                return 0
            } else {
                return post.applicants!.count
            }
        default:
            print("Error: there is the third section which should not exist")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("try dequeue")
        let cell = tableView.dequeueReusableCell(withIdentifier: MembersTableViewCell.identifier, for: indexPath) as! MembersTableViewCell
        
        cell.selectionStyle = .none
        
        print("dequeue done")
        switch indexPath.section {
        case 0:
            guard let members = self.post.members, members.count > indexPath.row else {
                print("Error: this post doesn't have members or this index is out of index bound")
                return cell
            }
            guard let id = members[indexPath.row] else {
                print("Error: No id")
                cell.configure(with: "", with: UIImage(), with: "", with: "")
                return cell
            }
            
            var avatarImage : UIImage
            var nickName = ""
            var gender = ""
            if memberAvatarsCache[id] != nil, memberAvatarsCache[id]! != nil {
                avatarImage = memberAvatarsCache[id]!!
            } else {
                avatarImage = UIImage(named: "defaultPerson")!
            }
            
            if userAttributesCache[id] != nil, userAttributesCache[id]! != nil {
                if userAttributesCache[id]!!.gender != nil {
                    gender = userAttributesCache[id]!!.gender!
                }
                if userAttributesCache[id]!!.nickName != nil {
                    nickName = userAttributesCache[id]!!.nickName!
                }
                
            }
            
            cell.configure(with: id,
                           with: avatarImage,
                           with: nickName,
                           with: gender)
            return cell
        case 1:
            if self.post.applicants == nil {
                print("None of apllicants")
                cell.configure(with: "", with: UIImage(), with: "", with: "")
                return cell
            } else {
                guard let id = self.post.applicants![indexPath.row] else {
                    cell.configure(with: "", with: UIImage(), with: "", with: "")
                    return cell
                }
                var avatarImage : UIImage
                var nickName = ""
                var gender = ""
                
                if memberAvatarsCache[id] != nil, memberAvatarsCache[id]! != nil {
                    avatarImage = memberAvatarsCache[id]!!
                } else {
                    avatarImage = UIImage(named: "defaultPerson")!
                }
                if userAttributesCache[id] != nil, userAttributesCache[id]! != nil {
                    if userAttributesCache[id]!!.gender != nil {
                        gender = userAttributesCache[id]!!.gender!
                    }
                    if userAttributesCache[id]!!.nickName != nil {
                        nickName = userAttributesCache[id]!!.nickName!
                    }
                    
                }
                
                cell.configure(with: id,
                               with: avatarImage,
                               with: nickName,
                               with: gender)
                return cell
            }
        default:
            print("Error: there is the third section which should not exist")
            cell.configure(with: "", with: UIImage(), with: "", with: "")
            return cell
        }
    }
}

extension MembersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Members"
        case 1:
            return "Applicants"
        default:
            print ("Warning: has section 3, which should not exist")
            return ""
        }
    }
}

// extension for approve and reject gesture
extension MembersViewController {
    // assign controll right
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let isOwner = self.isOwner else {return false}
        if isOwner {
            guard let members = self.post.members else {return false}
            if indexPath.section == 1 {return true}
            if members[indexPath.row] == Amplify.Auth.getCurrentUser()?.userId {return false}
            else {
                return true
            }
        } else {return false}
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            let removeAction = UIContextualAction(style: .destructive, title: "Remove", handler: {
                [weak self] (_, _, _)in
                guard let self = self else {return}
                if self.post.members != nil {
                    self.post.members!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updatePost()
                }
            })
            
            let swipeActions = UISwipeActionsConfiguration(actions: [removeAction])
            return swipeActions
        case 1:
            let rejectAction = UIContextualAction(style: .destructive, title: "Reject", handler: {
                [weak self] (_, _, _)in
                guard let self = self else {return}
                if self.post.applicants != nil {
                    self.post.applicants!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updatePost()
                }
            })
            let approveAction = UIContextualAction(style: .destructive, title: "Approve", handler: {
                [weak self] (_, _, _)in
                guard let self = self else {return}
                if self.post.members != nil && self.post.applicants != nil {
                    guard let maxMembers = self.post.maxMembers else {
                        print("Error: doesn't have maxMembers")
                        return
                    }
                    if self.post.members!.count == maxMembers {
                        print("Warnning: members is over the max numbers")
                        return}
                    self.post.members!.append(self.post.applicants![indexPath.row])
                    self.post.applicants!.remove(at: indexPath.row)
                    //self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    //self.tableView.insertRows(at: [IndexPath(row: self.post.members!.count, section: 0)], with: .automatic)
                    self.updatePost()
                    self.tableView.reloadData()
                }

            })
            
            approveAction.backgroundColor = .systemBlue
            
            let swipeActions = UISwipeActionsConfiguration(actions: [rejectAction, approveAction])
            return swipeActions
        default:
            print("Error: section 3 which should not exist")
            let swipeActions = UISwipeActionsConfiguration(actions: [])
            return swipeActions
        }
    }
    
    func updatePost() {
        Amplify.DataStore.save(self.post) {
            result in
            switch(result) {
            case .success:
                print("update successfully")
            case .failure:
                print("update failed")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            switch indexPath.section {
//            case 0:
//                self.post.members?.remove(at: indexPath.row)
//            case 1:
//                self.post.applicants?.remove(at: indexPath.row)
//            default:
//                break
//            }
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//
//            tableView.endUpdates()
//        }
//    }
}

