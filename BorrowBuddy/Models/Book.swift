import Foundation

struct Book: Identifiable, Codable {
    var id = UUID()
    var title: String
    var author: String?
    var friendBorrowingFrom: String
    var dateToReturn: Date?
}
