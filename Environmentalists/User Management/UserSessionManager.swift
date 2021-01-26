//
//  UserSessionManager.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/2/20.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum AuthState {
    case signUp
    case login
    case forgotPassword
    case session
}

final class UserSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    @Published var errorMessage = ""
    @Published var alert = false
    
    func getCurrentAuthUser() {
        if Auth.auth().currentUser != nil {
            authState = .session
        } else {
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func showPasswordReset() {
        authState = .forgotPassword
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate.init(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    func doPasswordsMatch(_ password:String, _ confirmedPassword: String) -> Bool {
        
        if password != confirmedPassword {
            return false
        }
        return true
    }
    
    func validateFieldsForActivist(email: String, password: String, confirmedPassword: String, firstName: String, lastName: String, dateOfBirth: Date, profilePic: Data) -> String?{
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            profilePic.count == 0 {
            
            self.errorMessage = "Please fill in all fields and make sure you have selected a profile picture."
            self.alert.toggle()
            return "Error"
        }
        
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmedPassword = confirmedPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            self.errorMessage = "Please make sure your password is at least 8 characters and contains a capital letter and a number."
            self.alert.toggle()
            return "Error"
        }
        
        if doPasswordsMatch(cleanedPassword, cleanedConfirmedPassword) == false {
            self.errorMessage = "Please make sure your password entries match."
            self.alert.toggle()
            return "Error"
        }
        
        return nil
    }
    
    func signUpAsActivist(email: String, password: String, confirmedPassword: String, firstName: String, lastName: String, dateOfBirth: Date, profilePic: Data) {
        
        let error = validateFieldsForActivist(email: email, password: password, confirmedPassword: confirmedPassword, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, profilePic: profilePic)
        
        if error != nil {
            return
        }
        
        else {
            
            let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword){ (res, err) in
                if err != nil {
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                let database = Firestore.firestore()
                let storage = Storage.storage().reference()
                let userRef = database.collection("Activists")
                storage.child("profilepics").child(res!.user.uid).putData(profilePic, metadata: nil) { (_, err) in
                    
                    if err != nil {
                        self.errorMessage = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    storage.child("profilepics").child(res!.user.uid).downloadURL { (url, err) in
                        
                        if err != nil{
                            self.errorMessage = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
                        
                        userRef.document("\(lastName), \(firstName)").setData(["Account Type": "Activist", "First Name": cleanedFirstName, "Last Name": cleanedLastName,  "Events": [String](), "Email": cleanedEmail, "Date of Birth": Timestamp(date: dateOfBirth), "UID": res!.user.uid, "Profile Pic": "\(url!)"])
                        self.authState = .session
                    }
                }
            }
        }
    }
    
    func validateFieldsForOrganizer(email: String, password: String, confirmedPassword: String, orgName: String, profilePic: Data, coverPic: Data, orgLink: String) -> String?{
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            orgName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            profilePic.count == 0 ||
            coverPic.count == 0  ||
            !verifyUrl(urlString: orgLink) {
            
            self.errorMessage = "Please fill in all fields, confirm your website is a valid link, and you have selected profile / cover photos."
            self.alert.toggle()
            return "Error"
        }
        
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmedPassword = confirmedPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            self.errorMessage = "Please make sure your password is at least 8 characters and contains a capital letter and a number."
            self.alert.toggle()
            return "Error"
        }
        
        if doPasswordsMatch(cleanedPassword, cleanedConfirmedPassword) == false {
            self.errorMessage = "Please make sure your password entries match."
            self.alert.toggle()
            return "Error"
        }
        
        return nil
    }
    
    
    
    func signUpAsOrganizer(email: String, password: String, confimedPassword: String, orgName: String, orgDescription: String, orgLink: String, profilePic: Data, coverPic: Data) {

        let error = validateFieldsForOrganizer(email: email, password: password, confirmedPassword: confimedPassword, orgName: orgName, profilePic: profilePic, coverPic: coverPic, orgLink: orgLink)
        
        if error != nil {
            return
        }
        
        else {
            
            let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword){ (res, err) in
                if err != nil {
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                let database = Firestore.firestore()
                
                let storage = Storage.storage().reference()
                let userRef = database.collection("Organizers")
                var coverPicURL = ""
                
                storage.child("coverpics").child(res!.user.uid).putData(coverPic, metadata: nil) { (_, err) in
                    
                    if err != nil {
                        self.errorMessage = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    storage.child("coverpics").child(res!.user.uid).downloadURL { (coverpicURL, err) in
                        
                        if err != nil{
                            self.errorMessage = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
                        DispatchQueue.main.async {
                            coverPicURL = "\(coverpicURL!)"
                        }
                        
                    }
                    
                    storage.child("profilepics").child(res!.user.uid).putData(profilePic, metadata: nil) { (_, err) in
                        
                        if err != nil {
                            self.errorMessage = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
                        
                        storage.child("profilepics").child(res!.user.uid).downloadURL { (url, err) in
                            
                            if err != nil{
                                self.errorMessage = err!.localizedDescription
                                self.alert.toggle()
                                return
                            }
                            
                            userRef.document("\(orgName)").setData(["Account Type": "Organizer", "Organization Name": orgName, "Organization Description": orgDescription, "Organization Website Link": orgLink, "Email": email, "Organizer ID": res!.user.uid, "Profile Pic URL": "\(url!)", "Organization Location": "Langhorne, PA", "Number of Followers": 0, "Cover Pic URL": coverPicURL, "Events": [String]()])
                            self.signInWithFirebase(email: cleanedEmail, password: cleanedPassword)
                        }
                    }
                }
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            let protocolurl = "https://" + urlString
            if let url = NSURL(string: protocolurl) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
            }
    
    func resetPassword(email:String) {
        
        if email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                
                if err != nil{
                    
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.errorMessage = "Password reset link sent."
                self.alert.toggle()
            }
            self.authState = .login
        }
        else {
            self.errorMessage = "Please enter an email."
            self.alert.toggle()
        }
    }
    
    func validateSignInFields(email: String, password: String) -> String? {
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.errorMessage = "Please fill in all fields."
            self.alert.toggle()
            return "Error"
        }
        
        return nil
    }
    
    func signInWithFirebase(email: String, password: String) {
        
        let error = validateSignInFields(email: email, password: password)
        if error != nil {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if err != nil {
                self.errorMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            self.authState = .session
        }
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        self.authState = .login
    }
    
}


