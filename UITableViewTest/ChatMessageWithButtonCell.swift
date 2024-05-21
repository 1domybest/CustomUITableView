//
//  ChatMessageWithButtonCell.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/20/24.
//

import Foundation
import UIKit

class ChatMessageWithButtonCell: UITableViewCell {
    
    var messageRenderingProtocol:MessageRenderingProtocol?
    
    var message: NSAttributedString? // 텍스트
    
    let messageLabel = UILabel() // 텍스트 라벨
    
    var font = UIFont.boldSystemFont(ofSize: 14) // 폰트
    
    // 기본 배경뷰
    let messageBackgroundView = UIView()
    
    // 에러
    let errorBackgroundView = UIView()
    
    let messageHorizantalPadding:CGFloat = 10 // 배경 가로 패딩
    let messageVerticalPadding:CGFloat = 10 // 배경 세로 패딩
    
    var textHorizantalPadding:CGFloat = 12 // 배경과 글자사이 가로 패딩
    var textVerticalPadding:CGFloat = 6 // 배경과 글자사이 세로 패딩
    
    var errorImageSize:CGFloat = 20 // 배경과 글자사이 가로 패딩
    var errorHorizantalPadding:CGFloat = 7 // 배경과 글자사이 가로 패딩
    var errorVerticalPadding:CGFloat = 4 // 배경과 글자사이 세로 패딩
    
    let circleSize:CGFloat = 32 // 특수버튼 크기
    let circleHorizantalPadding:CGFloat = 10 // 버튼 가로 패딩
    
    var textColor: UIColor = .white
    var startBackgroundColor: UIColor = .black.withAlphaComponent(0.5)
    var endBackgroundColor: UIColor = .black.withAlphaComponent(0.5)
    var circleButtonImage: UIImage = UIImage(resource: .iconXmark)
        
    let circleButton: UIButton = {
          let button = UIButton()
          button.translatesAutoresizingMaskIntoConstraints = false
          button.backgroundColor = .blue // 버튼의 배경색 설정
          button.layer.cornerRadius = 16 // 버튼을 원형으로 만들기 위해 적절한 값을 지정합니다.
          button.widthAnchor.constraint(equalToConstant: 32).isActive = true // 너비 설정
          button.heightAnchor.constraint(equalToConstant: 32).isActive = true // 높이 설정
          return button
      }()
    

    let errorDeleteButton: UIButton = {
          let button = UIButton()
          button.translatesAutoresizingMaskIntoConstraints = false
          button.widthAnchor.constraint(equalToConstant: 20).isActive = true // 너비 설정
          button.heightAnchor.constraint(equalToConstant: 20).isActive = true // 높이 설정
          return button
      }()
    
    let errorResendButton: UIButton = {
          let button = UIButton()
          button.translatesAutoresizingMaskIntoConstraints = false
          button.widthAnchor.constraint(equalToConstant: 20).isActive = true // 너비 설정
          button.heightAnchor.constraint(equalToConstant: 20).isActive = true // 높이 설정
          return button
      }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let isButtonMessage: Bool = checkButtonMessage()
        let isErrorMessage: Bool = checkErrorMessage()
        
        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        errorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        
        addSubview(messageBackgroundView)
        addSubview(messageLabel)
        
        if isErrorMessage {
            addSubview(errorBackgroundView)
            contentView.addSubview(errorDeleteButton)
            contentView.addSubview(errorResendButton)
        }
        
        if isButtonMessage {
            contentView.addSubview(circleButton)
        }
        
        
        errorResendButton.setImage(UIImage(resource: .iconReset), for: .normal)
        errorDeleteButton.setImage(UIImage(resource: .iconXmark), for: .normal)
        
