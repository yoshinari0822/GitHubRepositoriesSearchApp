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
    var avatarUrl: String
    var login: String
    
    //JSONのキーと一致しないものを合わせる
    public enum CodingKeys: String, CodingKey{
        case id
        case avatarUrl = "avatar_url"
        case login
    }
}

//レポジトリーデータ
struct Repository: Decodable, Hashable{
    var id: Int
    var name: String
    var fullName: String
    var language: String?
    var stargazersCount: Int
    var htmlUrl: String
    //ownerはユーザーデータ
    var owner: User
    
    //JSONのキーと一致しないものを合わせる
    public enum CodingKeys: String, CodingKey{
        case id
        case name
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
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


