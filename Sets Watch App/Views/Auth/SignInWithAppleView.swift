//
//  SignInWithAppleView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/2/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    var body: some View {
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    handleSuccessfulLogin(with: authorization)
                case .failure(let error):
                    handleLoginError(with: error)
                }
            }
            .frame(height: 50)
            .padding()
            .onAppear(perform: {
                // check as auth controller status
                let controller = ASAuthorizationAppleIDProvider()
                controller.getCredentialState(forUserID: "current_user") { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        print("apple id cred valid")
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        print("apple id cred not found")
                    default:
                        break
                    }
                }
            })
        }
        
        private func handleSuccessfulLogin(with authorization: ASAuthorization) {
            if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                var str = ""
                print("\(userCredential.user)")
                
                if userCredential.authorizedScopes.contains(.fullName) {
                    str = userCredential.fullName?.givenName ?? "No given name"
                }
                
                if userCredential.authorizedScopes.contains(.email) {
                    str = userCredential.email ?? "No email"
                }
                print("\(str)")
            }
        }
        
        private func handleLoginError(with error: Error) {
            print("Could not authenticate: \\(error.localizedDescription)")
        }
}

#Preview {
    SignInWithAppleView()
}
