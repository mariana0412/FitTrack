//
//  FirebaseService.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    
    enum FirebaseResponse {
        case success
        case failure(Error)
        case unknown
    }
    
    static let shared = FirebaseService()
        
    private init() {}
    
    func createUser(with registrationData: RegistrationData, completion: @escaping (FirebaseResponse) -> Void) {
        Auth.auth().createUser(withEmail: registrationData.email, password: registrationData.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.saveUserDetails(id: authResult.user.uid, registrationData: registrationData, completion: completion)
            } else {
                completion(.unknown)
            }
        }
    }
    
    private func saveUserDetails(id: String, registrationData: RegistrationData, completion: @escaping (FirebaseResponse) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(id).setData([
            "email": registrationData.email,
            "id": id,
            "userName": registrationData.userName,
            "sex": registrationData.sex ?? ""
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }
    
    func updateUserGender(sex: String, completion: @escaping (FirebaseResponse) -> Void) {
        let db = Firestore.firestore()
        guard let currentUserId = getCurrentUserId() else {
            completion(.unknown)
            return
        }
        db.collection("users").document(currentUserId).updateData(["sex": sex]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }
    
    private func getCurrentUserId() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }


    
}
