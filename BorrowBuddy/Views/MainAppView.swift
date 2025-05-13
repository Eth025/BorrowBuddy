import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var user: UserModel  // Use the same user object passed down from LoginView
    
    var body: some View {
        TabView {
            // HomeView Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BorrowBookView()
                .tabItem {
                    Label("Borrow Book", systemImage: "plus")
                }
            
            FriendView()
                .tabItem {
                    Label("Friends", systemImage: "person.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
    }   
}

#Preview {
    // Create a sample user for preview
    let sampleUser = UserModel()
    sampleUser.loadSampleData()  // Load sample data for testing

    return MainAppView()
        .environmentObject(sampleUser) // Inject the user into the environment
        .environmentObject(FriendModel())
}
