//
//  DatabaseProtocol.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 23/3/2024.
//

import Foundation
import Firebase
import Combine


protocol DatabaseProtocol{
    /*
     * LOGIN AND SIGNUP
     */
    // publisher for login state
    var loginStatePublisher: CurrentValueSubject<Bool, Never> { get }

    // publisher for error info
    var errorPublisher: PassthroughSubject<String, Never> { get }

    // login and signup functions
    func login(email: String, password: String)
    func signup(email: String, password: String)
    
    
    /*
     * USER PROFILE MANAGEMENT
     */
    var currentUserPublisher: CurrentValueSubject<User?, Never> { get }
    
    // create user profile
//    func createUserProfile(email: String) async  
    
    // fetch user profile
    func fetchUserProfile(userID: String) async throws -> User
    
    // update user info
    func updateUserProfile(userID: String, email: String?, name: String?, userCover: String?) async throws
    
    
    /*
     * SLEEP DATA MANAGEMENT
     */
    var sleepDataPublisher: CurrentValueSubject<[SleepData], Never> { get }
    // add user sleep data
    func addSleepData(forUserID userID: String, sleepData: SleepData) async throws

    // fetch user sleep data
    func fetchSleepData(forUserID userID: String, from startDate: Date, to endDate: Date) async throws -> [SleepData]

    // update user sleep data
    func updateSleepData(forUserID userID: String, sleepDataID: String, newSleepData: SleepData) async throws
    
    
    
    /*
     * MEDITATION MANAGEMENT
     */
    func fetchAllMeditations() async throws -> [Meditation]
    
}












