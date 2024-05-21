//
//  LiveStreamingMessageView.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/16/24.
//

import Foundation
import SwiftUI
import UIKit

// UIViewRepresentable 프로토콜을 준수하는 사용자 정의 SwiftUI 뷰
struct LiveStreamingMessageView: UIViewRepresentable {
    var data: [MessageRenderingProtocol]
    
    func makeUIView(context: Context) -> UITableView {
        print("ui 생성됨")
        let tableView = UITableView()
        
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator // Coordinator를 delegate로 설정
        tableView.register(ChatMessageWithButtonCell.self, forCellReuseIdentifier: "id")
        tableView.separatorStyle = .none
        
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        // Update the view when needed
        print("ui 업데이트")
        
        context.coordinator.updateData(data)
        uiView.reloadData()

        let indexPath = IndexPath(row: data.count - 1, section: 0)
        uiView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
    }
    
    func makeCoordinator() -> Coordinator {
        print("Coordinator. 업데이트")
        return Coordinator(data: data)
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var data: [MessageRenderingProtocol]
        
        let messageHorizantalPadding:CGFloat = 10
        let messageVerticalPadding:CGFloat = 10
        let textHorizantalPadding:CGFloat = 12
        let textVerticalPadding:CGFloat = 6
        
        let circleSize:CGFloat = 32 // 특수버튼 크기
        let circleHorizantalPadding:CGFloat = 10 // 버튼 가로 패딩
        
        let font:UIFont = UIFont.systemFont(ofSize: 14.0) // 버튼 가로 패딩
        
        init(data: [MessageRenderingProtocol]) {
            self.data = data
        }
        
        func updateData(_ newData: [MessageRenderingProtocol]) {
            self.data = newData
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // 특정 셀이 선택되었을 때의 동작을 처리합니다.
            print("셀이 선택되었습니다. 인덱스: \(indexPath.row)")
            
            // 선택된 셀 가져오기
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            // 선택된 이벤트 밖으로 전달
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            let messageRenderingProtocol = data[indexPath.row]
            
            let isButtonMessage:Bool = checkButtonMessage(messageRenderingProtocol: messageRenderingProtocol)
            let isErrorMessage:Bool = checkErrorMessage(messageRenderingProtocol: messageRenderingProtocol)
            
            let messageWidth = messageRenderingProtocol.getMessage()?.widthOfString(usingFont: UIFont.systemFont(ofSize: 14.0)) ?? .zero
            let messageHeight = messageRenderingProtocol.getMessage()?.heightOfString(usingFont: UIFont.systemFont(ofSize: 14.0)) ?? .zero
            
            var maxWidth = UIScreen.main.bounds.width - (messageHorizantalPadding * 2) - (textHorizantalPadding * 2)
            
            // 버튼이 있을시
            if isButtonMessage {
                maxWidth -= (circleSize + circleHorizantalPadding * 2)
            }
            
            let maxHeight = ceil(messageWidth/maxWidth) * messageHeight
            
            
            
            var errorHeight:CGFloat = .zero
            // errorBackgroundView의 크기 조정
            if isErrorMessage {
                errorHeight = messageHeight + textVerticalPadding * 2
            }
            
           
            return maxHeight + (messageVerticalPadding * 2) + (textVerticalPadding * 2) + (errorHeight)
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count // Set the number of rows as needed
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // 공통
            var messageRenderingProtocol = data[indexPath.row]
            
            let isButtonMessage:Bool = checkButtonMessage(messageRenderingProtocol: messageRenderingProtocol)
            let isErrorMessage:Bool = checkErrorMessage(messageRenderingProtocol: messageRenderingProtocol)
            // 재사용
            let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! ChatMessageWithButtonCell
            self.cellHandler(messageRenderingProtocol: messageRenderingProtocol, cell: cell)
            
            cell.setup(messageRenderingProtocol: messageRenderingProtocol, isButtonMessage: isButtonMessage, isErrorMessage: isErrorMessage)
            // 테이블 클릭시 UI 변경 막기
            cell.selectedBackgroundView = UIView()
            
            
            // 버튼 메시지용 ------
            // 버튼이 있는 메시지일시 버튼 등록
            if isButtonMessage {
                cell.circleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                // 어떤 인덱스인지 알수있도록 등록
                cell.circleButton.tag = indexPath.row
            }
            

            //  에러일시 ------ [기본메시지일때만]
            if isErrorMessage {
                cell.errorDeleteButton.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
                // 어떤 인덱스인지 알수있도록 등록
                cell.errorDeleteButton.tag = indexPath.row
                
                cell.errorResendButton.addTarget(self, action: #selector(resendTapped(_:)), for: .touchUpInside)
                // 어떤 인덱스인지 알수있도록 등록
                cell.errorResendButton.tag = indexPath.row
            }
            
            // 메시지
            let message = messageRenderingProtocol.getMessage() ?? ""
            
            let attributedString = boldingUserName(userName: messageRenderingProtocol.getActivityName() ?? "", message: message, font: font)

            cell.font = font
            cell.messageLabel.lineBreakMode = .byCharWrapping
            cell.messageLabel.attributedText = attributedString

            return cell
        }
        
        func boldingUserName (userName: String, message: String, font: UIFont) -> NSAttributedString {
            // 텍스트의 라인 간격 조절 (예: 8포인트)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.lineBreakMode = .byCharWrapping
            
            // NSMutableAttributedString을 사용하여 문자열 생성
            let attributedString = NSMutableAttributedString(string: message, attributes: [
                NSAttributedString.Key.font: font, // 기본 폰트
                NSAttributedString.Key.paragraphStyle: paragraphStyle // 단락 스타일
            ])
            
            // 특정 단어에 대한 스타일 적용
            let fullString = message ?? ""
            let range = (fullString as NSString).range(of: userName)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: range)
            
            return attributedString
        }
        
        func cellHandler (messageRenderingProtocol: MessageRenderingProtocol, cell: ChatMessageWithButtonCell) {
            // 메시지
            let message = messageRenderingProtocol.getMessage() ?? ""
            cell.font = font
            cell.messageLabel.lineBreakMode = .byCharWrapping
            cell.messageLabel.numberOfLines = 0
            cell.messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            switch messageRenderingProtocol.getMessageType() {
            case .normal :
                if messageRenderingProtocol.getMessageStatus() == .deleted {
                } else {
                    let attributedString = boldingUserName(userName: messageRenderingProtocol.getActivityName() ?? "", message: message, font: font)
                    cell.messageLabel.attributedText = attributedString
                }
            case .welcom :
                let socketResponseEvent = messageRenderingProtocol.getSocketResponseEvent()
                if socketResponseEvent == .welcome {

                } else if socketResponseEvent == .memberEntrance {
                    let attributedString = boldingUserName(userName: messageRenderingProtocol.getActivityName() ?? "", message: message, font: font)
                    cell.messageLabel.attributedText = attributedString
                    cell.startBackgroundColor = "#60E58A".toUIColor()!
                    cell.endBackgroundColor = "#60DDE5".toUIColor()!
                }
              return
            case .donate :
                return
            case .pin :
                return
            case .vote :
                return
            case .system :
                
                return
            case .none :
                return
            }
        }
        
        func checkButtonMessage(messageRenderingProtocol: MessageRenderingProtocol) -> Bool {
            var result = false
            if messageRenderingProtocol.getSocketResponseEvent() == .memberEntrance {
                result = true
            }
            return result
        }
        
        func checkErrorMessage(messageRenderingProtocol: MessageRenderingProtocol) -> Bool {
            var result = false
            if messageRenderingProtocol.getMessageStatus() == .failure {
                result = true
            }
            return result
        }
        
        @objc func buttonTapped(_ sender: UIButton) {
            let row = sender.tag
            print("Button in cell \(row) tapped")
        }
        
        @objc func deleteTapped(_ sender: UIButton) {
            let row = sender.tag
            print("Button deleteTapped in cell \(row) tapped")
        }
        
        @objc func resendTapped(_ sender: UIButton) {
            let row = sender.tag
            print("Button resendTapped in cell \(row) tapped")
        }
    }
}
