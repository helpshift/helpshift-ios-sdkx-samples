//
//  ContentView.swift
//  HSSDKSwiftUISample
//
//  Created by Sagar Dagdu on 28/05/21.
//

import SwiftUI
import HelpshiftX

struct ContentView: View {
    
    @State var setLanguageSelected: Bool = false
    
    var body: some View {
        NavigationView {
            List(DemoAction.allCases) { demoActionRow in
                if demoActionRow == .setLanguage {
                    NavigationLink(destination: ChangeLanguageView(languageCode: ""), isActive: $setLanguageSelected) {
                        DemoActionRow(title: demoActionRow.displayTitle) {
                            setLanguageSelected = true
                        }
                    }
                } else {
                    DemoActionRow(title: demoActionRow.displayTitle) {
                        demoActionRow.execute()
                    }
                }
            }.navigationTitle("SDK-X SwiftUI Demo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK:- Action handling

fileprivate enum DemoAction: Int, CaseIterable, Identifiable {
    case showConversation
    case showFaqs
    case showFaqSection
    case showSingleFaq
    case setLanguage
    
    var id: String {
        get { return displayTitle }
    }

    var displayTitle: String {
        get {
            switch self {
            case .showConversation:
                return "Show Conversation"
            case .showFaqs:
                return "Show Faqs"
            case .showFaqSection:
                return "Show FAQ Section"
            case .showSingleFaq:
                return "Show Single FAQ!"
            case .setLanguage:
                return "Set Language"
            }
        }
    }
    
    func execute() {
        switch self {
        case .showConversation:
            Helpshift.showConversation(with: UIUtils.topViewController()!, config: nil)
        case .showFaqs:
            Helpshift.showFAQs(with: UIUtils.topViewController()!, config: nil)
        case .showFaqSection:
            #warning("TODO: Replace the SECTION-ID with appropriate section id")
            Helpshift.showFAQSection("SECTION-ID", with: UIUtils.topViewController()!, config: nil)
        case .showSingleFaq:
            #warning("TODO: Replace the FAQ-PUBLISH-ID with appropriate faq publish id")
            Helpshift.showSingleFAQ("FAQ-PUBLISH-ID", with: UIUtils.topViewController()!, config: nil)
        case .setLanguage:
            print("setlanguage tapped")
        }
    }
}
