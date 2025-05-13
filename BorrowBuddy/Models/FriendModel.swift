import SwiftUI
import Foundation

class FriendModel: ObservableObject {
    @Published var friends: [String] = ["Angelina", "Ethan", "Zack", "Vivek", "Alice", "Dylan", "Diana"]
}
