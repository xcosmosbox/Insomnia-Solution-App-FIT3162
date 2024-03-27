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



class FirebaseController: NSObject, DatabaseProtocol, ObservableObject {
    
    

    
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
            if let user = authResult?.user{
                // using guard to explicit unpacking
                guard let strongSelf = self else { return }
                Task{
                    await strongSelf.createUserProfile(email: email, uid: user.uid)
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
    private func createUserProfile(email: String, uid: String) async {
        let data = ["email": email, "name": "Default Name", "user_cover": "gs://fit3162-insomnia-solutio-1a135.appspot.com/user_cover/Snipaste_2024-03-22_19-57-57.png"]
        do{
            try await database.collection("user").document(uid).setData(data)
            print("Document added with ID: \(uid)")
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
    
    
    /*
     * ########################
     * SLEEP DATA MANAGEMENT
     * ########################
     */
    var sleepDataPublisher: CurrentValueSubject<[SleepData], Never> = CurrentValueSubject<[SleepData], Never>([])
    
    func addSleepData(forUserID userID: String, sleepData: SleepData) async throws {
        // build one date map to add into the firebase
        let data: [String: Any] = [
            "date": sleepData.date.sleepDataDateString(),
            "start_time": sleepData.startTime.sleepDataTimeString(),
            "end_time": sleepData.endTime.sleepDataTimeString()
        ]
        
        // try get the sleep_date collection and adding data
        do {
            _ = try await database.collection("sleep_data").document(userID).setData(data, merge: true)
            
            // fetch all latest data and publish to all listener
            let updatedSleepData = try await fetchAllSleepData(forUserID: userID)
            sleepDataPublisher.send(updatedSleepData)
        } catch {
            // if error then throw error
            throw error
        }
    }
    private func fetchAllSleepData (forUserID userID: String) async throws -> [SleepData]{
        // start date -> one month ago
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        // end date -> now
        let endDate = Date()
        // call fetchSleepData to get data
        let allSleepData = try await fetchSleepData(forUserID: userID, from: startDate, to: endDate)
        return allSleepData
    }
    func fetchSleepData(forUserID userID: String, from startDate: Date, to endDate: Date) async throws -> [SleepData] {
        // convert start date and end date
        let documentSnapshot = try await database.collection("sleep_data").document(userID).getDocument()
        
        // check data valid
        guard let documentData = documentSnapshot.data(), documentSnapshot.exists else {
            throw NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document for user ID \(userID) not found."])
        }
        guard let sleepDataArray = documentData["sleep_array"] as? [[String: String]] else {
            throw NSError(domain: "FirestoreError", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid sleep data structure for user ID \(userID)."])
        }
        
        // set date formatter
        let dateFormatter = DateFormatter.sleepDataDateFormatter
        
        // using compactMap to fillter all data
        let sleepData = sleepDataArray.compactMap { dataDict -> SleepData? in
            guard let dateString = dataDict["date"],
                  let date = dateFormatter.date(from: dateString),
                  startDate...endDate ~= date, // check date is betweent in startDate and endDate
                  let startTimeString = dataDict["start_time"],
                  let startTime = dateFormatter.date(from: startTimeString),
                  let endTimeString = dataDict["end_time"],
                  let endTime = dateFormatter.date(from: endTimeString) else {
                return nil
            }
            return SleepData(date: date, startTime: startTime, endTime: endTime)
        }
        
        // publish to listener
        sleepDataPublisher.send(sleepData)
        return sleepData
    }
    
    func updateSleepData(forUserID userID: String, sleepDataID: String, newSleepData: SleepData) async throws {
        // inti data
        let data: [String: Any] = [
            "date": newSleepData.date.sleepDataDateString(),
            "start_time": newSleepData.startTime.sleepDataTimeString(),
            "end_time": newSleepData.endTime.sleepDataTimeString()
        ]
        do {
            // try update data
            try await database.collection("sleep_data").document(sleepDataID).updateData(data)
            let updatedSleepData = try await fetchAllSleepData(forUserID: userID)
            sleepDataPublisher.send(updatedSleepData)
        } catch {
            // if error then throw error
            throw error
        }
    }
    
    
    /*
     * ########################
     * MEDITATION MANAGEMENT
     * ########################
     */
    func fetchAllMeditations() async throws -> [Meditation] {
        // fetch meditation document reference
        let querySnapshot = try await database.collection("meditation").getDocuments()
        
        // init meditation array
        var meditations: [Meditation] = []
        // guard each document and new Meditataion obj to store in array
        for document in querySnapshot.documents {
            let data = document.data()
            guard let name = data["Name"] as? String,
                  let description = data["Description"] as? String,
                  let duration = data["Duration"] as? String,
                  let instructions = data["Instructions"] as? String else {
                continue
            }
            let meditation = Meditation(id: document.documentID, name: name, description: description, duration: duration, instructions: instructions)
            meditations.append(meditation)
        }
        
        // return meditations array
        return meditations
    }
    
    
    
    
    
    
}


/*
 * ########################################################################
 * extension DateFormatter, Date and String to convert String and Date
 * ########################################################################
 */
extension DateFormatter {
    static let sleepDataDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static let sleepDataTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
extension Date {
    func sleepDataDateString() -> String {
        DateFormatter.sleepDataDateFormatter.string(from: self)
    }
    
    func sleepDataTimeString() -> String {
        DateFormatter.sleepDataTimeFormatter.string(from: self)
    }
}
extension String {
    func sleepDataDate() -> Date? {
        DateFormatter.sleepDataTimeFormatter.date(from: self)
    }
}












