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
     * ###############################
     * Init Firebase Controller Object
     * ###############################
     */
    private var authController: Auth
    private var database: Firestore
    private var fireStorage: Storage
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        fireStorage = Storage.storage()
        super.init()
    }
    
    
    
    /*
     * ########################
     * Login State Management
     * ########################
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
    
    func signup(email: String, password: String) {
        authController.createUser(withEmail: email, password: password){ [weak self] authResult, error in
            // if error then throw and send error message
            if let error = error {
                self?.errorPublisher.send(error.localizedDescription)
                return
            }
            
            // update login states
            if let _ = authResult?.user{
                // using guard to explicit unpacking
                guard let strongSelf = self else { return }
                Task{
                    await strongSelf.createUserProfile(email: email)
                }
                // send
                self?.loginStatePublisher.send(true)
            }
        }
    }
    
    
    
    /*
     * ########################
     * USER PROFILE MANAGEMENT
     * ########################
     */
    var currentUserPublisher: CurrentValueSubject<User?, Never> = CurrentValueSubject<User?, Never>(nil)
    
    // create user profile
    func createUserProfile(email: String) async {
        let data = ["email": email, "name": "Default Name", "user_cover": "gs://fit3162-insomnia-solutio-1a135.appspot.com/user_cover/Snipaste_2024-03-22_19-57-57.png"]
        do{
            let ref = try await database.collection("user").addDocument(data: data)
            print("Document added with ID: \(ref.documentID)")
        } catch{
            print("Error adding document: \(error)")
        }
    }
    
    // fetch user profile
    func fetchUserProfile(userID: String) async throws -> User {
        // fetch document snapshot from user collection
        let documentSnapshot = try await database.collection("user").document(userID).getDocument()
        
        // check document is exit
        guard let data = documentSnapshot.data(), documentSnapshot.exists else {
            throw NSError(domain: "FirebaseController", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document for user ID \(userID) not found."])
        }

        // try build User data from document
        guard let email = data["email"] as? String,
              let name = data["name"] as? String,
              let userCover = data["user_cover"] as? String else {
            throw NSError(domain: "FirebaseController", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid user data for user ID \(userID)."])
        }

        // return User obj
        return User(email: email, name: name, userCover: userCover)
    }
    
    // update user profile
    func updateUserProfile(userID: String, email: String?, name: String?, userCover: String?) async throws{
        // init data to be updated
        var updateData = [String: Any]()
        if let email = email { updateData["email"] = email }
        if let name = name { updateData["name"] = name }
        if let userCover = userCover { updateData["user_cover"] = userCover }
        
        // if no data needed to be updated, return directly
        guard !updateData.isEmpty else { return }

        // try await update the document
        try await database.collection("user").document(userID).updateData(updateData)
    }
    
    
    
}











