//
//  Persistence.swift
//  passwordManager
//
//  Created by Sumit Chandora on 01/06/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "passwordManager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func addItem(account: String, user: String, password: String, context: NSManagedObjectContext) {
        let newItem = UserData(context: context)
        newItem.account_name = account
        newItem.username_email = user
        newItem.password = password
        newItem.time = Date()
        do {
            try context.save()
        } catch {
            fatalError("Error while adding a New Account")
        }
    }
    
    func edit(accountDetails: UserData, accountType: String, user: String, password: String, context: NSManagedObjectContext) {
        accountDetails.account_name = accountType
        accountDetails.username_email = user
        accountDetails.password = password
        accountDetails.time = Date()
        do {
            try context.save()
        }
        catch {
            fatalError("Error While editing the Account Details!")
        }
    }
}
