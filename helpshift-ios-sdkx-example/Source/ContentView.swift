//
//  ContentView.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI
import HelpshiftX

struct ContentView: View {

    @State private var pauseInAppNotification = false
    @State private var faqSectionId = ""
    @State private var faqId = ""
    @State private var language: Language = Language(rawValue: AppData.language) ?? .custom
    @State private var languageStr = AppData.language
    @State private var breadCrumb = ""
    @State private var log = ""
    @State private var config: [String: Any] = ConfigView.defaultConfig

    var body: some View {
        List {
            Section("User") {
                userViews
            }
            Section("Config Setup") {
                NavigationLink("Change Config") {
                    ConfigView(config: $config)
                }.foregroundColor(.accentColor)
            }
            Section("Conversation") {
                conversationViews
            }
            Section("Help Center") {
                helpcenterViews
            }
            Section("Language") {
                languageViews
            }
            Section("Breadcrumb & Log") {
                logViews
                breadcrumbViews
            }

        }.onChange(of: language) { newValue in
            if case .custom = language {
                // Do nothing
            } else {
                languageStr = newValue.rawValue
            }
        }.onChange(of: pauseInAppNotification) { newValue in
            Helpshift.pauseDisplayOf(inAppNotification: newValue)
        }.navigationTitle("Helpshift Demo")
    }

    @ViewBuilder private var userViews: some View {
        NavigationLink("Login") {
            LoginView()
        }.foregroundColor(.accentColor)
        Button("Logout") {
            Helpshift.logout()
        }
    }

    @ViewBuilder private var conversationViews: some View {
        Button("Open Conversation") {
            Helpshift.showConversation(withConfig: config)
        }
        Button("Request unread message count remotely") {
            Helpshift.requestUnreadMessageCount(true)
        }
        Button("Request unread message count locally") {
            Helpshift.requestUnreadMessageCount(false)
        }
        Toggle("Pause display of In-App notification", isOn: $pauseInAppNotification)
    }

    @ViewBuilder private var helpcenterViews: some View {
        Button("Open Help Center") {
            Helpshift.showFAQs(withConfig: config)
        }
        HStack {
            TextField("FAQ Section ID", text: $faqSectionId)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            let id = Int(faqSectionId)
            Button("Show FAQ Section") {
                Helpshift.showFAQSection(faqSectionId, withConfig: config)
            }
            .buttonStyle(.borderless)
            .disabled(id == nil)
        }
        HStack {
            TextField("FAQ Section ID", text: $faqId)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            let id = Int(faqId)
            Button("Show Single FAQ") {
                Helpshift.showSingleFAQ(faqId, withConfig: config)
            }
            .buttonStyle(.borderless)
            .disabled(id == nil)
        }
    }

    @ViewBuilder private var languageViews: some View {
        HStack {
            TextField("", text: $languageStr)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .disabled(disableLanguageTextField)
            Picker("", selection: $language) {
                ForEach(Language.allCases, id: \.self) { language in
                    Text(language.title).lineLimit(1)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
        Button("Set language") {
            AppData.saveLanguage(languageStr)
            Helpshift.setLanguage(languageStr)
        }.disabled(languageStr.isBlank)
        Button("Reset language") {
            AppData.saveLanguage("")
            Helpshift.setLanguage(nil)
            language = .custom
            languageStr = ""
        }.foregroundColor(.red)
    }

    @ViewBuilder private var breadcrumbViews: some View {
        HStack {
            TextField("", text: $breadCrumb)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            Button("Leave breadcrumb") {
                Helpshift.leaveBreadcrumb(breadCrumb)
            }
            .buttonStyle(.borderless)
            .disabled(breadCrumb.isBlank)
        }
        Button("Clear all breadcrumbs") {
            Helpshift.clearBreadcrumbs()
        }.foregroundColor(.red)
    }

    @ViewBuilder private var logViews: some View {
        HStack {
            TextField("", text: $log)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            Button("Add Log") {
                Helpshift.addLog(log)
            }
            .buttonStyle(.borderless)
            .disabled(log.isBlank)
        }
    }


    private var disableLanguageTextField: Bool {
        if case .custom = language {
            return false
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
