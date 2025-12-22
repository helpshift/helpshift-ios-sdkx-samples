import Foundation
import HelpshiftX

class HelpshiftDelegates: NSObject, HelpshiftDelegate {
    func handleHelpshiftEvent(_ eventName: String, withData data: [AnyHashable : Any]?) {
        EventManager.shared.handleEvent(eventName, withData: data)
    }

    func authenticationFailedForUser(with reason: HelpshiftAuthenticationFailureReason) {
        let reasonString = {
            switch reason {
            case .authTokenNotProvided: return "Auth token not provided"
            case .invalidAuthToken: return "Invalid auth token"
            @unknown default: return "Unknown"
            }
        }()
        print("Helpshift user authentication failed. Reason: \(reasonString)")
    }
}
