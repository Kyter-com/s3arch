//
//  ProfilesView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import SimpleKeychain
import SwiftUI

struct ProfilesView: View {
  @State private var showAddNewProfileSheetView: Bool = false
  @State private var showSettingsSheetView: Bool = false
  @State private var profilesState: [String: KeychainData] = [:]
  @State private var searchText: String = ""
  @State private var selectedKey: String = ""
  @State private var showingDeleteAlert: Bool = false

  private let keychainService = KeychainService()

  var body: some View {
    NavigationStack {
      List {
        ForEach(
          profilesState.keys
            .filter { searchText.isEmpty || profilesState[$0]?.name.contains(searchText) ?? false }
            .sorted {
              guard let date1 = profilesState[$0]?.updatedAt,
                let date2 = profilesState[$1]?.updatedAt
              else { return false }
              return date1 > date2
            }, id: \.self
        ) { key in
          if let keychainData = profilesState[key] {
            NavigationLink(destination: BucketsView(keychainData: keychainData)) {
              Text("\(keychainData.name)")
            }
          }
        }
        .onDelete(perform: { indexSet in
          if let index = indexSet.first {
            selectedKey =
              profilesState.keys.sorted {
                guard let date1 = profilesState[$0]?.updatedAt,
                  let date2 = profilesState[$1]?.updatedAt
                else { return false }
                return date1 > date2
              }[index]
            showingDeleteAlert = true
          }
        })
      }
      .alert(isPresented: $showingDeleteAlert) {
        Alert(
          title: Text("Delete Profile"),
          message: Text("Are you sure you want to delete this profile?"),
          primaryButton: .destructive(Text("Delete")) {
            keychainService.deleteProfileFromKeychain(key: selectedKey)
            profilesState.removeValue(forKey: selectedKey)
          },
          secondaryButton: .cancel())
      }
      .navigationTitle("Profiles")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
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
        }
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: {
              showSettingsSheetView.toggle()
            },
            label: {
              Image(systemName: "gearshape")
            }
          ).sheet(
            isPresented: $showSettingsSheetView,
            content: {
              SettingsSheetView()
            })
        }
      }
    }
    .onAppear(perform: loadProfilesState)
    .onChange(of: showAddNewProfileSheetView) {
      if !showAddNewProfileSheetView {
        loadProfilesState()
      }
    }
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Profile name"
    )
  }

  private func loadProfilesState() {
    self.profilesState = keychainService.loadAllProfilesFromKeychain()
  }
}

#Preview {
  ProfilesView()
}
