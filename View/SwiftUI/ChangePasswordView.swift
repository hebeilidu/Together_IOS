//
//  ChangePasswordView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Amplify

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var password = ChangePasswordViewModel()
    @State private var error = ""
    @State private var isLoading = false
    @State private var showSuccessView = false
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    ErrorSection(error: $error)
                    Section(
                        header: Text("Password must have at least 1 uppercase, 1 lowercase, 1 number, and must be at least 8 characters long").textCase(.none),
                        footer: Text(password.message == PasswordStatus.valid.rawValue
                             ? ""
                             : password.message
                            )
                            .foregroundColor(Color.red)
                            .fixedSize(horizontal: false, vertical: true)
                    ) {
                        SecureField("Old Password", text: $password.old)
                        SecureField("New Password", text: $password.new)
                        SecureField("Confirm New Password", text: $password.newConfirmation)
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Submit") {
                                UIApplication.shared.endEditing()
                                isLoading.toggle()
                                changePassword()
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .listRowBackground(Color.blue.opacity(password.message == PasswordStatus.valid.rawValue ? 1 : 0.5))
                        .disabled(password.message == PasswordStatus.valid.rawValue ? false : true)
                    }
                }
                .navigationTitle("Change Password")
                .toolbar() {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
            Spinner(isPresented: $isLoading)
            SuccessView(isPresented: $showSuccessView, text: "Success")
        }
    }
    
    private func changePassword() {
        DispatchQueue.global().async {
            Amplify.Auth.update(oldPassword: password.old, to: password.new) {
                result in
                DispatchQueue.main.async {
                    isLoading.toggle()
                    switch result {
                    case .success:
                        showSuccessView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessView.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }        
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
