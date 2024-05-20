//
//  RequestUserMsg.swift
//  HypyG
//
//  Created by 온석태 on 12/19/23.
//

import Foundation
import SwiftUI

struct UserMsgResponse: Decodable, MessageRenderingProtocol {
    
    func getTarActivityName() -> String? {
        return nil
    }
    
    func getTarProfileImgUrl() -> String? {
        return nil
    }
    
    func getUserPid() -> String? {
        return userPid
    }
    
    func getTarUserType() -> String? {
        return nil
    }
    
    mutating func setMessage(message: String) {
        self.message = message
    }
    
    private enum CodingKeys: String, CodingKey {
         case messageId, userId, userType, message, messageChanged, userPid , userName, userProfileImgUrl
     }
    
    var message: String
    var messageId: String
    var userId: Int
    var userType: String
    var messageChanged: Bool
    
    var userPid: String
    var userName: String = ""
    var userProfileImgUrl: String
    
    
    var finalMessage: String {
        get {
            return message
        }
        set {
            message = newValue
        }
    }
    
    var index:Int?
    
    func getMessageId() -> String? {
        return messageId
    }
    
    func getIndex() -> Int? {
        if index == nil {
            return -99
        } else {
            return self.index
        }
    }
    
    func getActivityName() -> String? {
        return userName
    }
    
    func getProfileImgUrl() -> String? {
        return userProfileImgUrl
    }
    
    func getUserId() -> Int? {
        return self.userId
    }
    
    func getUserType() -> String? {
        return userType
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
