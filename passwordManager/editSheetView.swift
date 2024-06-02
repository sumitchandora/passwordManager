//
//  sheetView.swift
//  passwordManager
//
//  Created by Sumit Chandora on 01/06/24.
//

import SwiftUI
import CoreData

struct EditSheetView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @State var account = "Facebook"
    @State var user = "Sumit Chandora"
    @State var password = "12dbbi32j23bf2ib"
    @State var showPassword = false
    @State var enableEdit = false
    
    var items: FetchedResults<UserData>.Element?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Account Details")
                    .font(.system(size: 25))
                    .foregroundStyle(.blue)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.vertical, 40)
            Text("Account Type")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
            if enableEdit {
                TextField(account, text: $account)
                    .font(.title3)
                    .bold()
            } else {
                Text(account)
                    .font(.title3)
                    .bold()
            }
            Text("Username/Email")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
            
            var customText: AttributedString {
                var attributedString = AttributedString(user)
                attributedString.foregroundColor = .black
                return attributedString
            }
            if enableEdit {
                TextField("\(customText)", text: $user)
                    .font(.title3)
                    .bold()
            } else {
                Text("\(customText)")
                    .font(.title3)
                    .bold()
            }
            Text("Password")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
            HStack {
                if enableEdit {
                    TextField(password, text: $password)
                        .font(.title3)
                        .bold()
                } else {
                    showPassword ? Text(password).font(.title3)
                        .bold() : Text(String(repeating: "*", count: password.count))
                        .font(.title3)
                        .bold()
                }
                Spacer()
                Image(systemName: showPassword ? "eye" : "eye.slash")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        showPassword.toggle()
                    }
            }
            HStack {
                if enableEdit {
                    Button(action: {
                        enableEdit.toggle()
                        PersistenceController.shared.edit(accountDetails: items!, accountType: account, user: user, password: password, context: viewContext)
                        dismiss()
                    }, label: {
                        Text("Done")
                            .bold()
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight:  55)
                            .background(.black.opacity(0.8))
                            .cornerRadius(30)
                            .foregroundStyle(.white)
                    })
                } else {
                    Button(action: {
                        enableEdit.toggle()
                    }, label: {
                        Text("Edit")
                            .bold()
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight:  55)
                            .background(.black.opacity(0.8))
                            .cornerRadius(30)
                            .foregroundStyle(.white)
                    })
                }
                    Button(action: {
                        deleteItem(accountName: account)
                        dismiss()
                    }, label: {
                        Text("Delete")
                            .foregroundStyle(.white)
                            .bold()
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 55)
                            .background(.red)
                            .cornerRadius(30)
                    })
                }
                    .padding(.vertical, 25)
                
            }
            .padding(.horizontal, 20)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(30)
            .onAppear {
                account = items?.account_name ?? ""
                user = items?.username_email ?? ""
                password = items?.password ?? ""
            }
        }
    private func deleteItem(accountName account: String) {
            let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "account_name == %@", account)

            do {
                let items = try viewContext.fetch(fetchRequest)
                for item in items {
                    viewContext.delete(item)
                }
                try viewContext.save()
            } catch {
                fatalError("Error in deleting an Account!")
            }
        }
}

#Preview {
    EditSheetView()
}
