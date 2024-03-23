//
//  MainLoginPage.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 22/3/2024.
//

import SwiftUI

struct MainLoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    TextField("Enter your email", text: $email)
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

                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)

                Button(action: {
                    //login
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
                    // signup
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
            }
            .padding()
        }
    }
}

@main
struct insomniaSolutionAppFIT3162: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainLoginPage()
        }
    }
}

#Preview {
    MainLoginPage()
}
