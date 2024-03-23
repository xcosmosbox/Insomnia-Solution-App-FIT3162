//
//  FirebaseController.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 23/3/2024.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage



class FirebaseController: NSObject, DatabaseProtocol {
    
    /*
     * Init Firebase Controller Object
     */
    private var authController: Auth
    private var database: Firestore
    private var fireStorage: Storage
    private var userRef: CollectionReference?
    private var sleepDateRef: CollectionReference?
    private var meditationRef: CollectionReference?
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        fireStorage = Storage.storage()
        super.init()
    }
    
    
    
    /*
     * Login State Management
     */
    var loginStatePublisher: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)
    
    var errorPublisher: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
    
    func login(email: String, password: String) {
        authController.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // if error then throw and send error message
            if let error = error {
                self?.errorPublisher.send(error.localizedDescription)
                return
            }
            // update login states
            self?.loginStatePublisher.send(true)
            
        }
    }
    
    func signup(email: String, password: String){
        authController.createUser(withEmail: email, password: password){ [weak self] authResult, error in
            // if error then throw and send error message
            if let error = error {
                self?.errorPublisher.send(error.localizedDescription)
                return
            }
            
            // if sign up success
            if let user = authResult?.user{
                // store in UserDefaults
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "isLoggedIn")
                defaults.set(email, forKey: "email")
                defaults.set(password, forKey: "password")
                
                
            }
            
            
        }
    }
    
    
}











