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
            
            LiveStreamingMessageView(data: vm.messageList)
                .frame(height: 300)
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

class ContentViewModel: ObservableObject {
    @Published var messageList: [any MessageRenderingProtocol] = [] // 메시지 리스트
    
    
    init() {
        let mg = "아무거나 막적음. ㅁㄴㅇㅁㅁㄴㅇㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴ ㅇㅁㄴㅇㅁㄴㅇㅁㄴ"
        for i in 0...1000 {
//            let preMessage = UserMsgResponse(message: "사용자 이름 \(i) 번째 메시지 \(i % 2 == 0 ? "\(mg)" + "\(mg)" + "\(mg)" : mg)", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "\(i)", userProfileImgUrl: "" )
//            
//            let messageRenderingProtocol: any MessageRenderingProtocol = preMessage
//            
//            self.messageList.append(messageRenderingProtocol)
            if i % 5 == 0 {
                let preMessage = MemberEntraceResponse(userId: 1, message: "사용자 이름님이 입장하셨습니다")
                var messageRenderingProtocol: any MessageRenderingProtocol = preMessage
                self.messageList.append(messageRenderingProtocol)
            } else if i % 3 == 0 {
                let preMessage = MemberEntraceResponse(userId: 1, message: "사용자 이름님이 입장하셨습니다")
                var messageRenderingProtocol: any MessageRenderingProtocol = preMessage
                self.messageList.append(messageRenderingProtocol)
            } else if i % 2 == 0 {
                let preMessage = UserMsgResponse(message: "에러입니다 \(i) 번째 에러 메시지 임 \(i % 4 == 0 ? "\(mg)" + "\(mg)" + "\(mg)" : mg)", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "에러입니다", userProfileImgUrl: "" )
                
                var messageRenderingProtocol: any MessageRenderingProtocol = preMessage
                
                messageRenderingProtocol.setMessageStatus(messageStatus: .failure)
                
                self.messageList.append(messageRenderingProtocol)
                
            } else {
                let preMessage = UserMsgResponse(message: "온석태 \(i) 번째 메시지 \(i % 2 == 0 ? "\(mg)" + "\(mg)" + "\(mg)" : mg)", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "온석태", userProfileImgUrl: "" )
                
                let messageRenderingProtocol: any MessageRenderingProtocol = preMessage
                
                self.messageList.append(messageRenderingProtocol)
            }
           
        }
        
    }
    
    
    func appendMeesage () {
        let preMessage = UserMsgResponse(message: "새로운 인간 \(self.messageList.count) 번째 메시지", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "새로운 인간", userProfileImgUrl: "" )
        
        var messageRenderingProtocol: any MessageRenderingProtocol = preMessage
        messageRenderingProtocol.setMessageStatus(messageStatus: .success)
        
        self.messageList.append(messageRenderingProtocol)
    }
}
