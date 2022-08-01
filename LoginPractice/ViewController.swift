//
//  ViewController.swift
//  LoginPractice
//
//  Created by 김현석 on 2022/07/30.
//

import UIKit

class ViewController: UIViewController {
    
    
    var emailResult: Bool = false
    var passwordResult: Bool = false
    
    
    
    // MARK: - 이메일 입력하는 텍스트 뷰
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(emailTextField)
        view.addSubview(emailInfoLabel)
        return view
    }()
    
    // MARK: "이메일 또는 전화번호" 안내 문구
    private var emailInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "이메일 주소 또는 전화번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        return label
    }()
    
    // MARK: 이메일 입력 필드
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        
        tf.frame.size.height = 48
        tf.backgroundColor = .clear // 투명
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none // 자동 대문자
        tf.autocorrectionType = .no // 오타 체크
        tf.spellCheckingType = .no // 스펠링 체크
        tf.keyboardType = .emailAddress
        tf.clearButtonMode = .always
        
        // 값이 변할때마다 selector에 매핑된 메서드 실행.
        tf.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        return tf
    }()
    
    // MARK: - 비밀번호 입력하는 텍스트 뷰
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(passwordTextField)
        view.addSubview(passwordInfoLabel)
        view.addSubview(passwordSecureButton)
        
        return view
    }()
    
    // MARK: 비밀번호 텍스트필드의 안내문구
    private var passwordInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        return label
    }()
    
    // MARK: 비밀번호 입력 필드
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.frame.size.height = 48
        tf.backgroundColor = .clear // 투명
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true // 입력한거 안보이게 마스킹
        tf.clearsOnBeginEditing = false // 텍스트 입력할 때, 마지막으로 입력한거 지운다는 거 같음.
        
        // 값이 변할때마다 selector에 매핑된 메서드 실행.
        tf.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        return tf
    }()
    
    // MARK: 비밀번호에 "표시" 버튼 비밀번호 가리기 기능
    private let passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom) // .system도 많이 씀.
        
        button.setTitle("표시", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 로그인 버튼
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false // 이메일, 비밀번호 입력했을 때만 활성화
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 비밀번호 재설정 버튼
    private let passwordResetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    // MARK: - 스택뷰 생성
    lazy var stackView: UIStackView = {
        // 아래 3개 뷰를 스택뷰로 묶겠다.
        let sv = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        
        sv.spacing = 18
        sv.axis = .vertical // 세로로 정렬 (축)
        sv.distribution = .fillEqually
        sv.alignment = .fill // 정렬기준 = 다 채우기
        
        return sv
    }()
    
    // 3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 48
    
    // AutoLayout 향후 변경을 위한 변수(애니메이션)
    lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)
    lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 확장된 뷰 컨트롤러에 프로토콜을 채택하고 여기서 뷰컨트롤러가 대리자의 역할을 함.⭐️
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        // 바탕화면 선택하면 키보드 내려가기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        
        makeUI()
    }
    
    
    // MARK: - AutoLayout 설정
    func makeUI() {
        
        view.backgroundColor = UIColor.black
        view.addSubview(stackView) // 여기서 뷰는 ViewController의 view임
        view.addSubview(passwordResetButton)
        
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        passwordResetButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 아래코드보면 .isActive = true 매번하기 귀찮으니 액티브시킬거는 여기다가 때려 넣자.
        NSLayoutConstraint.activate([
              // emailTextFieldView로 부터 8만큼 띄우겠다.
              emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8)   // 좌
            , emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8) // 우
            
            // 세로로 가운데 정렬 constant: 0 지워도 됨.
//            , emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor, constant: 0)
            , emailInfoLabelCenterYConstraint
            
            , emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8)
            , emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8)
            , emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15)
            , emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2)
            
            , passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8)
            , passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: 8)
