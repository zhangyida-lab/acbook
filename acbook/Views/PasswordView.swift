//
//  PasswordView.swift
//  acbook
//
//  Created by tony on 27/3/2025.
//

import SwiftUI
struct PasswordView: View {
    @Binding var isPasswordCorrect: Bool
    @State private var enteredPassword = ""

    var body: some View {
        VStack {
            Text("请输入密码")
                .font(.title2)
                .padding()

            SecureField("Password", text: $enteredPassword)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.horizontal)

            Button(action: {
                checkPassword()
            }) {
                Text("确定")
                    .font(.title3)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }

    func checkPassword() {
        if enteredPassword == "1234" {  // 假设密码是 "1234"
            isPasswordCorrect = true
        } else {
            enteredPassword = ""  // 错误密码清空输入框
        }
    }
}
