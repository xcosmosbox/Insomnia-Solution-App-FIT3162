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
}