//            , passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
            , passwordInfoLabelCenterYConstraint
            
            , passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8)
            , passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: 8)
            , passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15)
            , passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 2)
            
            , passwordSecureButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8)
            , passwordSecureButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15)
            , passwordSecureButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15)
              
            , stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
            , stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            , stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            , stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            , stackView.heightAnchor.constraint(equalToConstant: textViewHeight * 3 + 36)
              
            , passwordResetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
            , passwordResetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            , passwordResetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
            , passwordResetButton.heightAnchor.constraint(equalToConstant: textViewHeight)

        ])
        
        // emailTextFieldView로 부터 8만큼 띄우겠다.
        //        emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true // 좌
        //        emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8).isActive = true // 우
        //
        //        // 세로로 가운데 정렬 constant: 0 지워도 됨.
        //        emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor, constant: 0).isActive = true
        
        
        //        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        //        emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
        //        emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8).isActive = true
        //        emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15).isActive = true
        //        emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2).isActive = true
    }
    
    @objc func resetButtonTapped() {
        // alert창 만들기.
        // 1) 컨트롤러 만들고
        let alert = UIAlertController(title: "비밀번호 바꾸기", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        
        // 2) 컨트롤러 위에 액션을 쌓아올린다.
        let success = UIAlertAction(title: "확인", style: .default) { action in print("확인 버튼이 눌렸습니다.") }
        let cancel = UIAlertAction(title: "취소", style: .default) { action in print("취소 버튼이 눌렸습니다.") }
        
        // addView처럼 alert를 맨밑에 깔고 쌓아올린다는 느낌
        alert.addAction(success)
        alert.addAction(cancel)
        
        // 메모리에만 올린걸 화면에 뿌려준다.
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - 비밀번호 가린거 풀기
    @objc private func passwordSecureModeSetting() {
        
        passwordTextField.isSecureTextEntry.toggle()
    }

    @objc private func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
    }
    
    
    // 밖에 클릭하면 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


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








// ViewController 확장 후 프로토콜 채택해야 코드가 깔끔해짐.
// 뷰 컨트롤러 내 viewDidLoad 함수 실
extension ViewController: UITextFieldDelegate {


    
    // 입력 시작시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            print("이메일 텍스트 입력 시작")
            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
            emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            
            // 오토레이아웃 업데이트
            emailInfoLabelCenterYConstraint.constant = -13

        }
        
        if textField == passwordTextField {
            print("비밀번호 텍스트 입력 시작.")
            passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
            passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            
            // 오토레이아웃 업데이트
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        // 애니매이션 효과
        UIView.animate(withDuration: 0.3) {
            
            // 하나하나 설정하기 번거롭기 때문에 stackView 하위에 있는거는 다 애니메이션 설정
            self.stackView.layoutIfNeeded()
            
//            self.emailTextFieldView.layoutIfNeeded()
//            self.passwordTextFieldView.layoutIfNeeded()

        }
    }
    
    // 입력 끝날 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            print("이메일 텍스트 입력 끝.")
            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            
            // 빈칸이면 원래대로 되돌리기
            if emailTextField.text == "" {
                emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }
        
        if textField == passwordTextField {
            print("비밀번호 텍스트 입력 끝.")
            passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            
            // 빈칸이면 원래대로 되돌리기
            if passwordTextField.text == "" {
                passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
        
        //
        guard let password = passwordTextField.text else { return }
        passwordResult = isValidPassword(pw: password)
        //print("passworedResult : \(passwordResult)")
        
        if emailResult == true && passwordResult == true {
            loginButton.backgroundColor = .red
            loginButton.isEnabled = true
        }

        // 애니매이션 효과
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
//    // 이메일 정규식
//    func isValidEmail(email: String?) -> Bool {
//
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailResult = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//
//        return emailResult.evaluate(with: email)
//    }
//
//
//    func isValidPassword(pw: String?) -> Bool{
//
//        // 8자리 ~ 50자리 영어+숫자+특수문자
//        let pwRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
//        let pwResult = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
//
//        return pwResult.evaluate(with: pw)
//    }

    
    // 입력할때마다 실행
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//        print("입력")
        
//        if textField == emailTextField {
//            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
//
//            // 빈칸이면 원래대로 되돌리기
//            if emailTextField.text == "" {
//                emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
//                emailInfoLabelCenterYConstraint.constant = 0
//            }
//        }
        
//        if textField == passwordTextField {
//            passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
//
//            // 빈칸이면 원래대로 되돌리기
//            if passwordTextField.text == "" {
//                print("비번빈칸")
//                passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
//                passwordInfoLabelCenterYConstraint.constant = 0
//            }
//        }

        
//        text가 존재하고 비어있지 않다면 email로 바인딩
        guard let email = emailTextField.text else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
            
            return
        }
        
        guard let password = passwordTextField.text else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
            return
            
        }
        
        emailResult = isValidEmail(email: email)
        passwordResult = isValidPassword(pw: password)
        
        print("emailResult: \(emailResult)")
        print("passworedResult : \(passwordResult)")
        
        if emailResult == true && passwordResult == true {
            loginButton.backgroundColor = .red
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
        }
    }
    
    
    // 다른 곳 누르면 키보드 내려감.
    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    
    
}

