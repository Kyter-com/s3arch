//
//  KeysSheetView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import SwiftUI

struct KeysSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var accessKeyInput: String = "";
    @State private var accessKeySecretInput: String = "";
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // TODO: Add Icons
                    // TODO: Use secure fields probably
                    TextField("AWS Access Key", text: $accessKeyInput)
                    TextField("AWS Access Key Secret", text: $accessKeySecretInput)
                } header: {
                    Text("AWS Credentials")
                }
//                Section {
//                    Button(action: {
//                        dismiss()
//                    }, label: {
//                        HStack {
//                            Spacer()
//                            Text("Submit")
//                            Spacer()
//                        }
//                    })
//                }
            }.toolbar {
                Button("Save", action: {
                    dismiss()
                })
            }
            .navigationTitle("Settings")
        }
        
    }
}

#Preview {
    KeysSheetView()
}

