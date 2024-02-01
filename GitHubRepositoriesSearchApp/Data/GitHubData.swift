//
//  Data.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/01/24.
//

import SwiftUI

//ユーザーデータ
struct User: Decodable, Hashable{
    var id: Int
    var login: String
}

//レポジトリーデータ
struct Repository: Decodable, Hashable{
    var id: Int
    var name: String
    var fullName: String
    //ownerはユーザーデータ
    var owner: User
    
    //fullNameはJSONのキーと一致しないためfull_nameとする
    public enum CodingKeys: String, CodingKey{
        case id
        case name
        case fullName = "full_name"
        case owner
    }
}

//サーチレスポンスデータ
struct SearchResponse<Item: Decodable>: Decodable{
    var totalCount: Int
    var items: [Item]
    
    //totalCountはJSONのキーと一致しないためfull_nameとする
    enum CodingKeys: String, CodingKey{
        case totalCount = "total_count"
        case items
    }
}