        messageLabel.attributedText = message
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            // 메시지 백그라운드 컬러 오토사이징
            messageBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: messageVerticalPadding),
            messageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: messageHorizantalPadding),
            messageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: messageVerticalPadding),
            messageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: messageHorizantalPadding),

            // 메시지 라벨 오토사이징
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: textVerticalPadding),
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant:  textHorizantalPadding),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: textVerticalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: textHorizantalPadding),
        ]
        
        if isErrorMessage {
            let errorConstraints = [
                errorBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: messageVerticalPadding),
                errorBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: messageHorizantalPadding),
                errorBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: messageVerticalPadding),
                errorBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: messageHorizantalPadding),
            ]
            // 기존 constraints 배열에 새로운 제약 조건 추가
            constraints.append(contentsOf: errorConstraints)
        }
        
        NSLayoutConstraint.activate(constraints)
        
        contentView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isButtonMessage: Bool = checkButtonMessage()
        let isErrorMessage: Bool = checkErrorMessage()
        
        // 텍스트 가로 길이
        let textWidth = messageLabel.text?.widthOfString(usingFont: font) ?? .zero
        // 텍스트 1줄당 세로 길이
        let textLineHeight = messageLabel.text?.heightOfString(usingFont: font) ?? .zero
        
        // 최대 가로 길이 + 버튼 패딩 + 사이즈
        var maxWidth = bounds.width - (messageHorizantalPadding * 2) - (textHorizantalPadding * 2)
        
        // 버튼이 있을시
        if isButtonMessage {
            maxWidth -= (circleSize + circleHorizantalPadding * 2)
        }
        
        // 최종 텍스트 사이즈
        let finalTextWidth = textWidth > maxWidth ? maxWidth : textWidth
        let finalTextHeight = ceil(textWidth/maxWidth) * textLineHeight
        
        // 메인 텍스트 레이아웃
        self.layoutMainText(finalTextWidth: finalTextWidth, finalTextHeight: finalTextHeight)
        
        // 메인 텍스트 백그라운드 레이아웃
        self.layoutMainTextBackground(finalTextWidth: finalTextWidth, finalTextHeight: finalTextHeight, isErrorButton: isErrorMessage)

        // 오른쪽 버튼이 있을시
        if isButtonMessage {
            self.layoutButton()
        }
        
        // 에러시
        if isErrorMessage {
            self.layoutErrorView(textLineHeight: textLineHeight)
        }

    }
    
    func checkButtonMessage() -> Bool {
        var result = false

        if messageRenderingProtocol?.getSocketResponseEvent() == .memberEntrance {
            result = true
        }
        return true
    }
    
    func checkErrorMessage() -> Bool {
        var result = false
        if messageRenderingProtocol?.getMessageStatus() == .failure {
            result = true
        }
        return true
    }
    
    func layoutMainText(finalTextWidth: CGFloat, finalTextHeight: CGFloat) {
        messageLabel.frame.size.width = finalTextWidth
        messageLabel.frame.size.height = finalTextHeight
        messageLabel.textColor = self.textColor
    }
    
    func layoutMainTextBackground(finalTextWidth: CGFloat, finalTextHeight: CGFloat, isErrorButton: Bool) {
        messageBackgroundView.frame.size.width = finalTextWidth + textHorizantalPadding * 2
        messageBackgroundView.frame.size.height = finalTextHeight + textVerticalPadding * 2
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = messageBackgroundView.bounds
        gradientLayer.colors = [self.startBackgroundColor.cgColor, self.endBackgroundColor.cgColor] // 여기에 원하는 두 색상을 넣어주세요
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 8
        
        // 에러시
        if isErrorButton {
            gradientLayer.borderColor = UIColor.red.cgColor // 보더 색상 설정
            gradientLayer.borderWidth = 1.2 // 보더 너비 설정
        }
        
        messageBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        messageBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func layoutButton() {
        let bubbleWidth = messageBackgroundView.frame.width
        let bubbleHeight = messageBackgroundView.frame.height
        
        // 버튼의 위치 계산
        circleButton.frame.origin.x = messageBackgroundView.frame.origin.x + bubbleWidth + circleHorizantalPadding
        circleButton.frame.origin.y = messageBackgroundView.frame.origin.y + (bubbleHeight - circleSize) / 2

     }
    
    func layoutErrorView (textLineHeight: CGFloat) {
        // errorBackgroundView의 크기 조정
        errorBackgroundView.frame.size.width = 68
        errorBackgroundView.frame.size.height = textLineHeight + textVerticalPadding * 2
        
        // errorBackgroundView의 위치를 bubbleBackgroundView 아래 4픽셀에 배치
        errorBackgroundView.frame.origin.x = messageBackgroundView.frame.origin.x
        errorBackgroundView.frame.origin.y = messageBackgroundView.frame.maxY + errorVerticalPadding
        
        errorResendButton.frame.origin.x = errorBackgroundView.frame.origin.x + errorHorizantalPadding
        errorResendButton.frame.origin.y = errorBackgroundView.frame.origin.y + errorVerticalPadding
        
        errorDeleteButton.frame.origin.x = errorBackgroundView.frame.maxX - (errorImageSize + errorHorizantalPadding) // errorDeleteButton의 오른쪽에 위치
        errorDeleteButton.frame.origin.y = errorBackgroundView.frame.origin.y + errorVerticalPadding
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: errorBackgroundView.bounds.midX, y: 0))
        linePath.addLine(to: CGPoint(x: errorBackgroundView.bounds.midX, y: errorBackgroundView.bounds.height))

        // 선을 그리기 위한 shape layer 생성
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor // 선 색상
        lineLayer.lineWidth = 0.5 // 선 두께
        lineLayer.lineDashPattern = [] // 점선 패턴 설정

        // errorBackgroundView에 새로운 선 추가
        errorBackgroundView.backgroundColor = .red
        errorBackgroundView.layer.cornerRadius = 8
        
        errorBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        errorBackgroundView.layer.addSublayer(lineLayer)
    }
}
