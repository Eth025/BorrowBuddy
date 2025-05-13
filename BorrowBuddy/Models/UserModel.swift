import SwiftUI

class UserModel: ObservableObject {
    @Published var name: String = ""
    @Published var booksBorrowing: [Book] = []
}

extension UserModel {
    func loadSampleData() {
        self.booksBorrowing = [
            Book(title: "1984", author: "George Orwell", friendBorrowingFrom: "Alice", dateToReturn: Date()),
            Book(title: "Atomic Habits", author: "James Clear", friendBorrowingFrom: "Charlie", dateToReturn: Date(timeIntervalSinceNow: 1000000)),
            Book(title: "Rick Roll", author: "Rick Astley", friendBorrowingFrom: "Rick", dateToReturn: nil),
            Book(title: "Can we have full marks? Please and thank you.", author: "😭", friendBorrowingFrom: "Team VAZE.", dateToReturn: Date()),
            Book(title: "Placeholder", author: nil, friendBorrowingFrom: "The Unknown.", dateToReturn: Date(timeIntervalSinceNow: 1000000)),
            Book(title: "Tung Tung Tung Sahur", author: "Italian Brainrot", friendBorrowingFrom: "Ballerina Cuppacina", dateToReturn: Date(timeIntervalSinceNow: 99999999))
        ]
    }
}
