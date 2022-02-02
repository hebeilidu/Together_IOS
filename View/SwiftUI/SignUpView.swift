//
//  SignUpView.swift
//  Together
//
//  Created by lcx on 2021/11/16.
//

import SwiftUI
import Amplify

struct SignUpView: View {
    @StateObject private var newUser = NewUserViewModel()
    @State private var isSigningUp = false
    @State private var needVerification = false
    @State private var showLoginSheet = false
    @State private var error = ""
    @State private var showVerifyEmailButton = false
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isSigningUp)
            NavigationView {
                VStack {
                    NavigationLink(
                        destination: VerificationView(showLoginView: $showLoginSheet, email: newUser.email),
                        isActive: $needVerification
                    ) {
                        EmptyView()
                    }
                    Form {
                        ErrorSection(error: $error)
                        if showVerifyEmailButton {
                            Section {
                                HStack {
                                    Spacer()
                                    Button("Verify Email") {
                                        needVerification = true
                                    }
                                    .foregroundColor(.white)
                                    Spacer()
                                }
                                .listRowBackground(Color.blue)
                            }
                        }
                        Section(footer:
                            Text(newUser.nameValidation).foregroundColor(.red)
                        ) {
                            UserProfileField(placeholder: "First Name", text: $newUser.firstName)
                            UserProfileField(placeholder: "Last Name", text: $newUser.lastName)
                        }
                        Section(footer:
                            (newUser.passwordVlidation == .valid ?
                                Text("") :
                                Text(newUser.passwordVlidation.rawValue).foregroundColor(.red) + Text("\n"))
                                + Text("Password must have at least 1 uppercase, 1 lowercase, 1 number, and must be at least 8 characters long")
                        ) {
                            PasswordField(
                                placeholder: "Create Password",
                                text: $newUser.password,
                                switchCondition: {
                                    newUser.passwordVlidation == .valid ||
                                    newUser.passwordVlidation == .notMatch
                                }
                            )
                            PasswordField(
                                placeholder: "Confirm Password",
                                text: $newUser.confirmedPassword,
                                switchCondition: {
                                    newUser.passwordVlidation == .valid
                                }
                            )
                        }
                        Section(footer:
                            Text(newUser.userInfoVlidation).foregroundColor(.red)
                        ) {
                            UserProfileField(placeholder: "Email", text: $newUser.email)
                            UserProfileField(placeholder: "Username", text: $newUser.nickname)
                        }
                        Section {
                            Picker(selection: $newUser.gender, label: Text("Gender")) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                            }
                        }
                        Section(footer:
                            HStack {
                                Spacer()
                                Button("Already have an account? Login here") { showLoginSheet.toggle() }
                                    .font(.body)
                                    .sheet(isPresented: $showLoginSheet) {
                                        LoginView()
                                    }
                                Spacer()
                            }
                            .padding()
                        ) {
                            HStack {
                                Spacer()
                                Button("Sign Up") {
                                    UIApplication.shared.endEditing()
                                    isSigningUp = true
                                    signUp()
                                }
                                .foregroundColor(.white)
                                Spacer()
                            }
                            .disabled(!newUser.isUserProfileValid)
                            .listRowBackground(Color.blue.opacity(!newUser.isUserProfileValid ? 0.5 : 1))
                        }
                    }
                    .disabled(isSigningUp)
                    .navigationTitle("Create Account")
                }
            }
        }
    }
    
    private func signUp() {
        DispatchQueue.global().async {
            let userAttributes = [
                AuthUserAttribute(.givenName, value: newUser.firstName),
                AuthUserAttribute(.familyName, value: newUser.lastName),
                AuthUserAttribute(.gender, value: newUser.gender),
                AuthUserAttribute(.nickname, value: newUser.nickname)
            ]
            Amplify.Auth.signUp(
                username: newUser.email,
                password: newUser.password,
                options: AuthSignUpRequest.Options(userAttributes: userAttributes)
            ) {
                result in
                DispatchQueue.main.async {
                    isSigningUp = false
                    switch result {
                    case .success:                        
                        showVerifyEmailButton = true
                        needVerification = true
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
        }
    }
}
