//
//  VerificationView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct VerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var verificationCode = ""
    @State private var isLoading = false
    @State private var error = ""
    @State private var showSuccessView = false
    @Binding var showLoginView: Bool
    var email: String
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isLoading)
            SuccessView(isPresented: $showSuccessView, text: "Success")
            Form {
                ErrorSection(error: $error)
                Section(
                    header: Text("Please enter verification code we sent to your email address.").textCase(.none),
                    footer: Text("If you don't do this, you are not able to sign in, and you cannot sign up with this email again. Please don't close the App now").textCase(.none)
                ) {
                    TextField("Verification Code", text: $verificationCode)
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Verify") {
                            UIApplication.shared.endEditing()
                            confirmSignUp()                            
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .disabled(verificationCode.isEmpty)
                    .listRowBackground(Color.blue.opacity(verificationCode.isEmpty ? 0.5 : 1))
                }
            }
            .disabled(isLoading)
        }
        .navigationTitle("Verification")
    }
    
    private func confirmSignUp() {
        isLoading.toggle()
        DispatchQueue.global().async {
            Amplify.Auth.confirmSignUp(for: email, confirmationCode: verificationCode) {
                result in
                DispatchQueue.main.async {
                    isLoading.toggle()
                    switch result {
                    case .success:
                        showSuccessView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessView.toggle()
                            presentationMode.wrappedValue.dismiss()
                            showLoginView.toggle()
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(showLoginView: .constant(true), email: "123@wustl.edu")
    }
}
