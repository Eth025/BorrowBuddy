//
//  AddBookView.swift
//  BorrowBuddy
//
//  Created by Ethan  on 7/5/2025.
//

import SwiftUI

struct BorrowBookView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var selection: BorrowLend = .borrowing
    @State private var friendName: String = ""
    @State private var bookTitle: String = ""
    @State private var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var endDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var isDateRangeSelected: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showSaveAlert: Bool = false

    // For alert content
    @State private var alertFriend: String = ""
    @State private var alertBook: String = ""
    @State private var alertDuration: String = ""

    // Friends list and their corresponding book collections
    private let friendsList = ["", "Angelina", "Ethan", "Zack", "Vivek", "Alice", "Dylan", "Diana"]
    private let friendBooks: [String: [String]] = [
        "Angelina": ["Pride and Prejudice - Jane Austen", "To Kill a Mockingbird - Harper Lee"],
        "Ethan": ["1984 - George Orwell", "Animal Farm - George Orwell"],
        "Zack": ["Dune - Frank Herbert", "Neuromancer - William Gibson"],
        "Vivek": ["The Lean Startup - Eric Ries", "Clean Code - Robert Cecil Martin"],
        "Alice": ["Moby Dick - Herman Melville", "Jane Eyre - Charlotte Brontë"],
        "Dylan": ["The Hobbit - J.R.R. Tolkien", "The Silmarillion"],
        "Diana": ["Wuthering Heights - Emily Brontë", "Hamlet - William Shakespeare"]
    ]

    enum BorrowLend: String, CaseIterable {
        case borrowing = "Borrowing"
        case addBook = "Add Book"
    }

    private var canSave: Bool {
        switch selection {
        case .borrowing:
            return !friendName.isEmpty && !bookTitle.isEmpty && isDateRangeSelected
        case .addBook:
            return !bookTitle.isEmpty
        }
    }

    private var dateRangeText: String {
        let fmt = DateFormatter(); fmt.dateStyle = .medium
        return "\(fmt.string(from: startDate)) – \(fmt.string(from: endDate))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("", selection: $selection) {
                ForEach(BorrowLend.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if selection == .borrowing {
                Group {
                    // Add Friends with dropdown and blank option
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

                    // Add Book dropdown based on selected friend
                    Text("Add Book").font(.headline)
                    Menu {
                        ForEach(friendBooks[friendName] ?? [], id: \.self) { book in
                            Button(action: { bookTitle = book }) {
                                Text(book)
                            }
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

                    // Add Duration
                    Text("Add Duration").font(.headline)
                    HStack {
                        Text(isDateRangeSelected ? dateRangeText : "How long are you borrowing for?")
                            .foregroundColor(isDateRangeSelected ? .primary : .gray)
                            .padding(12)
                        Spacer()
                        Button(action: { showDatePicker.toggle() }) {
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
                            Button("Done") {
                                isDateRangeSelected = true
                                showDatePicker = false
                            }
                            .padding(.top)
                        }
                        .padding()
                        .frame(maxWidth: 300)
                    }

                    // Add Comments
                    Text("Add Comments").font(.headline)
                    TextField("Add text (not required)", text: .constant(""))
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            } else {
                // Add Book to Collection Flow
                Text("Add Book").font(.headline)
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Name of book", text: $bookTitle)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Spacer()

            // Save Button
            Button(action: {
                guard canSave else { return }
                // Capture alert values
                alertFriend = friendName
                alertBook = bookTitle
                alertDuration = selection == .borrowing ? dateRangeText : ""
                showSaveAlert = true
                // Reset fields after capturing
                if selection == .borrowing {
                    friendName = ""
                    bookTitle = ""
                    startDate = Calendar.current.startOfDay(for: Date())
                    endDate = Calendar.current.startOfDay(for: Date())
                    isDateRangeSelected = false
                } else {
                    bookTitle = ""
                }
            }) {
                Text("Save").font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding()
                    .background(canSave ? Color.blue : Color.gray).cornerRadius(10)
                    .opacity(canSave ? 1 : 0.5)
            }
            .padding(.bottom)
            .disabled(!canSave)
            .alert(isPresented: $showSaveAlert) {
                switch selection {
                case .borrowing:
                    return Alert(
                        title: Text("Happy reading!"),
                        message: Text("You are borrowing “\(alertBook)” from \(alertFriend) for \(alertDuration). Enjoy!"),
                        dismissButton: .default(Text("OK")) { presentationMode.wrappedValue.dismiss() }
                    )
                case .addBook:
                    return Alert(
                        title: Text("Book Added!"),
                        message: Text("You have read \(alertBook)."),
                        dismissButton: .default(Text("OK")) { presentationMode.wrappedValue.dismiss() }
                    )
                }
            }
        }
        .padding()
        .navigationTitle(selection.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "arrow.left").foregroundColor(.blue)
        })
    }
}

#Preview {
    NavigationView { BorrowBookView() }
}
