//
//  SignUp.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/3/20.
//

import SwiftUI
import Photos

struct SignUp: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager

    @State var newAccountType = ""
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.1157108322, blue: 0.5436113477, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.50462991, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            if self.newAccountType == "" {
                VStack {
                    
                    Text("Welcome to Environmend!")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                        .padding(.bottom, 25)
                    
                    Button(action: {
                        self.newAccountType = "Activist"
                    }) {
                        
                        Text("Activist").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-100).padding().font(.body)
                        
                    }.background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).padding(.top,50)
                    
                    Button(action: {
                        self.newAccountType = "Organizer"
                    }) {
                        
                        Text("Organizer").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-100).padding().font(.body)
                        
                    }.background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).padding(.top,50)
                    
                    Button("Already have an account? Sign in.", action: {
                        sessionManager.showLogin()
                    })
                    
                }.padding([.top, .bottom], 50)
            }
            
            else if self.newAccountType == "Activist" {
                
                ActivistSignUp(newAccountType: $newAccountType)
                    .environmentObject(sessionManager)
                
            }
            
            else if self.newAccountType == "Organizer" {
                
                OrganizerSignUp(newAccountType: $newAccountType)
                    .environmentObject(sessionManager)
                
            }
        }
        
    }
}

struct ActivistSignUp: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var confirmedPassword = ""
    @State private var showPassword = false
    @State private var showConfirmedPassword = false
    @State private var showDatePicker = false
    @State private var picker = false
    @State private var dateOfBirth = Date()
    @State private var currentDate = Date()
    @State var dateFormat = DateFormatter()
    @State var imagedata: Data = .init(count: 0)
    @Binding var newAccountType: String
    
    var body: some View {
        
        self.dateFormat.dateStyle = .medium
        
        return ZStack {
            VStack {
                
                HStack {
                    Button(action: {
                        self.newAccountType = ""
                    }) {
                        Text("Back")
                    }
                    Spacer()
                }.padding(.leading, 15)
                
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    
                    Button(action: {
                        
                        self.picker.toggle()
                        
                    }) {
                        
                        if self.imagedata.count == 0{
                            
                            Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                        }
                        else{
                            
                            Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                        }
                        
                        
                    }
                    
                    Spacer()
                }
                
                
                HStack {
                    VStack(alignment: .leading){
                        
                        Text("First Name")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 20)
                        
                        TextField("First Name", text: $firstName)
                            .padding([.leading, .trailing], 20)
                        Divider()
                    }.padding([.leading, .trailing], 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Last Name")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 20)
                        
                        TextField("Last Name", text: $lastName)
                            .padding([.leading, .trailing], 20)
                        Divider()
                    }.padding([.leading, .trailing], 15)
                }
                
                VStack(alignment: .leading){
                    
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        TextField("Enter Email Address", text: $email)
                        
                    }.padding([.leading, .trailing], 20)
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        if self.showPassword {
                            TextField("Enter Password", text: $password)
                            .padding([.leading, .trailing], 20)
                        }
                        else {
                            SecureField("Enter Password", text: $password)
                            .padding([.leading, .trailing], 20)
                        }

                        
                        Button(action: {
                            
                            self.showPassword.toggle()
                            
                        }) {
                            
                            Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.trailing, 17.5)
                        }
                    }
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Confirm Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        if self.showConfirmedPassword {
                            TextField("Enter Password", text: $confirmedPassword)
                            .padding([.leading, .trailing], 20)
                        }
                        else {
                            SecureField("Enter Password", text: $confirmedPassword)
                            .padding([.leading, .trailing], 20)
                        }

                        
                        Button(action: {
                            
                            self.showConfirmedPassword.toggle()
                            
                        }) {
                            
                            Image(systemName: self.showConfirmedPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.trailing, 17.5)
                        }
                    }
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                HStack {
                    Text("Date of Birth (Optional): ").foregroundColor(.white)
                    
                    Button(action: {
                        
                        self.showDatePicker.toggle()
                        
                    }) {
                        
                        if self.dateOfBirth == self.currentDate {
                            Text("Choose a Date")
                        }
                        else {
                            Text(dateFormat.string(from: self.dateOfBirth))
                        }
                        
                    }
                }
                
                VStack {
                    
                    Button(action: {
                        
                        sessionManager.signUpAsActivist(email: self.email, password: self.password, confirmedPassword: self.confirmedPassword, firstName: self.firstName, lastName: self.lastName, dateOfBirth: self.dateOfBirth, profilePic: self.imagedata)
                        
                    }) {
                        
                        Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-100).padding().font(.body)
                        
                    }.background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).padding(.top,50)
                }
                
                Spacer()
                
            }.opacity(self.showDatePicker ? 0 : 1)
            
            if self.showDatePicker {
                
                ZStack() {
                    
                    DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(maxHeight: 150)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.showDatePicker.toggle()
                        }) {
                            
                            Image(systemName: "multiply.circle").foregroundColor(.black)
                            
                        }
                    }.padding(.bottom, 200)
                        
                }.padding()
                .background(Color.white)
                .cornerRadius(5.0)
                
            }
            
        }.sheet(isPresented: self.$picker, content: {
            
            ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
        })
        .alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }
        
        
    }
}

