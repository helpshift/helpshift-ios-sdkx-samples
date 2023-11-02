//
//  ConfigView.swift
//  Falcon
//
//  Created by Joyson P S on 09/08/23.
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI
import UIKit

struct ConfigView: View {

    @State private var selectedCifType = "singleline"
    @State private var showConfig = false
    @State private var tags = ""
    @State private var configKey = ""
    @State private var configValue = ""
    @State private var cifKey = ""
    @State private var cifValue = ""
    @Binding var config: [String: Any]

    static let defaultConfig: [String: Any] = ["fullPrivacy": true,
                                               "tags":  "",
                                               "enableContactUs": "ALWAYS",
                                               "enableFullPrivacy": false,
                                               "initiateChatOnLoad": false,
                                               "presentFullScreenOniPad": true,
                                               "conversationPrefillText": "Hi...!",
                                               "initialUserMessage": "Hello world..!",
                                               "cifs": defaultCifs]

    private static let defaultCifs: [String: Any] = ["joining_date": ["type": "date", "value": 1505927361535] as [String : Any],
                                                     "stock_level": ["type": "number", "value": "667"],
                                                     "employee_name": ["type": "singleline", "value": "Sweeney Todd"],
                                                     "employee_address": ["type": "multiline", "value": "Sweeney Todd\nDemon Barber\nFleet Street"],
                                                     "is_pro": ["type": "checkbox", "value": "true"]]

    private static let cifTypes = ["singleline", "multiline", "number",
                                   "dropdown", "date", "checkbox"]

    private static let contactUsValues = ["ALWAYS", "AFTER_MARKING_ANSWER_UNHELPFUL",
                                          "AFTER_VIEWING_FAQS", "NEVER"]

    var body: some View {
        List {
            Section("Tags") {
                TextField("Comma-separated tags", text: $tags)
                    .onChange(of: tags) { newValue in
                        config["tags"] = newValue.components(separatedBy: ",").filter { !$0.isBlank }
                    }
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }

            Section("Config Setup") {
                Toggle("Enable Full Privacy", isOn: binding(for: "fullPrivacy"))
                Toggle("Initiate Chat On Load", isOn: binding(for: "initiateChatOnLoad"))
                Toggle("Present Full Screen On iPad", isOn: binding(for: "presentFullScreenOniPad"))
                Picker("Enable Contact Us", selection: binding(for: "enableContactUs") as Binding<String>) {
                    ForEach(Self.contactUsValues, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.menu)
                VStack(alignment:.leading) {
                    Text("Conversation Prefill Text")
                        .font(.footnote)
                        .bold()
                    HStack {
                        TextField("Conversation Prefill Text", text: binding(for: "conversationPrefillText"))
                            .textFieldStyle(.roundedBorder)
                        Button("Clear") {
                            config.removeValue(forKey: "conversationPrefillText")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                VStack(alignment:.leading) {
                    Text("Initial User Message")
                        .font(.footnote)
                        .bold()
                    HStack {
                        TextField("Initial  User Message", text: binding(for: "initialUserMessage"))
                            .textFieldStyle(.roundedBorder)
                        Button("Clear") {
                            config.removeValue(forKey: "initialUserMessage")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                VStack(alignment:.leading) {
                    Text("Custom Key Value")
                        .font(.footnote)
                        .bold()
                    HStack {
                        TextField("Key", text: $configKey)
                        TextField("Value", text: $configValue)
                        Button("Add") {
                            config[configKey] = parseConfigValues(value: configValue);
                            configKey = ""
                            configValue = ""
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .disabled(configKey.isEmpty || configValue.isEmpty)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            }

            Section("Cusom Issue Fields") {
                HStack {
                    TextField("Key", text: $cifKey)
                    TextField("Value", text: $cifValue)
                }
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                HStack {
                    Picker("Type", selection: $selectedCifType) {
                        ForEach(Self.cifTypes, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    Spacer()
                    Button("Add Cifs") {
                        if var cifs = config["cifs"] as? [String: Any] {
                            cifs[cifKey] = ["type": selectedCifType, "value": parseConfigValues(value: cifValue)]
                            config["cifs"] = cifs
                        } else {
                            config["cifs"] = [cifKey: ["type": selectedCifType, "value": parseConfigValues(value: cifValue)]]
                        }
                        cifKey = ""
                        cifValue = ""
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .disabled(cifKey.isEmpty || cifValue.isEmpty || selectedCifType.isBlank)
                }
            }

            Section("Other") {
                Button("Reset Config") {
                    selectedCifType = "singleline"
                    showConfig = false
                    tags = ""
                    configKey = ""
                    configValue = ""
                    cifKey = ""
                    cifValue = ""
                    config = ConfigView.defaultConfig
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                DisclosureGroup("Show Config JSON", isExpanded: $showConfig) {
                    ZStack(alignment:.topTrailing) {
                        Button(action: {
                            UIPasteboard.general.string = self.configAsJSON
                        }) {
                            Image(systemName: "clipboard")
                        }
                        Text(configAsJSON)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .navigationTitle("Helpshift Config")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var configAsJSON: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: config, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting config to JSON: \(error)")
        }
        return "Error converting config to JSON"
    }

    private func parseConfigValues(value: String) -> Any {
        if value.lowercased() == "true" || value.lowercased() == "false" {
            return value.lowercased() == "true"
        } else if let intValue = Int(value) {
            return intValue
        }
        return value
    }

    func binding(for key: String) -> Binding<Bool> {
        return Binding(get: {
            return self.config[key] as? Bool ?? false
        }, set: {
            self.config[key] = $0
        })
    }

    func binding(for key: String) -> Binding<String> {
        return Binding(get: {
            return self.config[key] as? String ?? ""
        }, set: {
            self.config[key] = $0
        })
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(config: .constant([:]))
    }
}

