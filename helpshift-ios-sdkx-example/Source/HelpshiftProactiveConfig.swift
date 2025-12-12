import Foundation
import HelpshiftX

class HelpshiftProactiveConfig: NSObject, HelpshiftProactiveAPIConfigCollectorDelegate {
    func getAPIConfig() -> [AnyHashable : Any] {
        return ["firstUserMessage": "Hi there!",
                "fullPrivacy": true,
                "contactUsVisibility": 1,
                "tags": ["vip", "payment", "blocked", "renewal"],
                "customMetadata": ["vip": "yes",
                                   "level": "7",
                                   "user": "paid",
                                   "score": "12"],
                "cifs": ["joining_date": ["type": "date", "value": 1685946802123] as [String : Any],
                         "stock_level": ["type": "number", "value": "1034"],
                         "employee_name": ["type": "singleline", "value":"Proactive User"]]]
    }
}
