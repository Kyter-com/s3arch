//
//  KeychainData.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/16/23.
//

import Foundation
import SimpleKeychain

struct KeychainData: Codable {
  let accessKey: String
  let accessKeySecret: String
  let region: String
  let name: String
  let updatedAt: Date
}

struct KeychainService {
  let simpleKeychain = SimpleKeychain()
  let decoder = JSONDecoder()

  func loadAllProfilesFromKeychain() -> [String: KeychainData] {
    do {
      let keys = try simpleKeychain.keys()
      var dataForKeys: [String: KeychainData] = [:]

      for key in keys {
        if let data = try? simpleKeychain.data(forKey: key),
          let keychainData = try? decoder.decode(KeychainData.self, from: data)
        {
          dataForKeys[key] = keychainData
        }
      }
      return dataForKeys
    } catch {
      print(error.localizedDescription)
      return [:]
    }
  }

  func deleteProfileFromKeychain(key: String) {
    do {
      try simpleKeychain.deleteItem(forKey: key)
    } catch {
      print(error.localizedDescription)
    }
  }
}
