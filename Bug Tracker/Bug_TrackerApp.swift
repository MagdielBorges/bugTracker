//
//  Bug_TrackerApp.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

@main
struct Bug_TrackerApp: App {
    @StateObject var store = StorageProvider()
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environment(\.managedObjectContext, store.persistentContainer.viewContext)
                .environmentObject(store)
        }
    }
}
