import Foundation
import HelpshiftX

struct DeepLinkHandler {
    static func handle(_ url: URL) {
        // Deep link structure: falcon://<host>/<path>
        // Examples:
        // falcon://home
        // falcon://chat
        // falcon://section/<publishId>
        // falcon://faq/<publishId>

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let scheme = components.scheme,
              scheme == "falcon" else {
            return
        }

        guard let host = components.host else {
            print("Invalid deep link: missing host")
            return
        }

        switch host {
        case "home":
             Helpshift.showFAQs(withConfig: nil)
        case "chat":
            Helpshift.showConversation(withConfig: nil)
        case "section":
             let path = components.path
             let publishId = String(path.dropFirst()) // Remove leading slash
             if !publishId.isEmpty {
                 Helpshift.showFAQSection(publishId, withConfig: nil)
             }
        case "faq":
            let path = components.path
            let publishId = String(path.dropFirst()) // Remove leading slash
            if !publishId.isEmpty {
                Helpshift.showSingleFAQ(publishId, withConfig: nil)
            }
        default:
            print("Deep link host not recognized: \(host)")
        }
    }
}
