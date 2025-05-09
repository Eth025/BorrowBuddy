//
//  HomeView.swift
//  BorrowBuddy
//
//  Created by Ethan  on 5/5/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var user: UserModel
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Banner()
            CurrentlyReading()
            
            GeometryReader {geo in
                VStack {
                    BorrowedBooks()
                        .frame(height: geo.size.height - 100) // or calculate dynamically
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct Banner: View {
    @EnvironmentObject var user: UserModel
    var body: some View {
        HStack(spacing: 0) {
            Text("Borrow")
                .foregroundColor(.blue)
                .fontWeight(.bold) +
            Text("Buddy")
                .fontWeight(.bold)
        }
        .font(.system(size: 30))
        .padding(.top, 20)
        
        Text("Hi \(user.name)!")
            .font(.system(size: 20))
            .padding(.top, 1)
    }
}
struct CurrentlyReading: View {
    var body: some View {
        Text("Currently Reading")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.horizontal, 30)
    }
}

struct BorrowedBooks: View {
    @EnvironmentObject var user: UserModel
    @State private var showAlert = false
    @State private var bookToDelete: Book?
    @State private var indexToDelete: Int?
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        
        if user.booksBorrowing.isEmpty {
            VStack {
                Spacer()
                Text("You have not borrowed any books yet!")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(Array(user.booksBorrowing.enumerated()), id: \.element.id) { index, book in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(book.title) - \(book.author ?? "N/A")")
                            .fontWeight(.bold)
                        Text("Friend Borrowing From: \(book.friendBorrowingFrom)")
                        Text("Return Date: \(book.dateToReturn.map { dateFormat.string(from: $0) } ?? "N/A")")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        indexToDelete = index
                        showAlert = true
                    }
                }
            }
            .listStyle(.plain)
            .alert(isPresented: $showAlert) {
                let book = indexToDelete.flatMap {user.booksBorrowing[$0]}
                
                return Alert(
                    title: Text("Delete Book"),
                    message: Text("Have you returned \"\(book?.title ?? "the book")\" to your friend \(book?.friendBorrowingFrom ?? "")?"),
                    primaryButton: .destructive(Text("Yes")) {
                        if let index = indexToDelete {
                            user.booksBorrowing.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel(Text("No")) {
                        indexToDelete = nil
                    }
                )
            }
        }
    }
}

#Preview {
    // HomeView()
    // The dates need to be responsive to the user's selection - this is just seed data.
    let testUser = UserModel()
    testUser.name = "Ethan"
    testUser.loadSampleData()  // Load the sample data here
    
    return HomeView()
        .environmentObject(testUser)
}
