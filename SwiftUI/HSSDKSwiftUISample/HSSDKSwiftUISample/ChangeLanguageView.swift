//
//  ChangeLanguageView.swift
//  HSSDKSwiftUISample
//
//  Created by Sagar Dagdu on 31/05/21.
//

import SwiftUI
import HelpshiftX

struct ChangeLanguageView: View {
    @State var languageCode: String

    var body: some View {
        VStack {
            TextField("Enter language code", text: $languageCode)
                .padding(12)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Spacer()
            Button("Change language!") {
                print("Changing language to", languageCode)
                if !languageCode.isEmpty {
                    Helpshift.setLanguage(languageCode)
                }
            }
            Spacer()
        }.navigationTitle("Change Language")
    }
}

struct ChangeLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeLanguageView(languageCode: "")
            .preferredColorScheme(.dark)
    }
}