struct OrganizerSignUp: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var showPassword = false
    @State private var showConfirmedPassword = false
    @State private var orgName = ""
    @State private var orgDescription = ""
    @State private var orgWebsite = ""
    @State private var picker = false
    @State private var coverpicker = false
    @State var imagedata: Data = .init(count: 0)
    @State var coverimagedata: Data = .init(count: 0)
    @Binding var newAccountType: String
    
    var body: some View {
        
        ZStack {
            ScrollView{
            VStack {
                
                VStack {
                    HStack {
                        Button(action: {
                            self.newAccountType = ""
                        }) {
                            Text("Back")
                        }
                        
                        Spacer()
                    }.padding(.leading, 15)
                    
                    Spacer()
                }
                
                HStack{
                    
                    Spacer()
                    
                    
                    Button(action: {
                        
                        self.picker.toggle()
                        
                    }) {
                        
                        if self.imagedata.count == 0{
                            
                            Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                        }
                        else{
                            
                            Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                        }
                        
                        
                    }.sheet(isPresented: self.$picker, content: {
                        
                        ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
                    }
                    
                    )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading){
                    
                    Text("Organization Name")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    TextField("Organization Name", text: $orgName)
                        .padding([.leading, .trailing], 20)
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        TextField("Enter Email Address", text: $email)
                        
                    }.padding([.leading, .trailing], 20)
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        if self.showPassword {
                            TextField("Enter Password", text: $password)
                                .padding([.leading, .trailing], 20)
                        }
                        else {
                            SecureField("Enter Password", text: $password)
                                .padding([.leading, .trailing], 20)
                        }
                        
                        
                        Button(action: {
                            
                            self.showPassword.toggle()
                            
                        }) {
                            
                            Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.trailing, 17.5)
                        }
                    }
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Confirm Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        if self.showConfirmedPassword {
                            TextField("Enter Password", text: $confirmedPassword)
                                .padding([.leading, .trailing], 20)
                        }
                        else {
                            SecureField("Enter Password", text: $confirmedPassword)
                                .padding([.leading, .trailing], 20)
                        }
                        
                        
                        Button(action: {
                            
                            self.showConfirmedPassword.toggle()
                            
                        }) {
                            
                            Image(systemName: self.showConfirmedPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.trailing, 17.5)
                        }
                    }
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Organization Description")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        TextEditor(text: $orgDescription).frame(maxHeight: 100)
                        
                    }.padding([.leading, .trailing], 20)
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                VStack(alignment: .leading){
                    
                    Text("Organization Website")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 20)
                    
                    HStack {
                        
                        TextField("Enter Organization Website", text: $orgWebsite)
                        
                    }.padding([.leading, .trailing], 20)
                    Divider()
                }.padding([.leading, .trailing], 15)
                
                HStack{
                    
                    Spacer()
                    
                    
                    Button(action: {
                        
                        self.coverpicker.toggle()
                        
                    }) {
                        
                        if self.coverimagedata.count == 0{
                            
                            Image(systemName: "camera.on.rectangle").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                        }
                        else{
                            
                            Image(uiImage: UIImage(data: self.coverimagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90)
                        }
                        
                        
                    }.sheet(isPresented: self.$coverpicker, content: {
                        
                        ImagePicker(picker: self.$coverpicker, imagedata: self.$coverimagedata)
                    })
                    
                    Spacer()
                }
                
               
                
                VStack {
                    
                    Button(action: {
                        
                        sessionManager.signUpAsOrganizer(email: self.email, password: self.password, confimedPassword: self.confirmedPassword, orgName: self.orgName, orgDescription: self.orgDescription, orgLink: self.orgWebsite, profilePic: self.imagedata, coverPic: self.coverimagedata)
                        
                    })
                    {
                        
                        Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width-100).padding().font(.body)
                        
                    }.background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).padding(.top,50)
                }
                
               // Spacer()
                
            }}
            
        }
        
        
        .alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var imagedata : Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            let image = info[.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.parent.imagedata = data!
            
            self.parent.picker.toggle()
        }
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
}
