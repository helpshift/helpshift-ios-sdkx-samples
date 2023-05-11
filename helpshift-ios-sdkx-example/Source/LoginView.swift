//
//  LoginView.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI
import HelpshiftX

private let infoText: LocalizedStringKey = "Secret key is used here for demo purposes. This key should NOT be included in your app's code. You should generate the token from your own backend service using this secret key. Refer [here](https://support.helpshift.com/hc/en/13-helpshift-technical-support/faq/880-user-identity-verification-how-do-i-configure-the-endpoint-and-my-app-web-chat-widget-for-user-identity-verification/)."

struct LoginView: View {
    @State var userId = ""
    @State var userName = ""
    @State var userEmail = ""
    @State var secretKey = ""
    @State var authEnabled = false
    @State var clearAnonUser = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                TextField("Enter User ID", text: $userId)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                TextField("Enter User Name", text: $userName)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                TextField("Enter User Email", text: $userEmail)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                Toggle("Enable Authentication", isOn: $authEnabled.animation())
                if authEnabled {
                    TextField("Enter Secret Key from Dashboard", text: $secretKey)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .disabled(!authEnabled)
                    HStack(alignment: .top) {
                        Image(systemName: "info.circle.fill")
                        Text(infoText)
                    }.foregroundColor(.gray)
                }
                Button {
                    login()
                } label: {
                    Text("Login").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(loginButtonDisabled)
                Toggle("Clear anonymous user on login?", isOn: $clearAnonUser)
            }
        }
        .navigationTitle("Helpshift Login")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onChange(of: clearAnonUser) { newValue in
            Helpshift.clearAnonymousUser(onLogin: newValue)
        }
    }

    private var loginButtonDisabled: Bool {
        if userId.isBlank && userEmail.isBlank {
            return true
        }
        if authEnabled && secretKey.isBlank {
            return true
        }
        return false
    }

    private func login() {
        var loginData = ["userId": userId,
                         "userName": userName,
                         "userEmail": userEmail]
        if authEnabled {
            let hmac = MockUserAuthTokenServer.generateHMAC(userId, userEmail, secretKey)
            loginData["userAuthToken"] = hmac
        }
        Helpshift.loginUser(loginData)
        dismiss()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
