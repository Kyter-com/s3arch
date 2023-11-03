//
//  KeysView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/3/23.
//

import SwiftUI

struct KeysView: View {
    @State private var accessKeyInput: String = "";
    @State private var accessKeySecretInput: String = "";
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        // TODO: Add Icons
                        // TODO: Use secure fields probably
                        TextField("AWS Access Key", text: $accessKeyInput)
                        TextField("AWS Access Key Secret", text: $accessKeySecretInput)
                    } header: {
                        Text("Credentials")
                    }
                    Section {
                        Button(action: {}, label: {
                            HStack {
                                Spacer()
                                Text("Submit")
                                Spacer()
                            }
                        })
                    }
                }.navigationTitle(Text("Credentials Setup"))
            }
        }
    }
}

#Preview {
    KeysView()
}
