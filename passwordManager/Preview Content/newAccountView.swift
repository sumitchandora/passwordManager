//
//  newAccountView.swift
//  passwordManager
//
//  Created by Sumit Chandora on 02/06/24.
//

import SwiftUI
import CoreData
import CryptoKit

struct NewAccountView: View {
    @State var openSheet = true
    @State var account = ""
    @State var user = ""
    @State var password = ""
    @State var hint = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).opacity(0.4).ignoresSafeArea()
            VStack(spacing: 8) {
                Spacer()
                
                TextField("Account Name", text: $account)
                    .textFieldStyle(RoundedTextFieldStyle())
                TextField("Username/ Email", text: $user)
                    .textFieldStyle(RoundedTextFieldStyle())
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedTextFieldStyle())
                Text(password.isEmpty ? "" : hint)
                    .font(.footnote)
                    .foregroundStyle(.red.opacity(0.7))
                Button(action: {
                    password = encryptedPassword()
                }, label: {
                    Text("generate")
                        .foregroundStyle(.brown)
                        .font(.caption)
                        .frame(width: 60, height: 20)
                        .border(Color.black.opacity(0.6))
                })
                    
                Spacer()
                VStack {
                    Button(action: {
                        PersistenceController.shared.addItem(account: account, user: user, password: password, context: viewContext)
                        dismiss()
                    }, label: {
                        Text("Add New Account")
                            .frame(width: 330, height: 45)
                            .bold()
                            .background(.black.opacity(0.8))
                            .cornerRadius(30)
                            .foregroundColor(.white)
                    })
                    .onChange(of: password) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            hint = strongPasswordValidation(name: user, password: password)
                        }
                    }
                    .disabled((account.isEmpty || user.isEmpty || password.isEmpty))
                }
            }
        }
    }
    private func encryptedPassword() -> String {
        let key = SymmetricKey(size: .bits256)

        let data = String("\(String.max)").data(using: .utf8)!
        let nonce = AES.GCM.Nonce()

        do {
            let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)
            let encryptedData = sealedBox.ciphertext
            return "\(encryptedData.base64EncodedString().trimmingCharacters(in: CharacterSet(charactersIn: "=")))"
        } catch {
            fatalError("Encryption failed")
        }
    }

    private func strongPasswordValidation(name: String, password: String) -> String {
        var upperCaseLetters = 0
        for i in password {
            if i.isUppercase {
                upperCaseLetters += 1
            }
        }
        if password.contains(name) {
            return "weak password"
        }
        else if password.count < 8  {
            return "weak password"
        }
        else if upperCaseLetters < 2 {
            return "weak password"
        }
        return ""
    }
}

#Preview {
    NewAccountView()
}

    
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray, lineWidth: 0.4))
            .padding(.horizontal)
    }
}

