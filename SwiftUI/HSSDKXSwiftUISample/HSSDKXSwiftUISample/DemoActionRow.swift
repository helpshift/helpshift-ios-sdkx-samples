//
//  DemoActionRow.swift
//  HSSDKXSwiftUISample
//
//  Created by Sagar Dagdu on 28/05/21.
//

import SwiftUI

struct DemoActionRow: View {
    var title: String
    let callback: (() -> Void)?
    
    var body: some View {
        Button(action: {
            callback?()
        }, label: {
            HStack {
                Text(title)
                    .font(.body)
                    .padding(.leading, 8)
                    .foregroundColor(.black)
                Spacer()
            }
        }).buttonStyle(BorderlessButtonStyle())
    }
}

struct DemoActionRow_Previews: PreviewProvider {
    static var previews: some View {
        DemoActionRow(title: "Change Language!") {
            
        }
    }
}
