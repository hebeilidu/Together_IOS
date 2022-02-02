//
//  NewUserViewModel.swift
//  Together
//
//  Created by lcx on 2021/11/17.
//

import SwiftUI
import Combine

enum PasswordStatus: String {
    case noLowercase = "Password must contain at least 1 lowercase"
    case noUppercase = "Password must contain at least 1 uppercase"
    case noNumber = "Password must contain at least 1 number"
    case lengthNotEnough = "Password must be at least 8 charactors long"
    case notMatch = "Password confirmation does not match password"
    case valid = "valid"
}

enum UserInfoStatus: String {
    case emptyEmail = "Email must not be empty"
    case emptyNickname = "Username should not be empty"
    case invalidEmail = "This is not a valid email"
    case valid = ""
}

class NewUserViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var email = ""
    @Published var nickname = ""
    @Published var gender = "Male"
    
    @Published var nameValidation = ""
    @Published var passwordVlidation = PasswordStatus.valid
    @Published var userInfoVlidation = ""
    @Published var isUserProfileValid = false
    
    private var cancellables = Set<AnyCancellable> ()
    private let lowercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*")
    private let uppercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
    private let numberPredicate = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*")
    private let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")

    private var isNameValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($firstName, $lastName)
            .map { !$0.isEmpty && !$1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest($password, $confirmedPassword)
            .map { [self] in
                if !lowercasePredicate.evaluate(with: $0) {
                    return .noLowercase
                }
                if !uppercasePredicate.evaluate(with: $0) {
                    return .noUppercase
                }
                if !numberPredicate.evaluate(with: $0) {
                    return .noNumber
                }
                if $0.count < 8 {
                    return .lengthNotEnough
                }
                if $0 != $1 {
                    return .notMatch
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPersionInfoValidPublisher: AnyPublisher<UserInfoStatus, Never> {
        Publishers.CombineLatest($email, $nickname)
            .map {
                if $0.isEmpty {
                    return .emptyEmail
                }
                if !self.emailPredicate.evaluate(with: $0) {
                    return .invalidEmail
                }
                if $1.isEmpty {
                    return .emptyNickname
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isUserProfileValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isNameValidPublisher, isPasswordValidPublisher, isPersionInfoValidPublisher)
            .map { $0 && $1 == .valid && $2 == .valid }
            .eraseToAnyPublisher()
    }
    
    init() {
        isNameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { isValid in isValid ? "" : "Name should not be empty"}
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.passwordVlidation, on: self)
            .store(in: &cancellables)
        
        isPersionInfoValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { PersonalInfoStatus in PersonalInfoStatus.rawValue }
            .assign(to: \.userInfoVlidation, on: self)
            .store(in: &cancellables)
        
        isUserProfileValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.isUserProfileValid, on: self)
            .store(in: &cancellables)
    }
}
