//
//  MessageProtocol.swift
//  HypyG
//
//  Created by 온석태 on 12/19/23.
//

import Foundation
import SwiftUI


let socketResponseEvent: SocketResponseEvent = .error
let messageType: MessageType = .none

protocol MessageRenderingProtocol {
    //func getMessageView() -> AnyView
    
    func getSocketResponseEvent() -> SocketResponseEvent
    func getMessageType() -> MessageType
    
    func getIndex() -> Int?
    func getMessageStatus() -> MessageStatus
    mutating func setMessageStatus(messageStatus: MessageStatus)
    func getUserId() -> Int?
    func getUserType() -> String?
    func getMessage() -> String?
    mutating func setMessage(message: String)
    func getMessagechanged() -> Bool
    func getIdolManagerMsg() -> String?
    func getProducerMsg() -> String?
    func getCreatorIdolId() -> Int?
    func getTarUserId() -> Int?
    func getTarUserType() -> String?
    func getTarUserMsg() -> String?
    func getRoomId() -> Int?
    func getTarMessageId() -> String?
    func getMessageId() -> String?
    func getDonateValue() -> Int?
    func getCount () -> Int?
    func getCode() -> Int?
    func getStatus() -> String?
    func getData() -> [Any]?
    func getActivityName() -> String?
    func getTarActivityName() -> String?
    func getProfileImgUrl() -> String?
    func getTarProfileImgUrl() -> String?
    func getUserPid() -> String?
}




enum MessageType {
    case normal
    case welcom
    case vote
    case donate
    case pin
    case system
    case none
}

enum SocketRequestEvent: String {
    case userMsg = "userMsg"
    case banUser = "banUser"
    case cancelBanUser = "cancelBanUser"
    case proposalManager = "proposalManager"
    case acceptManager = "acceptManager"
    case rejectManager = "rejectManager"
    case dismissManager = "dismissManager"
    case reportMessage = "reportMessage"
    case pinMessage = "pinMessage"
    case blockMessage = "blockMessage"
    case memberEntranceReaction = "memberEntranceReaction"
    case voteReactionRequest = "voteReactionRequest"
    case voteReaction = "voteReaction"
    case donateReactionRequest = "donateReactionRequest"
    case donateReaction = "donateReaction"
    
    case unPinMessage = "unPinMessage"
    case sendPinMessage = "sendPinMessage"
    case banUserList = "banUserList"
    case managerList = "managerList"
}

enum SocketResponseEvent: String {
    case userMsg = "userMsg"
    case idolManagerNoti = "idolManagerNoti"
    case banLeave = "banLeave"
    case banUserNoti = "banUserNoti"
    case proposalManager = "proposalManager"
    case acceptManager = "acceptManager"
    case rejectManager = "rejectManager"
    case dismissManager = "dismissManager"
    case hideMessage = "hideMessage"
    case pinMessage = "pinMessage"
    case welcome = "welcome"
    case memberEntrance = "memberEntrance"
    case memberEntranceReaction = "memberEntranceReaction"
    case voteReactionRequest = "voteReactionRequest"
    case voteReaction = "voteReaction"
    case donateReactionRequest = "donateReactionRequest"
    case donateReaction = "donateReaction"
    case refreshUserList = "refreshUserList"
    case userCount = "userCount"
    case error = "error"
    
    //24/02/16 추가
    case updateLiveStreamingStatus = "updateLiveStreamingStatus"
    
    
    case unPinMessage = "unPinMessage"
    case sendPinMessage = "sendPinMessage"
    case banUserList = "banUserList"
    case managerList = "managerList"
    
}


enum MessageStatus {
    case waiting
    case success
    case failure
    case deleted
}


enum LiveStreamingRoleType:String {
    case producer = "PRODUCER"
    case manager = "MANAGER"
    case idol = "IDOL"
}
