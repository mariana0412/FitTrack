//
//  FirebaseService.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    
    enum FirebaseResponse {
        case success
        case failure(Error)
        case unknown
    }
    
    enum UserStatus {
        case unregistered
        case registeredWithoutSex
        case registeredWithSex(RegistrationData)
    }

    static let shared = FirebaseService()
        
    private init() {}
    
    func createUser(with registrationData: RegistrationData, 
                    completion: @escaping (FirebaseResponse) -> Void) {
        Auth.auth().createUser(withEmail: registrationData.email,
                               password: registrationData.password) { 
            authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.saveUserDetails(id: authResult.user.uid, 
                                     registrationData: registrationData,
                                     completion: completion)
            } else {
                completion(.unknown)
            }
        }
    }
    
    private func saveUserDetails(id: String, registrationData: RegistrationData, 
                                 completion: @escaping (FirebaseResponse) -> Void) {
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
    
    func updateUserSex(sex: String, 
                       completion: @escaping (FirebaseResponse) -> Void) {
        let db = Firestore.firestore()
        guard let currentUserId = getCurrentUserId() else {
            completion(.unknown)
            return
        }
        db
            .collection("users")
            .document(currentUserId)
            .updateData(["sex": sex]) { 
                error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }

    func fetchUserDetails(completion: @escaping (FirebaseResponse, RegistrationData?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])), nil)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error), nil)
            } else if let document = document, 
                        document.exists,
                        let data = document.data() {
                let userName = data["userName"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let sex = data["sex"] as? String
                let registrationData = RegistrationData(userName: userName, 
                                                        email: email,
                                                        sex: sex,
                                                        password: "")
                completion(.success, registrationData)
            } else {
                completion(.unknown, nil)
            }
        }
    }
    
    func checkCurrentUser(completion: @escaping (UserStatus) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            fetchUserDetails { response, registrationData in
                switch response {
                case .success:
                    if let registrationData = registrationData, let sex = registrationData.sex, !sex.isEmpty {
                        completion(.registeredWithSex(registrationData))
                    } else {
                        completion(.registeredWithoutSex)
                    }
                case .failure, .unknown:
                    completion(.unregistered)
                }
            }
        } else {
            completion(.unregistered)
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
