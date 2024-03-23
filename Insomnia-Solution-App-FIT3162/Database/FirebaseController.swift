//
//  FirebaseController.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 23/3/2024.
//

import Foundation
import Combine
import FirebaseCore
import Firebase
import FirebaseAuth
//import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage



class FirebaseController: NSObject, DatabaseProtocol {
    
    /*
     * Init Firebase Controller Object
     */
    private var authController: Auth
    private var database: Firestore
    private var fireStorage: Storage
//    private var userRef: CollectionReference?
//    private var sleepDateRef: CollectionReference?
//    private var meditationRef: CollectionReference?
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
            
            // update login states
            if let _ = authResult.user{
                createUserProfile(email: email)
                self?.loginStatePublisher.send(true)
            }
            
        
            
        }
    }
    
    
    /*
     * USER PROFILE MANAGEMENT
     */
    var currentUserPublisher: CurrentValueSubject<User?, Never> = CurrentValueSubject<User?, Never>()
    
    // create user profile
    func createUserProfile(email: String){
        let data = ["email": email, "name": "Default Name", "user_cover": "gs://fit3162-insomnia-solutio-1a135.appspot.com/user_cover/Snipaste_2024-03-22_19-57-57.png"]
        do{
            let ref = try await database.collection("user").addDocument(data: data)
            print("Document added with ID: \(ref.documentID)")
        } catch{
            print("Error adding document: \(error)")
        }
    }
    
//    // fetch user profile
//    func fetchUserProfile(userID: String)
//    
//    // update user info
//    func updateUserProfile(userID: String, email: String?, name: String?, userCover: String?)
    
    
}











