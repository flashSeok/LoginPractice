//
//  CheckManager.swift
//  LoginPracticeMVC
//
//  Created by 김현석 on 2022/08/06.
//

import UIKit


class CheckManager {
    
    var emailResult: Bool = false
    var passwordResult: Bool = false
    
    
    // 이메일 정규식
    func isValidEmail(email: String?) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailResult = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailResult.evaluate(with: email)
    }
    
    
    func isValidPassword(pw: String?) -> Bool{
        
        // 8자리 ~ 50자리 영어+숫자+특수문자
        let pwRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let pwResult = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
        
        return pwResult.evaluate(with: pw)
    }
    
}
