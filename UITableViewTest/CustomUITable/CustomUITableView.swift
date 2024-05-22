//
//  NewCustomTableView.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/21/24.
//

import Foundation

import UIKit

import SwiftUI

class CustomUITableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var data: [MessageRenderingProtocol]
    var onClickDelete: ((Int) -> Void)?
    var onClickResend: ((Int) -> Void)?
    var onClickReaction: ((Int) -> Void)?
    
    let messageHorizantalPadding:CGFloat = 10
    let messageVerticalPadding:CGFloat = 10
    let textHorizantalPadding:CGFloat = 12
    let textVerticalPadding:CGFloat = 6
    
    let circleSize:CGFloat = 32 // 특수버튼 크기
    let circleHorizantalPadding:CGFloat = 10 // 버튼 가로 패딩
    
    let font:UIFont = UIFont.systemFont(ofSize: 14.0) // 버튼 가로 패딩
    
    
    init(data: [MessageRenderingProtocol], onClickDelete: @escaping ((Int) -> Void), onClickResend: @escaping ((Int) -> Void), onClickReaction: @escaping ((Int) -> Void)) {
        self.data = data
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
        self.delegate = self
        self.register(ChatMessageCell.self, forCellReuseIdentifier: "id")
        self.separatorStyle = .none
        
        self.onClickDelete = onClickDelete
        self.onClickResend = onClickResend
        self.onClickReaction = onClickReaction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToBottom () {
        let indexPath = IndexPath(row: self.data.count - 1, section: 0)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func updateData(_ newData: [MessageRenderingProtocol]) {
        self.data = newData
    }
    
    func appendData(_ newData: MessageRenderingProtocol) {
        self.data.append(newData)
        self.tableView(self, numberOfRowsInSection: self.numberOfSections)
        self.reloadData()
    }
    
    func updateRow(_ newData: MessageRenderingProtocol, index: Int) {
        self.data[index] = newData
        self.performBatchUpdates({
            self.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }, completion: { _ in
            print("\(index) 업데이트 성공")
        })
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
        
        var maxWidth = bounds.width - (messageHorizantalPadding * 2) - (textHorizantalPadding * 2)
        
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
        print("몇개? \(data.count)")
        return data.count // Set the number of rows as needed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 공통
        var messageRenderingProtocol = data[indexPath.row]
        
        let isButtonMessage:Bool = checkButtonMessage(messageRenderingProtocol: messageRenderingProtocol)
        let isErrorMessage:Bool = checkErrorMessage(messageRenderingProtocol: messageRenderingProtocol)
        // 재사용
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! ChatMessageCell
        self.cellHandler(messageRenderingProtocol: messageRenderingProtocol, cell: cell)

        // 테이블 클릭시 UI 변경 막기
        cell.selectedBackgroundView = UIView()
        
        // 버튼 메시지용 ------
        // 버튼이 있는 메시지일시 버튼 등록
        if isButtonMessage {
            cell.circleButtonImage = UIImage(resource: .iconButton2)
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
        
        cell.setup(messageRenderingProtocol: messageRenderingProtocol, isButtonMessage: isButtonMessage, isErrorMessage: isErrorMessage)
        
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
    
    func cellHandler (messageRenderingProtocol: MessageRenderingProtocol, cell: ChatMessageCell) {
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
            if messageRenderingProtocol.getMessageStatus() != .success {
                result = true
            }

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
        self.data[row].setMessageStatus(messageStatus: .success)
        
        var view: UIView? = sender
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        if let tableView = view as? UITableView {
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            }, completion: { _ in
                print("버튼 클릭 성공")
                // 부모로 콜백 호출
                self.onClickReaction?(row)
            })
        }
    }
    
    @objc func deleteTapped(_ sender: UIButton) {
        let row = sender.tag
        print("Button deleteTapped in cell \(row) tapped")

        // 현재 뷰 계층에서 UITableView를 찾습니다.
        var view: UIView? = sender
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        if let tableView = view as? UITableView {
            guard let cell = sender.superview?.superview as? ChatMessageCell else {
                 print("Unable to find the cell containing the button.")
                 return
             }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                   print("Unable to find the index path of the cell.")
                   return
               }
            
            // 데이터를 업데이트합니다.
            var newData = self.data
            newData.remove(at: row)
            self.updateData(newData)
            
            // 데이터를 삭제한 후 테이블 뷰에서 해당 행을 삭제합니다.
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .none)
            }, completion: { _ in
                tableView.performBatchUpdates({
                    tableView.reloadData()
                }, completion: { _ in
                    print("버튼 삭제 성공")
                    // 부모로 콜백 호출
                    self.onClickDelete?(row)
                })
            })
            
        }
    }
    
    @objc func resendTapped(_ sender: UIButton) {
        let row = sender.tag
        print("Button resendTapped in cell \(row) tapped")
        self.data[row].setMessageStatus(messageStatus: .waiting)
        
        var view: UIView? = sender
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        if let tableView = view as? UITableView {
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            }, completion: { _ in
                print("재전송 클릭 성공")
                // 부모로 콜백 호출
                self.onClickResend?(row)
            })
        }
    }
    
}

struct CustomUITableViewRepresentable: UIViewRepresentable {
    var view: UITableView
    
    init(view: UITableView?) {
        self.view = view ?? UITableView()
    }
    
    // UIViewRepresentable에서 필요한 makeUIView 메서드
    func makeUIView(context: Context) -> UITableView {
        return view
    }
    
    // UIViewRepresentable에서 필요한 updateUIView 메서드
    func updateUIView(_ uiView: UITableView, context: Context) {
        // 필요에 따라 UI 업데이트 로직을 추가
    }
}
