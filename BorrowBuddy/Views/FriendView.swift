//
//  FriendView.swift
//  BorrowBuddy
//
//  Created by Ethan  on 7/5/2025.
//

import SwiftUI

struct FriendView: View {
    @State private var friends: [String] = ["Angelina", "Ethan", "Zack", "Vivek", "Alice", "Dylan", "Diana"]
    @State private var showingAddFriend = false
    @State private var searchText: String = ""

    //filters friends based on search text, prioritising prefix matches
    private var filteredFriends: [String] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends
                .filter { $0.lowercased().contains(searchText.lowercased()) }
                .sorted {
                    $0.lowercased().hasPrefix(searchText.lowercased()) &&
                    !$1.lowercased().hasPrefix(searchText.lowercased())
                }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    //title and add friend button
                    Text("Friends")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    
                    Button(action: {
                        showingAddFriend = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding(.horizontal)

                Text("Current Friends")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                //search bar to search friends and the found name will appear at the top
                TextField("Search friends", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                ScrollView {
                    //allows for user to scroll through friends
                    VStack(spacing: 10) {
                        if filteredFriends.isEmpty {
                            Text("No friends found.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            //display friends
                            ForEach(filteredFriends, id: \.self) { friend in
                                    HStack {
                                        Text(friend)
                                            .foregroundColor(.black)
                                        Text("(Click to view their profile)")
                                            .foregroundColor(.gray)
                                            .italic()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            //add new friend if not already in the list
            .padding(.top)
            .sheet(isPresented: $showingAddFriend) {
                AddFriendView { newFriend in
                    if !friends.contains(newFriend) {
                        friends.append(newFriend)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search friends")
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FriendView()
}
