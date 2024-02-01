//
//  Errors.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/01/24.
//

import SwiftUI

enum GitHubError: Error{
    //通信失敗
    case connectionError(Error)
    
    //レスポンスの解釈に失敗
    case responseParseError(Error)
    
    //APIから受け取ったエラー
    case apiError(GitHubAPIError)
}

enum GitHubClientError: Error{
    //通信失敗
    case connectionError(Error)
    
    //レスポンス解釈に失敗
    case responseParseError(Error)
    
    //APIから受け取ったエラー
    case apiError(GitHubAPIError)
}

struct GitHubAPIError:Decodable, Error{
    struct Error: Decodable{
        var resource: String
        var field: String
        var code: String
    }
    
    var message: String
    var errors: [Error]
}
