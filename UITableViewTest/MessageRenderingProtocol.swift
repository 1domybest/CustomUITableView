//
//  MessageProtocol.swift
//  HypyG
//
//  Created by 온석태 on 12/19/23.
//

import Foundation
import SwiftUI

protocol MessageRenderingProtocol {
    func getIndex() -> Int?
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
