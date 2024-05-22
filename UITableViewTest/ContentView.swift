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
            
            CustomUITableViewRepresentable(view: vm.newCustomTableView)
                .frame(height: UIScreen.main.bounds.height/3)
            
//            CustomUITableView(
//                data: vm.messageList,
//                onClickDelete: { index in
//                    print("onClickDelete callback index = \(index)")
//                }, onClickResend: { index in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.vm.messageList[index].setMessageStatus(messageStatus: .failure)
//                        print("onClickResend callback index = \(index)")
//                    }
//                }, onClickReaction: { index in
//                    print("onClickReaction callback index = \(index)")
//                })
//                .frame(height: 300)
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

class ContentViewModel: ObservableObject {
    var messageList: [any MessageRenderingProtocol] = [] // 메시지 리스트
    var newCustomTableView:CustomUITableView?
    
    init() {
        let mg = "아무거나 막적음. ㅁㄴㅇㅁㅁㄴㅇㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴ ㅇㅁㄴㅇㅁㄴㅇㅁㄴ"
        for i in 0...1000 {
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
       
        self.newCustomTableView = CustomUITableView(
                data: self.messageList,
                onClickDelete: onClickDelete,
                onClickResend: onClickResend,
                onClickReaction: onClickReaction
            )
        
    }
    
    func onClickDelete (index: Int) {
        print("onClickDelete callback index = \(index)")
    }
    
    func onClickResend (index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.messageList[index].setMessageStatus(messageStatus: .failure)
            print("onClickResend callback index = \(index)")
            self.newCustomTableView?.updateRow(self.messageList[index], index: index)
        }
    }
    
    func onClickReaction (index: Int) {
        print("onClickReaction callback index = \(index)")
    }
    
    
    func appendMeesage () {
        let preMessage = UserMsgResponse(message: "새로운 인간 \(self.messageList.count) 번째 메시지", messageId: "", userId: 1, userType: "", messageChanged: false, userPid: "", userName: "새로운 인간", userProfileImgUrl: "" )
        
        var messageRenderingProtocol: any MessageRenderingProtocol = preMessage
        messageRenderingProtocol.setMessageStatus(messageStatus: .success)
        
        self.messageList.append(messageRenderingProtocol)
        
        self.newCustomTableView?.appendData(messageRenderingProtocol)
        self.newCustomTableView?.scrollToBottom()
        
    }
}
