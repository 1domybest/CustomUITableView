//
//  ChatMessageCell.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/17/24.
//

import Foundation
import UIKit

class ChatMessageCell: UITableViewCell {
    var message: NSAttributedString? // 메시지 속성 변경
    
    let messageLabel = UILabel()
    
    var font = UIFont.boldSystemFont(ofSize: 14)
    
    let bubbleBackgroundView = UIView()
    
    let messageHorizantalPadding:CGFloat = 10
    let messageVerticalPadding:CGFloat = 10
    
    var textHorizantalPadding:CGFloat = 12
    var textVerticalPadding:CGFloat = 6
    
    
    let circleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue // 버튼의 배경색 설정
        button.layer.cornerRadius = 12 // 버튼을 원형으로 만들기 위해 적절한 값을 지정합니다.
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        
        messageLabel.attributedText = message
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            // 메시지 백그라운드 컬러 오토사이징
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: messageVerticalPadding),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: messageHorizantalPadding),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: messageVerticalPadding),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: messageHorizantalPadding),
            
            // 메시지 라벨 오토사이징
            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: textVerticalPadding),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant:  textHorizantalPadding),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: textVerticalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: textHorizantalPadding),
   
        ]

        NSLayoutConstraint.activate(constraints)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 텍스트 가로 길이
        let textWidth = messageLabel.text?.widthOfString(usingFont: font) ?? .zero
        // 텍스트 1줄당 세로 길이
        let textLineHeight = messageLabel.text?.heightOfString(usingFont: font) ?? .zero
        
        // 최대 가로 길이
        let maxWidth = bounds.width - (messageHorizantalPadding * 2) - (textHorizantalPadding * 2)
        
        // 최종 텍스트 사이즈
        let finalTextWidth = textWidth > maxWidth ? maxWidth : textWidth
        let finalTextHeight = ceil(textWidth/maxWidth) * textLineHeight
        
        messageLabel.frame.size.width = finalTextWidth
        messageLabel.frame.size.height = finalTextHeight

        bubbleBackgroundView.frame.size.width = finalTextWidth + textHorizantalPadding * 2
        bubbleBackgroundView.frame.size.height = self.bounds.height - messageVerticalPadding * 2
        
        
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bubbleBackgroundView.bounds
        gradientLayer.colors = [UIColor(red: 0.72, green: 0.75, blue: 1, alpha: 0.8).cgColor, UIColor(red: 0.82, green: 0.53, blue: 1, alpha: 0.8).cgColor] // 여기에 원하는 두 색상을 넣어주세요
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 8
        
//         이전 그라데이션 레이어를 제거하고 새로운 것을 추가합니다.
        bubbleBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        bubbleBackgroundView.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    
}




