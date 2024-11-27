//
//  UserIdentityLoginView.swift
//  Falcon
//
//  Created by Arif Ashraf on 01/10/24.
//  Copyright © 2024 Helpshift. All rights reserved.
//

import SwiftUI
import SwiftJWT
import HelpshiftX

struct UserIdentityLoginView: View {
    @State private var identities: [UserIdentity] = []
    @State private var newIdentity = UserIdentity()
    @State private var loginData: [String: Any] = [:]
    @State private var secretKey: String = ""
    @State private var selectedLoginMethod: Int = 0
    @State private var identityToken: String? = ""
    @State private var pastedIdentityToken: String = ""

    // UI State variables
    @State private var identifierKey: String = "identifier"
    @State private var identifierValue: String = ""
    @State private var valueKey: String = "value"
    @State private var identityValue: String = ""
    @State private var metadataKey: String = ""
    @State private var metadataValue: String = ""
    @State private var identitiesJSON: String = ""

    @State private var loginDataKey: String = ""
    @State private var loginDataValue: String = ""
    @State private var loginDataJSON: String = ""
    @State private var loginDataResponse: String = ""
    @State private var loginResponseColor = Color.black

    @State private var selectedDate = Date()
    @State private var iatValue: Int?

    @State private var masterAttributeManager = AttributesManager()
    @State private var appAttributeManager = AttributesManager()

