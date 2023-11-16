//
//  ProfilesView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import SwiftUI

struct ProfilesView: View {

  @State private var showAddNewProfileSheetView = false

  var body: some View {
    NavigationStack {
      Form {

      }.navigationTitle("Profiles").toolbar {
        Button(
          action: {
            showAddNewProfileSheetView.toggle()
          },
          label: {
            Image(systemName: "plus.circle")
          }
        ).sheet(
          isPresented: $showAddNewProfileSheetView,
          content: {
            AddNewProfileSheetView()
          })
      }.onAppear(perform: loadKeychainData)
    }
  }
}

private func loadKeychainData() {
  let data = KeychainHelper.standard.read(service: "s3arch", account: "test")!
  let readable = String(data: data, encoding: .utf8)!
    
    let accounts = getKeychainAccounts()

  print("data", readable)
    print("accounts", accounts)
}

func getKeychainAccounts() -> [String] {
    var accounts: [String] = []
    
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "s3arch", // change this line to match your service account value
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitAll
    ]
    
    var result: CFTypeRef?
    let operationStatus = SecItemCopyMatching(query as CFDictionary, &result)
    
    let resultArray = result as! [NSDictionary]
    
    switch operationStatus {
    case errSecSuccess:
        resultArray.forEach { item in
            if let accountData = item[kSecAttrAccount as String] as? Data,
               let account = String(data: accountData, encoding: String.Encoding.utf8) {
                print("key: \(account)")
                accounts.append(account)
            }
            
        }
    default:
        print("No one item found")
    }
    return accounts
}

#Preview {
  ProfilesView()
}
