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

    enum BorrowLend: String, CaseIterable {
        case borrowing = "Borrowing"
        case addBook = "Add Book"
    }

    private var canSave: Bool {
        switch selection {
        case .borrowing:
            return !friendName.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !bookTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
                   isDateRangeSelected
        case .addBook:
            return !bookTitle.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    private var dateRangeText: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return "\(fmt.string(from: startDate)) – \(fmt.string(from: endDate))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Mode Picker
            Picker("", selection: $selection) {
                ForEach(BorrowLend.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if selection == .borrowing {
                Group {
                    // Add Friends with magnifying glass
                    Text("Add Friends").font(.headline)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Type friend’s name or use drop down menu", text: $friendName)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    // Add Book with magnifying glass
                    Text("Add Book").font(.headline)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Book Title", text: $bookTitle)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    // Add Duration
                    Text("Add Duration").font(.headline)
                    HStack {
                        Text(isDateRangeSelected ? dateRangeText : "How long are you borrowing for?")
                            .foregroundColor(isDateRangeSelected ? .primary : .gray)
                            .padding(12)
                        Spacer()
                        Button(action: { showDatePicker.toggle() }) {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
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
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
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
                showSaveAlert = true

                // Reset fields
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
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSave ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .opacity(canSave ? 1.0 : 0.5)
            }
            .padding(.bottom)
            .disabled(!canSave)
            .alert(isPresented: $showSaveAlert) {
                switch selection {
                case .borrowing:
                    return Alert(
                        title: Text("Happy reading!"),
                        message: Text("You are borrowing “\(bookTitle)” from \(friendName) for \(dateRangeText). Enjoy!"),
                        dismissButton: .default(Text("OK")) { presentationMode.wrappedValue.dismiss() }
                    )
                case .addBook:
                    return Alert(
                        title: Text("Book Added!"),
                        message: Text("You have read \(bookTitle)."),
                        dismissButton: .default(Text("OK")) { presentationMode.wrappedValue.dismiss() }
                    )
                }
            }
        }
        .padding()
        .navigationTitle(selection.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left").foregroundColor(.blue)
        })
    }
}

#Preview {
    NavigationView { BorrowBookView() }
}
