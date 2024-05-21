//
//  MemberEntrance.swift
//  HypyG
//
//  Created by 온석태 on 2/29/24.
//

import Foundation
import SwiftUI

struct MemberEntraceResponse: Decodable, MessageRenderingProtocol {
    
    func getTarActivityName() -> String? {
        return nil
    }
    
    func getTarProfileImgUrl() -> String? {
        return nil
    }
    
    func getUserPid() -> String? {
        return nil
    }
    
    func getActivityName() -> String? {
        return nil
    }
    
    func getProfileImgUrl() -> String? {
        return nil
    }
    
    func getTarUserType() -> String? {
        return nil
    }
    
    mutating func setMessage(message: String) {
        self.message = message
    }
    
    func getMessageId() -> String? {
        return nil
    }
    
    
    let socketResponseEvent: SocketResponseEvent = .memberEntrance
    let messageType: MessageType = .welcom
    
    private enum CodingKeys: String, CodingKey {
         case message, userId
     }
    
    var userId: Int
    var message: String
    
    var finalMessage: String {
        get {
            return message
        }
        set {
            message = newValue
        }
    }
    
    var messageStatus: MessageStatus = .waiting
    
    var index:Int?
    
    func getIndex() -> Int? {
        if index == nil {
            return -99
        } else {
            return self.index
        }
    }
    
    func getMessageStatus() -> MessageStatus {
        return self.messageStatus
    }
    
    mutating func setMessageStatus(messageStatus: MessageStatus) {
        self.messageStatus = messageStatus
    }
    
    func getSocketResponseEvent() -> SocketResponseEvent {
        return self.socketResponseEvent
    }
    
    func getMessageType() -> MessageType {
        self.messageType
    }
    
    func getUserId() -> Int? {
        return userId
    }
    
    func getUserType() -> String? {
        return nil
    }
    
    func getMessage() -> String? {
        return self.message
    }
    
    func getMessagechanged() -> Bool {
        return false
    }
    
    func getIdolManagerMsg() -> String? {
        return nil
    }
    
    func getProducerMsg() -> String? {
        return nil
    }
    
    func getCreatorIdolId() -> Int? {
        return nil
    }
    
    func getTarUserId() -> Int? {
        return nil
    }
    
    func getTarUserMsg() -> String? {
        return nil
    }
    
    func getRoomId() -> Int? {
        return nil
    }
    
    func getTarMessageId() -> String? {
        return nil
    }
    
    func getDonateValue() -> Int? {
        return nil
    }
    
    func getCount() -> Int? {
        return nil
    }
    
    func getCode() -> Int? {
        return nil
    }
    
    func getStatus() -> String? {
        return nil
    }
    
    func getData() -> [Any]? {
        return nil
    }
}
