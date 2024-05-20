//
//  ContentView.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/16/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                vm.appendMeesage()
            }, label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.blue)
                    .overlay(
                        Text("+ 추가")
                            .foregroundColor(.white)
                    )
            })
            
            Spacer().frame(height: 50)
            
            LiveStreamingMessageViewWrapper(data: vm.messageList)
                .frame(height: 300)
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

class ContentViewModel: ObservableObject {
    @Published var messageList: [any MessageRenderingProtocol] = [] // 메시지 리스트
    
    
    init() {
        let mg = "아무거나 막적음"
        for i in 0...1000 {
            let preMessage = UserMsgResponse(message: "사용자 이름 \(i) 번째 메시지 \(i % 2 == 0 ? "\(mg)" + "\(mg)" + "\(mg)" : mg)", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "\(i)", userProfileImgUrl: "" )
            
            let messageRenderingProtocol: any MessageRenderingProtocol = preMessage
            
            self.messageList.append(messageRenderingProtocol)
        }
        
    }
    
    
    func appendMeesage () {
        let preMessage = UserMsgResponse(message: "\(self.messageList.count) 번째 메시지", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "\(self.messageList.count)", userProfileImgUrl: "" )
        
        let messageRenderingProtocol: any MessageRenderingProtocol = preMessage
        
        self.messageList.append(messageRenderingProtocol)
    }
}
