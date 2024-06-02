//
//  passwordManagerApp.swift
//  passwordManager
//
//  Created by Sumit Chandora on 01/06/24.
//

import SwiftUI

@main
struct passwordManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