    @State private var loginEvents: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                //MARK: User Identities Section
                SectionView(
                    header: "User Identities",
                    description: "Add user identities here. true/false values for this section are converted to boolean"
                ) {
                    VStack {
                        Picker("Login Method", selection: $selectedLoginMethod) {
                            Text("Add Identities Manually").tag(0)
                            Text("Paste Identity Token").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom)
                        // Show content based on selected login method
                        if selectedLoginMethod == 0 {
                            // Manual Identity Input
                            SectionView(
                                header: "User Identities",
                                description: "Add user identities here."
                            ) {
                                VStack {
                                    HStack {
                                        TextField("identifier", text: $identifierKey)
                                        TextField("Add identifier", text: $identifierValue)
                                    }
                                    HStack {
                                        TextField("value", text: $valueKey)
                                        TextField("Add value", text: $identityValue)
                                    }
                                    HStack {
                                        TextField("iat", text: .constant("iat"))
                                        DatePicker("issuedAt", selection: $selectedDate, displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .onChange(of: selectedDate) { newValue in
                                                iatValue = Int(newValue.timeIntervalSince1970)
                                            }
                                    }
                                    HStack {
                                        TextField("metadata", text: .constant("metadata"))
                                        TextField("key", text: $metadataKey)
                                        TextField("value", text: $metadataValue)
                                        Button("Add") {
                                            addMetadata()
                                        }
                                    }
                                    HStack {
                                        SectionView(
                                            header: "",
                                            description: "Add Identity to Identities Dictionary"
                                        ) {
                                            Button {
                                                addIdentity()
                                            } label: {
                                                Text("Add Identity").frame(maxWidth: .infinity)
                                            }
                                        }
                                        SectionView(
                                            header: "",
                                            description: "Add User Identities JWT to Helpshift.addUserIdentities()"
                                        ) {
                                            Button {
                                                if let token = Util.generateJWT(iat: iatValue, identities: identities, secretKey: secretKey) {
                                                    Helpshift.addUserIdentities(token)
                                                } else {
                                                    print("Error: JWT token is nil.")
                                                }
                                            } label: {
                                                Text("Add User Identities")
                                            }
                                        }
                                    }
                                    HStack {
                                        Text("Identities Preview")
                                            .font(.headline)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(identitiesJSON.isEmpty ? "{}" : identitiesJSON)
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                }
                            }
                        } else {
                            // Paste Identity Token
                            SectionView(header: "Paste Identity Token",
                                        description: "Paste your identity token here."
                            ) {
                                TextEditor(text: $pastedIdentityToken)
                                    .frame(height: 100)
                                    .border(Color.gray)
                            }
                        }
                        HStack {
                            Text("Login Data")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        HStack {
                            TextField("key", text: $loginDataKey)
                            TextField("value", text: $loginDataValue)
                            Button("Add") {
                                addLoginData()
                            }
                        }
                        HStack {
                            Text(loginDataJSON.isBlank ? "{}" : loginDataJSON)
                                .font(.caption)
                            Spacer()
                        }
                        HStack {
                            Text("Secret Key:")
                                .foregroundColor(.gray)
                            TextField("Secret Key", text: $secretKey)
                        }
                        HStack {
                            Button("Login With Identity") {
                                loginWithIdentities()
                            }
                            Button("Login With Anon Identity") {
                                loginIdentity(identityJWT: "")
                            }

                            Button("Reset Identities") {
                                resetIdentities()
                            }
                            .foregroundColor(.red)
                        }
                        HStack {
                            Text("Login Response: ")
                                .foregroundStyle(.gray)
                            Text(loginDataResponse)
                                .foregroundColor(loginResponseColor)
                            Spacer()
                        }
                    }
                }

                Divider()

                //MARK: Master Attributes Section
                SectionView(
                    header: "Update Master Attributes",
                    description: "Add System level data."
                ) {
                    attributeInputView(manager: $masterAttributeManager, type: .master)
                }

                Divider()

                //MARK: App Attributes Section
                SectionView(
                    header: "Update App Attributes",
                    description: "Add App level data"
                ) {
                    attributeInputView(manager: $appAttributeManager, type: .app)
                }

                //MARK: Login Events Section
                SectionView(
                    header: "User Identity Login Events",
                    description: "List of Login Events"
                ) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(loginEvents.indices, id: \.self) { index in
                                let event = loginEvents[index]
                                VStack(alignment: .leading) {
                                    Text(event)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
            .buttonStyle(.bordered)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
            .padding()
        }
        .onAppear {
            fetchUserData()
        }
    }

    private func attributeInputView(manager: Binding<AttributesManager>, type: AttributeType) -> some View {
        VStack {
            HStack {
                TextField("Key", text: manager.attributeKey)
                TextField("Value", text: manager.attributeValue)
                Button("Add") {
                    manager.wrappedValue.addAttribute()
                }
            }
            Divider()
            HStack {
                Text("Custom User Fields")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Spacer()
            }
            HStack {
                TextField("CUF key", text: manager.cufKey)
                TextField("CUF Value", text: manager.cufValue)
                Button("Add") {
                    manager.wrappedValue.addCuf()
                }
            }
            Button {
                manager.wrappedValue.updateAttributes(type: type)
            } label: {
                Text("Update Attributes").frame(maxWidth: .infinity)
            }
            HStack {
                Text("Attributes Preview")
                    .font(.headline)
                    .foregroundStyle(.gray)
                Spacer()
            }
            HStack {
                Text(manager.wrappedValue.attributesJSON)
                    .font(.subheadline)
                Spacer()
            }
        }
    }

    private func addMetadata() {
        if newIdentity.metadata == nil {
            newIdentity.metadata = [:]
        }
        newIdentity.metadata?[metadataKey] = metadataValue
        prepareForNextMetadata()
    }

    private func prepareForNextMetadata() {
        metadataKey = ""
        metadataValue = ""
    }

    private func addIdentity() {
        let newIdentity = UserIdentity(identifierKey: identifierKey,
                                       identifierValue: identifierValue,
                                       valueKey: valueKey,
                                       identityValue: identityValue,
                                       metadata: newIdentity.metadata)
        identities.append(newIdentity)
        prepareForNextIdentity()
        identitiesJSON = getIdentitiesJSON()
    }

    private func prepareForNextIdentity() {
        identifierValue = ""
        identityValue = ""
        self.newIdentity.metadata = nil
    }

    private func getIdentitiesJSON() -> String {
        let identitiesArray = identities.map { identity -> [String: Any] in
            var identityDict: [String: Any] = [
                identity.identifierKey: identity.identifierValue
            ]
            if !identity.identityValue.isEmpty {
                identityDict[identity.valueKey] = identity.identityValue
            }
            if let metadata = identity.metadata {
                identityDict["metadata"] = metadata
            }
            return identityDict
        }
        var jsonDict: [String: Any] = ["identities": identitiesArray]
        let iat = iatValue ?? Int(Date().timeIntervalSince1970)
        jsonDict["iat"] = iat
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? "Error converting JSON data to string"
        } catch {
            return "Error generating JSON: \(error)"
        }
    }

    private func addLoginData() {
        if (loginDataKey.isEmpty || loginDataValue.isEmpty) {
            return
        }
        loginData[loginDataKey] = loginDataValue
        prepareForNextLoginData()
        loginDataJSON = loginData.toJSONString() ?? ""
    }

    private func prepareForNextLoginData() {
        loginDataKey = ""
        loginDataValue = ""
    }

    private func resetIdentities() {
        identities = []
        newIdentity = UserIdentity()
        loginData = [:]
        iatValue = nil
        pastedIdentityToken = ""

        // Reset UI state variables
        identifierKey = "identifier"
        identifierValue = ""
        valueKey = "value"
        identityValue = ""
        metadataKey = ""
        metadataValue = ""
        identitiesJSON = "{}"
        secretKey = ""

        loginDataKey = ""
        loginDataValue = ""
        loginDataJSON = "{}"
        loginDataResponse = ""

        masterAttributeManager = AttributesManager()
        appAttributeManager = AttributesManager()
    }

    func loginWithIdentities() {
        loginDataResponse = "In Progress..."
        if !identities.isEmpty && secretKey.isEmpty {
            loginDataResponse = "Error: Secret key not found"
            loginResponseColor = .red
            print("Error: Secret key not found")
            return
        }
        let jwt = Util.generateJWT(iat: iatValue, identities: identities, secretKey: secretKey)
        identityToken = selectedLoginMethod == 0 ? jwt : pastedIdentityToken
        guard let identityJWT = identityToken else {
            print("Error: JWT token could not be generated")
            return
        }
        print("Generated JWT Token: \(identityJWT)")
        loginIdentity(identityJWT: identityJWT)
    }

    private func loginIdentity(identityJWT: String) {
        Helpshift.login(withIdentity: identityJWT, config: loginData) {
            loginDataResponse = "Login succeeded"
            loginResponseColor = .green
            logEvent("Login succeeded")
            storeUserData(token: identityJWT)
        } failure: { reason, data in
            loginDataResponse = "Login failed: \(reason)\nData: \(data ?? [:])"
            loginResponseColor = .red
            logEvent("\(loginDataResponse)")
        }
    }

    private func logEvent(_ event: String) {
        loginEvents.append(event)
    }

    private func fetchUserData() {
        identitiesJSON = AppData.identitiesJson
        loginDataJSON = AppData.identityLoggedInData
        pastedIdentityToken = AppData.identityJwtToken
        secretKey = AppData.secretKey
    }

    private func storeUserData(token:String) {
        AppData.saveIdentityLoginData(loginDataJSON)
        AppData.saveIdentitesJson(identitiesJSON)
        AppData.saveIdentityJWTToken(token)
        AppData.saveSecretKey(secretKey)
    }
}

struct SectionView<Content: View>: View {
    let header: String
    let description: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.title3)
                .bold()
            if !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Divider()
            content()
            Spacer()
        }
        .padding(.bottom)
    }
}

#Preview {
    UserIdentityLoginView()
}
