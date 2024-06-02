//
//  ContentView.swift
//  passwordManager
//
//  Created by Sumit Chandora on 01/06/24.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\UserData.time, order: .reverse)], animation: .default) var items: FetchedResults<UserData>
    @Environment(\.dismiss) var dismiss
    @State var openSheet = false
    @State var editSheet = false
    @State var entity: FetchedResults<UserData>.Element?
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                VStack {
                    Divider()
                        .padding()
                    ScrollView(.vertical) {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item.account_name ?? "")
                                    .padding(.horizontal)
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                Text(String(String(repeating: "*", count: item.password?.count ?? 0)))
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .padding(.horizontal)
                                
                            }
                            .frame(maxWidth: 345, minHeight: 66.19)
                            .background(.white)
                            .cornerRadius(50)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            //
                            .onTapGesture {
                                entity = item
                                editSheet.toggle()
                            }
                            .sheet(isPresented: $editSheet) {
                                EditSheetView(items: entity)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            openSheet.toggle()
                        }, label: {
                            Image(systemName: "plus.square.fill")
                                .font(.system(size: 60))
                        })
                        .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Text("Password Manager").font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .sheet(isPresented: $openSheet, content: {
                    NewAccountView()
                        .presentationDetents([.height((380))])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(25)
                })
            }
        }
    }
}

#Preview {
    ContentView()
}


