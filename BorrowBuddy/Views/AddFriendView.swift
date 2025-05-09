//
//  AddFriendView.swift
//  BorrowBuddy
//
//  Created by Angelina Lowe on 9/5/2025.
//

import SwiftUI

struct AddFriendView: View {
    //dismiss the current view when needed (used in the back button)
    @Environment(\.dismiss) var dismiss
    //callback function to pass the friend's name back when confirmed
    var onConfirm: (String) -> Void
    
    //state managers for UI inputs
    @State private var name: String = ""
    @State private var selectedGenre: String = ""
    @State private var selectedAvatar: String = ""
    @State private var shareBookshelf: Bool = true

    //list of genres and avatars
    let genres = ["Fiction", "Science Fiction", "Fantasy", "Mystery", "Romance", "Historical Fiction", "Horror", "Adventure", "Biography", "Non-Fiction"]
    let avatars = ["🐱", "🐶", "🐻", "🐯", "🦁", "🐮", "🐸", "🐼", "🐨", "🦊"]

    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    //back button and title
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    Text("Add Friend")
                        .font(.system(size: 32, weight: .bold))
                }
                
                Group {
                    //input new friend name
                    Text("Name").bold()
                    TextField("Type name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    //choose genre drop down
                    Text("Genre").bold()
                    Text("Choose their favourite book genre")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Picker("", selection: $selectedGenre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    //choose avatar drop down
                    Text("Avatar").bold()
                    Text("Choose what avatar to represent them")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Picker("", selection: $selectedAvatar) {
                        ForEach(avatars, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                HStack {
                    //bookshelf sharing toggle
                    Text("Share my bookshelf").bold()
                    Spacer()
                    Toggle("", isOn: $shareBookshelf)
                        .labelsHidden()
                }

                Spacer()

                //confirm button that makes sure name field is not empty and then dismisses the view once clicked
                Button(action: {
                    if !name.isEmpty {
                        onConfirm(name) //pass friend back to main view
                        dismiss()
                    }
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.black))
                }

            }
            .padding()
        }
}

#Preview {
    AddFriendView(onConfirm: { name in
        print("Friend added: \(name)")
    })
}
