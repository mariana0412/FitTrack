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
    
    func createUser(with registrationData: RegistrationData, completion: @escaping (FirebaseResponse<Void>) -> Void) {
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
    
    private func saveUser(id: String, registrationData: RegistrationData, completion: @escaping (FirebaseResponse<Void>) -> Void) {
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
    
    func loginUser(with loginData: LoginData, completion: @escaping (FirebaseResponse<UserData?>) -> Void) {
        Auth.auth().signIn(withEmail: loginData.email,
                           password: loginData.password) { authResult, error in
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

    func updateUserSex(sex: String, completion: @escaping (FirebaseResponse<Void>) -> Void) {
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
                let userOptions = (data["userOptions"] as? [[String: Any]])?.compactMap { optionDict -> OptionData? in
                    guard let optionName = optionDict["optionName"] as? String,
                          let valueArray = optionDict["valueArray"] as? [Double?],
                          let changedValue = optionDict["changedValue"],
                          let dateArray = optionDict["dateArray"] as? [Int],
                          let isShown = optionDict["isShown"] as? Bool
                    else {
                        return nil
                    }
                    if let optionDataName = OptionDataName(rawValue: optionName) {
                        return OptionData(optionName: optionDataName,
                                          valueArray: valueArray,
                                          changedValue: changedValue as? Double,
                                          dateArray: dateArray,
                                          isShown: isShown)
                    } else {
                        return nil
                    }
                }
                
                let user = UserData(email: email,
                                    id: id,
                                    userName: userName,
                                    sex: sex,
                                    profileImage: profileImage,
                                    selectedOptions: userOptions ?? [])
                completion(.success(user))
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
                       let user,
                       user.sex != .unknown {
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
    
    func updateUserProfile(newName: String?, newImage: Data?, newOptions: [OptionData]?, completion: @escaping (FirebaseResponse<UserData?>) -> Void) {
        let database = Firestore.firestore()
        guard let currentUserId = getCurrentUserId() else {
            completion(.unknown)
            return
        }
        
        var updateData: [String: Any] = [:]
        
        if let newName {
            updateData["userName"] = newName
        }
        
        if let newImage {
            updateData["profileImage"] = newImage
        }
        
        if let newOptions {
            let optionsData = newOptions.map { option -> [String: Any] in
                return [
                    "optionName": option.optionName.rawValue,
                    "valueArray": option.valueArray,
                    "changedValue": option.changedValue as Any,
                    "dateArray": option.dateArray,
                    "isShown": option.isShown as Any
                ]
            }
            updateData["userOptions"] = optionsData
        }
        
        database
            .collection("users")
            .document(currentUserId)
            .updateData(updateData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.getUser { userResponse in
                        completion(userResponse)
                    }
                }
            }
    }
    
    func getCurrentUserEmail() -> String? {
        Auth.auth().currentUser?.email
    }
    
    private func getCurrentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
}
