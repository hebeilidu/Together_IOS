//
//  LoginView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var isSigningIn = false
    @State private var showConfirmEmailView = false
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isSigningIn)
            NavigationView {
                Form {
                    ErrorSection(error: $error)
                    Section {
                        TextField("Email", text: $email)
                            .font(.body)
                            .foregroundColor(.primary)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .disabled(isSigningIn)

                    Section(footer:
                        HStack {
                            Spacer()
                            Button("Forget Password?") { showConfirmEmailView.toggle() }
                                .font(.body)
                                .sheet(isPresented: $showConfirmEmailView) {
                                    ConfirmEmailView()
                                }
                            Spacer()
                        }
                        .padding()
                    ) {
                        HStack {
                            Spacer()
                            Button("Login") {
                                UIApplication.shared.endEditing()
                                signIn()
                            }
                            .foregroundColor(.white)
                            .font(.body)
                            Spacer()
                        }
                        .listRowBackground(Color.blue.opacity(email.isEmpty || password.isEmpty ? 0.5 : 1))
                        .disabled(email.isEmpty || password.isEmpty || isSigningIn)
                    }
                }
                .navigationTitle("Login")
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
    }
    
    private func signIn() {
        isSigningIn.toggle()
        DispatchQueue.global().async {
            Amplify.Auth.signIn(username: email, password: password) {
                result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        Amplify.DataStore.start { _ in
                            _ = Amplify.Hub.listen(to: .dataStore) {
                                if $0.eventName == HubPayload.EventName.DataStore.ready {
                                    DispatchQueue.main.async {
                                        UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        isSigningIn.toggle()
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
