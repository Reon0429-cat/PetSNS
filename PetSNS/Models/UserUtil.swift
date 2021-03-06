//
//  UserUtil.swift
//  PetSNS
//
//  Created by 大西玲音 on 2021/08/30.
//
//

import UIKit
import Firebase

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

typealias ResultHandler<T> = (Result<T, String>) -> Void

final class UserUtil {
    
    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>) {
        Auth.auth().languageCode = "ja_JP"
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            completion(.success(nil))
        }
    }
    
    func signUp(email: String, 
                password: String, 
                completion: @escaping ResultHandler<Any?>) {
        Auth.auth().createUser(withEmail: email, 
                               password: password) { authResult, error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            completion(.success(nil))
        }
    }
    
    func login(email: String,
               password: String,
               completion: @escaping ResultHandler<Any?>) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { authResult, error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            completion(.success(nil))
        }
    }
    
    func logout(completion: @escaping ResultHandler<Any?>) {
        do {
            try Auth.auth().signOut()
            completion(.success(nil))
        } catch {
            let message = authErrorMessage(error)
            completion(.failure(message))
        }
    }
    
    private func authErrorMessage(_ error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail: return "メールアドレスの形式に誤りが含まれます。"
            case .weakPassword: return "パスワードは６文字以上で入力してください。"
            case .wrongPassword: return "パスワードに誤りがあります。"
            case .userNotFound: return "こちらのメールアドレスは登録されていません。"
            case .emailAlreadyInUse: return "こちらのメールアドレスは既に登録されています。"
            default: return "ログインに失敗しました\(error)"
            }
        }
        return "不明なエラーが発生しました。"
    }
}
