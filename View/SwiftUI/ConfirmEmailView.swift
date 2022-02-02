//
//  ConfirmEmailView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Amplify

struct ConfirmEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var error = ""
    @State private var isLoading = false
    @State private var showResetPasswordView = false
    @State private var isPresenting = true
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isLoading)
            NavigationView {
                VStack {
                    NavigationLink(destination: ResetPasswordView(isPresenting: $isPresenting, email: email), isActive: $showResetPasswordView) {
                        EmptyView()
                    }
                    Form {
                        ErrorSection(error: $error)
                        Section(
                            footer: Text("Confirm email to reset password, a verification code would be sent to your email address")
                        ) {
                            TextField("Email", text: $email)
                                .font(.body)
                                .autocapitalization(.none)
                                .foregroundColor(.primary)
                        }
                        Section {
                            HStack {
                                Spacer()
                                Button("Confirm") {
                                    UIApplication.shared.endEditing()
                                    isLoading.toggle()
                                    confirmEmail()
                                }
                                .font(.body)
                                .foregroundColor(.white)
                                Spacer()
                            }
                            .listRowBackground(Color.blue.opacity(email.isEmpty ? 0.5 : 1))
                            .disabled(email.isEmpty ? true : false)
                        }
                    }
                }
                .navigationTitle("Confirm Email")
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
        }
        .onChange(of: isPresenting) {
            if !$0 {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func confirmEmail() {
        DispatchQueue.global().async {
            Amplify.Auth.resetPassword(for: email) {
                result in
                DispatchQueue.main.async {
                    isLoading.toggle()
                    switch result {
                    case .success(_):
                        showResetPasswordView.toggle()
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }        
    }
}

struct ConfirmEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmEmailView()
    }
}
