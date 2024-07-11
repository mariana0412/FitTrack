//
//  FirebaseService.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import FirebaseCore
import FirebaseAuth

class FirebaseService {
    
    enum FirebaseResponse {
        case success
        case failure(Error)
        case unknown
    }
    
    static let shared = FirebaseService()
        
    private init() {}
    
    func createUser(withEmail email: String, password: String, completion: @escaping (FirebaseResponse) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if authResult != nil {
                completion(.success)
            } else {
                completion(.unknown)
            }
        }
    }
    
}
