//
//  LocalStorageService.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import Foundation

class LocalStorageService {
    static let shared = LocalStorageService()
    let authKey = "authKey"
    let defaults = UserDefaults.standard
    
    func setAuthTokenValue(token:String) {
        defaults.set(token, forKey: authKey)
    }
    
    func fetAuthToken() -> String? {
        if let authToken = defaults.string(forKey: authKey) {
            return authToken
        }else {
            return nil
        }
    }
}
