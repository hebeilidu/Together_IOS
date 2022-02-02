//
//  SettingView.swift
//  Together
//
//  Created by lcx on 2021/11/28.
//

import SwiftUI
import Amplify

struct SettingView: View {
    @StateObject private var user = UserViewModel()
    @State private var isShowingPhotoPicker = false
    @State private var isEditing = false
    @State private var error = ""
    @State private var needChangePassword = false
    @State private var showSuccessView = false
    
    var body: some View {
        ZStack {
            SuccessView(isPresented: $showSuccessView, text: "Profile Updated")
            NavigationView {
                Form {
                    ErrorSection(error: $error)
                    Section(
                        footer: Text("Click above image to change profile photo")
                    ) {
                        HStack {
                            if let image = user.profilePhoto {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 75, height: 75, alignment: .center)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        isShowingPhotoPicker = true
                                    }
                                    .sheet(isPresented: $isShowingPhotoPicker) {
                                        PhotoPicker(image: $user.profilePhoto, error: $error)
                                    }
                            }
                            VStack(alignment: .leading) {
                                Text(user.nickname)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                Text(user.email)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    Section(header:
                        HStack {
                            Text("PROFILE")
                            Spacer()
                            if isEditing {
                                Button("Done") {
                                    UIApplication.shared.endEditing()
                                    isEditing.toggle()
                                    updateAttributes()
                                }
                                .transition(AnyTransition.opacity.animation(.easeIn))
                            } else {
                                Button("Edit") { isEditing.toggle() }
                                    .transition(AnyTransition.opacity.animation(.easeIn))
                            }
                        }
                        .textCase(.none)
                    ) {
                        HStack {
                            Text("First Name")
                            TextField("", text: $user.firstName)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Last Name")
                            TextField("", text: $user.lastName)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                                .disabled(!isEditing)
                        }
                        Picker(selection: $user.gender, label: Text("Gender")) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                        .disabled(!isEditing)
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Change Password") { needChangePassword.toggle() }
                                .sheet(isPresented: $needChangePassword) {
                                    ChangePasswordView()
                                }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button("Log Out") { signOut() }.foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Setting")
            }
        }
    }
    
    private func signOut() {
        Amplify.Auth.signOut() {
            switch $0 {
            case .success:
                DispatchQueue.global().async {
                    Amplify.DataStore.stop { _ in
                        Amplify.DataStore.clear() { _ in
                            DispatchQueue.main.async {
                                UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SignUpView())
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error.errorDescription
                }
            }
        }
    }
    
    private func updateAttributes() {
        DispatchQueue.global().async {
            let userAttributes = [
                AuthUserAttribute(.givenName, value: user.firstName),
                AuthUserAttribute(.familyName, value: user.lastName),
                AuthUserAttribute(.gender, value: user.gender),
                AuthUserAttribute(.phoneNumber, value: "+11111111111")
            ]
            Amplify.Auth.update(userAttributes: userAttributes) {
                result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        showSuccessView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessView.toggle()
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
