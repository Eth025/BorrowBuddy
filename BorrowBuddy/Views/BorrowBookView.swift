//
//  AddBookView.swift
//  BorrowBuddy
//
//  Created by Ethan  on 7/5/2025.
//

import SwiftUI

struct BorrowBookView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var user: UserModel
    @State private var selection: BorrowLend = .borrowing
    @State private var friendName: String = ""
    @State private var bookTitle: String = ""
    @State private var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var endDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var isDateRangeSelected: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showSaveAlert: Bool = false

    // Data for dropdowns
    private let friendsList = ["", "Angelina", "Ethan", "Zack", "Vivek", "Alice", "Dylan", "Diana"]
    private let friendBooks: [String: [String]] = [
        "Angelina": ["Pride and Prejudice", "To Kill a Mockingbird"],
        "Ethan": ["1984", "Animal Farm"],
        "Zack": ["Dune", "Neuromancer"],
        "Vivek": ["The Lean Startup", "Clean Code"],
        "Alice": ["Moby Dick", "Jane Eyre"],
        "Dylan": ["The Hobbit", "The Silmarillion"],
        "Diana": ["Wuthering Heights", "Hamlet"]
    ]
    // User's personal collection
    @State private var userCollection: [String] = [
        "Fahrenheit 451", "Brave New World", "The Great Gatsby", "The Catcher in the Rye",
        "Moby Dick", "War and Peace", "Crime and Punishment", "The Odyssey",
        "Les Misérables", "Frankenstein", "Dracula", "The Iliad"
    ]

    enum BorrowLend: String, CaseIterable {
        case borrowing = "Borrowing"
        case addBook = "Add Book"
    }

    private var canSaveBorrow: Bool {
        !friendName.isEmpty && !bookTitle.isEmpty && isDateRangeSelected
    }
    private var canSaveAddBook: Bool {
        !bookTitle.isEmpty
    }
    private var dateRangeText: String {
        let fmt = DateFormatter(); fmt.dateStyle = .medium
        return "\(fmt.string(from: startDate)) – \(fmt.string(from: endDate))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("", selection: $selection) {
                ForEach(BorrowLend.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(SegmentedPickerStyle())

            if selection == .borrowing {
                // Borrowing flow
                Text("Add Friends").font(.headline)
                Menu {
                    ForEach(friendsList, id: \.self) { friend in
                        Button(action: {
                            friendName = friend
                            bookTitle = ""
                            isDateRangeSelected = false
                        }) {
                            Text(friend.isEmpty ? "— None —" : friend)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.fill").foregroundColor(.gray)
                        Text(friendName.isEmpty ? "Select a friend" : friendName)
                            .foregroundColor(friendName.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down").foregroundColor(.gray)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Text("Add Book").font(.headline)
                Menu {
                    ForEach(friendBooks[friendName] ?? [], id: \.self) { book in
                        Button(action: { bookTitle = book }) { Text(book) }
                    }
                } label: {
                    HStack {
                        Image(systemName: "book.fill").foregroundColor(.gray)
                        Text(bookTitle.isEmpty ? "Select a book" : bookTitle)
                            .foregroundColor(bookTitle.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down").foregroundColor(.gray)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Text("Add Duration").font(.headline)
                HStack {
                    Text(isDateRangeSelected ? dateRangeText : "How long are you borrowing for?")
                        .foregroundColor(isDateRangeSelected ? .primary : .gray)
                        .padding(12)
                    Spacer()
                    Button { showDatePicker.toggle() } label: {
                        Image(systemName: "plus.circle").font(.title2).foregroundColor(.blue)
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .popover(isPresented: $showDatePicker) {
                    VStack(spacing: 16) {
                        Text("Select Borrowing Period").font(.headline)
                        DatePicker("Start Date", selection: $startDate, in: Date()...Date.distantFuture, displayedComponents: [.date])
                        DatePicker("End Date", selection: $endDate, in: startDate...Date.distantFuture, displayedComponents: [.date])
                        Button("Done") { isDateRangeSelected = true; showDatePicker = false }
                            .padding(.top)
                    }
                    .padding()
                    .frame(maxWidth: 300)
                }

                Text("Add Comments").font(.headline)
                TextField("Add text (not required)", text: .constant(""))
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Spacer()
                // Save for borrowing
                Button {
                    guard canSaveBorrow else { return }
                    user.booksBorrowing.append(Book(title: bookTitle, author: nil, friendBorrowingFrom: friendName, dateToReturn: endDate))
                    showSaveAlert = true
                    // reset
                    friendName = ""; bookTitle = ""; startDate = Date(); endDate = Date(); isDateRangeSelected = false
                } label: {
                    Text("Save").font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(canSaveBorrow ? Color.blue : Color.gray)
                        .cornerRadius(10).opacity(canSaveBorrow ? 1 : 0.5)
                }
                .disabled(!canSaveBorrow)
                .alert("Happy reading!", isPresented: $showSaveAlert) {}

            } else {
                // Add Book to Collection flow
                Text("Add Book").font(.headline)
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Name of book", text: $bookTitle)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                // Save for collection
                Button {
                    guard canSaveAddBook else { return }
                    userCollection.append(bookTitle)
                    showSaveAlert = true
                    // reset
                    bookTitle = ""
                } label: {
                    Text("Save").font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(canSaveAddBook ? Color.blue : Color.gray)
                        .cornerRadius(10).opacity(canSaveAddBook ? 1 : 0.5)
                }
                .disabled(!canSaveAddBook)
                .alert("Book Added!", isPresented: $showSaveAlert) {}

                // My Collection
                Text("My Collection").font(.headline)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(userCollection, id: \.self) { book in
                            HStack {
                                Text(book).foregroundColor(.black)
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
            }
        }
        .padding()
        .navigationTitle(selection.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button { presentationMode.wrappedValue.dismiss() } label: {
            Image(systemName: "arrow.left").foregroundColor(.blue)
        })
    }
}

#Preview {
    NavigationView { BorrowBookView().environmentObject(UserModel()) }
}
