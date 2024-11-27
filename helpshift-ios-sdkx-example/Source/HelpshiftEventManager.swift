//
//  HelpshiftEventManager.swift
//  Falcon
//
//  Created by Arif Ashraf on 10/10/24.
//  Copyright © 2024 Helpshift. All rights reserved.
//

import Foundation
import HelpshiftX

struct EventMessage: Identifiable {
    let id = UUID()
    let message: String
}

class EventManager: ObservableObject {
    @Published var messages: [EventMessage] = []
    static let shared = EventManager()
    private init() {}

    private func addEvent(_ eventName: String, withData data: [AnyHashable : Any]?) {
        let dataDescription = data != nil ? "\(data ?? [:])" : "No event data"
        let message = "Helpshift event received: \(eventName).\nEvent Data: \(dataDescription)"
        print(message)
        messages.append(EventMessage(message: message))
    }

    func handleEvent(_ eventName: String, withData data: [AnyHashable : Any]?) {
        addEvent(eventName, withData: data)
        if (eventName == HelpshiftEventUserSessionExpired) {
            let config = AppData.identityLoggedInData.toDictionary ?? [:]
            let identitiesJson = AppData.identitiesJson
            let newIat = Int(Date().timeIntervalSince1970)
            if identitiesJson.isEmpty {
                print("No identities found in saved data.")
                return
            }
            do {
                guard let identitiesDict = identitiesJson.toDictionary else {
                    print("Failed to convert identities json to a dictionary.")
                    return
                }
                guard let identitiesArray = identitiesDict["identities"] as? [[String: Any]] else {
                    print("Error: 'identities' key not found in the decoded dictionary.")
                    return
                }
                let decodedIdentities: [UserIdentity] = try Util.decode(from: identitiesArray)
                guard let newJwtToken = Util.generateJWT(iat: newIat, identities: decodedIdentities, secretKey: AppData.secretKey) else {
                    print("Error generating JWT.")
                    return
                }
                print("Generated JWT for relogin: \(newJwtToken)")
                reLoginUser(withToken: newJwtToken, config: config)
            } catch {
                print("Error processing identities data: \(error)")
            }
        }
    }

    private func reLoginUser(withToken jwtToken: String, config: [String: Any]) {
        Helpshift.login(withIdentity: jwtToken, config: config) {
            print("Successfully re-logged in the user on session expired")
            AppData.saveIdentityJWTToken(jwtToken)
        } failure: { reason, data in
            print("Failed to re-login user on session expired")
        }
    }

}
