import SwiftUI
import Foundation

struct LoginView: View {
    @StateObject private var user = UserModel()
    @State private var navigationOn = false
    
    var body: some View {
        NavigationView {
            VStack {
                Logo()
                    .padding(.top)
                Spacer()
                    .frame(height: 50)
                
                Image("Book")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 50)
                
                Name()
                    .padding(.bottom, 20)
                
                LoginButton(navigationOn: $navigationOn)
                
                NavigationLink(destination: MainAppView().onAppear {user.loadSampleData() }, isActive: $navigationOn) {
                    EmptyView()
                    // Delete onAppear when adding a book has been created. This is just to preview sample data. 
                }
            }
        }
        .environmentObject(user)
    }
}

#Preview {
    LoginView()
}

// Elements

struct Logo: View {
    var body: some View {
        VStack(spacing: -5) {
            HStack(spacing: 0) {
                Text("Borrow")
                    .foregroundColor(.blue)
                    .fontWeight(.bold) +
                Text("Buddy")
                    .fontWeight(.bold)
                
            }
            .font(.system(size: 50))
            Text("From Your Shelf to Theirs.")
                .font(.title2)
                .padding(.horizontal, 30)
        }
    }
}

struct Name: View {
    @EnvironmentObject var user: UserModel
    
    var body: some View {
        VStack
        {
            TextField("Name", text: $user.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
        }
        .padding(.horizontal, 30)
    }
}

struct LoginButton: View {
    @EnvironmentObject var user: UserModel
    @Binding var navigationOn: Bool
    
    var body: some View {
        Button(action: {
            if !user.name.trimmingCharacters(in: .whitespaces).isEmpty {
                navigationOn = true
            }
        }) {
            Text("LOGIN")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.black)
                .cornerRadius(35.0)
        }
    }
}
    
