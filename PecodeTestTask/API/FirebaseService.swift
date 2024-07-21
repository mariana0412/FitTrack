//
//  FirebaseService.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    
    enum FirebaseResponse<T> {
        case success(T?)
        case failure(Error)
        case unknown
    }
    
    enum UserStatus {
        case unregistered
        case registeredWithoutSex
        case registeredWithSex(UserSex)
    }

    static let shared = FirebaseService()
        
    private init() {}
    
    func createUser(with registrationData: RegistrationData, 
                    completion: @escaping (FirebaseResponse<RegistrationData?>) -> Void) {
        Auth.auth().createUser(withEmail: registrationData.email,
                               password: registrationData.password) { 
            authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.saveUser(id: authResult.user.uid, 
                                     registrationData: registrationData,
                                     completion: completion)
            } else {
                completion(.unknown)
            }
        }
    }
    
    private func saveUser(id: String, registrationData: RegistrationData, 
                                 completion: @escaping (FirebaseResponse<RegistrationData?>) -> Void) {
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
                completion(.success(nil))
            }
        }
    }
    
    func loginUser(with loginData: LoginData,
                   completion: @escaping (FirebaseResponse<UserData?>) -> Void) {
        Auth.auth().signIn(withEmail: loginData.email, password: loginData.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let _ = authResult {
                self.getUser { response in
                    completion(response)
                }
            } else {
                completion(.unknown)
            }
        }
    }

    func updateUserSex(sex: String,
                       completion: @escaping (FirebaseResponse<RegistrationData?>) -> Void) {
        let database = Firestore.firestore()
        guard let currentUserId = getCurrentUserId() else {
            completion(.unknown)
            return
        }
        database
            .collection("users")
            .document(currentUserId)
            .updateData(["sex": sex]) { 
                error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(nil))
            }
        }
    }

    func getUser(completion: @escaping (FirebaseResponse<UserData?>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(
                .failure(
                    NSError(
                        domain: "Firebase",
                        code: -1, 
                        userInfo: [NSLocalizedDescriptionKey: "No current user"])))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, 
                        document.exists,
                        let data = document.data() {
                let email = data["email"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                let userName = data["userName"] as? String ?? ""
                let sexString = data["sex"] as? String ?? ""
                let sex = UserSex(rawValue: sexString) ?? .unknown
                let profileImage = data["profileImage"] as? Data
                
                let registrationData = UserData(email: email,
                                                id: id,
                                                userName: userName,
                                                sex: sex,
                                                profileImage: profileImage)
                completion(.success(registrationData))
            } else {
                completion(.unknown)
            }
        }
    }
    
    func checkCurrentUser(completion: @escaping (UserStatus) -> Void) {
        if Auth.auth().currentUser != nil {
            getUser { response in
                switch response {
                case .success(let userData):
                    if let user = userData,
                       let user {
                        completion(.registeredWithSex(user.sex))
                    } else {
                        completion(.registeredWithoutSex)
                    }
                case .failure:
                    completion(.unregistered)
                case .unknown:
                    completion(.unregistered)
                }
            }
        } else {
            completion(.unregistered)
        }
    }

    func resetPassword(email: String, completion: @escaping (FirebaseResponse<Void>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(nil))
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
