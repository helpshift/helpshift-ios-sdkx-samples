//
//  DebugSection.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI

struct DebugSection: View {
    @State private var showPurgeAlert = false
    @State private var showChangeSettingsSheet = false
    @State private var webviewInspectable = AppData.webviewInspectable

    var body: some View {
        Section("Debug") {
            Button("Change SDK internal settings") {
                showChangeSettingsSheet = true
            }.sheet(isPresented: $showChangeSettingsSheet) {
                SdkSettingsView().wrapSheetContent()
            }
            Toggle("Set SDK Webviews Inspectable", isOn: $webviewInspectable)
            Button("Purge all data", role: .destructive) {
                showPurgeAlert = true
            }
        }.alert("All App and SDK data will be cleared!", isPresented: $showPurgeAlert) {
            Button("PURGE", role: .destructive) {
                DebugAppData.purgeData()
            }
            Button("Cancel", role: .cancel) {
                showPurgeAlert = false
            }
        }.onChange(of: webviewInspectable) { newValue in
            AppData.saveWebviewInspectable(newValue)
        }
    }
}

struct SdkSettingsView: View {
    @State var domain = DebugAppData.domain
    @State var platformId = DebugAppData.platformId
    @State var webchatUrl = DebugAppData.webchatUrl
    @State var helpcenterUrl = DebugAppData.helpcenterUrl
    @State var helpcenterSandbox = DebugAppData.helpcenterSandbox
    @State var saveInProgress = false

    var body: some View {
        VStack(alignment: .leading) {
            safeTextField("Domain", text: $domain)
            safeTextField("Platform ID", text: $platformId)
            safeTextField("Webchat URL", text: $webchatUrl)
            safeTextField("Helpcenter URL", text: $helpcenterUrl)
            Toggle("Is Helpcenter Sandbox?", isOn: $helpcenterSandbox)
            Button(saveInProgress ? "Saving & Killing app..." : "Save & Kill app") {
                DebugAppData.saveDomain(domain)
                DebugAppData.savePlatformId(platformId)
                DebugAppData.saveWebchatUrl(webchatUrl)
                DebugAppData.saveHelpcenterUrl(helpcenterUrl)
                DebugAppData.saveHelpcenterSandbox(helpcenterSandbox)
                saveInProgress = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }
            .disabled(saveButtonDisabled)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }.padding()
    }

    @ViewBuilder private func safeTextField(_ titleKey: LocalizedStringKey, text: Binding<String>) -> some View {
        Text(titleKey)
        if #available(iOS 16.0, *) {
            TextField(titleKey, text: text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
        } else {
            TextField(titleKey, text: text)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
        }
    }

    private var saveButtonDisabled: Bool {
        saveInProgress || domain.isBlank || platformId.isBlank ||
        webchatUrl.isBlank || helpcenterUrl.isBlank
    }
}

struct DebugSection_Previews: PreviewProvider {
    static var previews: some View {
        SdkSettingsView()
    }
}
