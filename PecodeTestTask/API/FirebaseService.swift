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
                   completion: @escaping (FirebaseResponse<RegistrationData?>) -> Void) {
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

    func getUser(completion: @escaping (FirebaseResponse<RegistrationData?>) -> Void) {
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
                let userName = data["userName"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let sex = data["sex"] as? String
                let registrationData = RegistrationData(userName: userName, 
                                                        email: email,
                                                        sex: sex,
                                                        password: "")
                completion(.success(registrationData))
            } else {
                completion(.unknown)
            }
        }
    }
    
    func checkCurrentUser(completion: @escaping (UserStatus) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            getUser { response in
                switch response {
                case .success(let registrationData):
                    if let user = registrationData, 
                        let user = user,
                       let sex = user.sex,
                        let userSex = UserSex(rawValue: sex) {
                        completion(.registeredWithSex(userSex))
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
