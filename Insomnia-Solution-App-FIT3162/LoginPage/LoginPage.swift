//
//  LoginPage.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 23/3/2024.
//


import SwiftUI
import Combine

struct LoginPage: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    TextField("Enter your email", text: $viewModel.email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    SecureField("Enter your password", text: $viewModel.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.vertical, 10)
                }
                .background(Color.blue)
                .cornerRadius(5.0)
                .padding(.horizontal)

                Button(action: {
                    viewModel.signup()
                }) {
                    Text("Signup")
                        .foregroundColor(.white)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        
                        .padding(.vertical, 10)
                }
                .background(Color.blue)
                .cornerRadius(5.0)
                .padding(.horizontal)

                Spacer()
                
                // TODO: when isLoggedIn is true then auto jump to next page
            }
            .padding()
            .alert(item: $viewModel.errorMessage) { errorMessage in
                // when we get error, then show this Alert
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
            
        }
    }
}

@main
struct insomniaSolutionAppFIT3162: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // init FirebaseController obj
    @StateObject var firebaseController = FirebaseController()
    
    var body: some Scene {
        WindowGroup {
            LoginPage()
                .environmentObject(firebaseController) // inject firebaseController to environment object
        }
    }
}

//#Preview {
//    LoginPage()
//}

// Login page data model
class LoginViewModel: ObservableObject {
    // published datas
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: ErrorMessage? = nil
    
    // get firebaseController from EnvironmentObject
    @EnvironmentObject var firebaseController: FirebaseController
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        // & symbol to get reference 
        // when updated data firebaseController will updated value of isLoggedIn
        firebaseController.loginStatePublisher
            .assign(to: &$isLoggedIn)
        // using sink function to set itselft as receiver
        firebaseController.errorPublisher
            .sink { [weak self] error in
                self?.errorMessage?.message = error
            }
            .store(in: &cancellables)
    }
    
    // login function
    func login() {
        firebaseController.login(email: email, password: password)
    }
    
    // sign up function
    func signup() {
        firebaseController.signup(email: email, password: password)
    }
}
