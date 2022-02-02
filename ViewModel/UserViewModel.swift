//
//  UserModel.swift
//  Together
//
//  Created by lcx on 2021/11/28.
//

import Foundation
import Amplify
import UIKit

class UserViewModel: ObservableObject {
    @Published var profilePhoto = UIImage(systemName: "person")
    @Published var nickname = "Username"
    @Published var email = "@wustl.edu"
    @Published var firstName = "First Name"
    @Published var lastName = "Last Name"
    @Published var gender = "Male"
    
    init() {
        DispatchQueue.global().async { [self] in
            Amplify.Auth.fetchUserAttributes() {
                switch $0 {
                case .success(let attributes):
                    DispatchQueue.main.async {
                        for attribute in attributes {
                            switch attribute.key {
                            case .nickname:
                                nickname = attribute.value
                            case .email:
                                email = attribute.value
                            case .givenName:
                                firstName = attribute.value
                            case .familyName:
                                lastName = attribute.value
                            case .gender:
                                gender = attribute.value
                            default:
                                break
                            }
                        }
                    }
                case .failure(_):
                    break
                }
            }
            if let user = Amplify.Auth.getCurrentUser() {
                Amplify.Storage.downloadData(key: user.username) {
                    result in
                    switch result {
                    case .success(let imageData):
                        DispatchQueue.main.async {
                            if let image = UIImage(data: imageData) {
                                profilePhoto = image
                            }
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
}
