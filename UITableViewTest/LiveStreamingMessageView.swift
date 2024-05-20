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
           
           DispatchQueue.main.async {
               let indexPath = IndexPath(row: data.count - 1, section: 0)
               uiView.scrollToRow(at: indexPath, at: .bottom, animated: true)
           }
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
               
               let messageWidth = data[indexPath.row].getMessage()?.widthOfString(usingFont: UIFont.systemFont(ofSize: 14.0)) ?? .zero
               let messageHeight = data[indexPath.row].getMessage()?.heightOfString(usingFont: UIFont.systemFont(ofSize: 14.0)) ?? .zero
      
               let maxWidth = UIScreen.main.bounds.width - (messageHorizantalPadding * 2) - (textHorizantalPadding * 2)
               let maxHeight = ceil(messageWidth/maxWidth) * messageHeight
               
               return maxHeight + (messageVerticalPadding * 2) + (textVerticalPadding * 2)
           }
           
           
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return data.count // Set the number of rows as needed
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! ChatMessageWithButtonCell
               cell.indexPath = indexPath

               cell.selectedBackgroundView = UIView()
               
               
               let message = data[indexPath.row].getMessage() ?? ""
               
               // 텍스트의 라인 간격 조절 (예: 8포인트)
               let paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.lineSpacing = 0
               paragraphStyle.lineBreakMode = .byCharWrapping
               
               let font = UIFont.systemFont(ofSize: 14.0)
               
               cell.font = font
               
               // NSMutableAttributedString을 사용하여 문자열 생성
               let attributedString = NSMutableAttributedString(string: message, attributes: [
                   NSAttributedString.Key.font: font, // 기본 폰트
                   NSAttributedString.Key.paragraphStyle: paragraphStyle // 단락 스타일
               ])

               // 특정 단어에 대한 스타일 적용
               let fullString = data[indexPath.row].getMessage() ?? ""
               let range = (fullString as NSString).range(of: "사용자 이름")
               attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: range)
               
               cell.messageLabel.lineBreakMode = .byCharWrapping
               cell.messageLabel.attributedText = attributedString
               
               return cell
           }
           
           func messageHandler () {
               
           }
       }
}
