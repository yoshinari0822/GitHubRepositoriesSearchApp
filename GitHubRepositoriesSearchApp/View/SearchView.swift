//
//  HomeView.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/02/01.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var systemData = SystemData()
    
    //0=スタンバイ中
    //1=検索中
    //2=検索完了
    //3=検索失敗
    @State var state = 0
    
    
    @State var searchWord: String = ""
    @State var getRepositories:SearchResponse<Repository>? = nil
    
    func searching(){
        
        //APIクライアントの生成
        let client = GitHubClient(httpClient: URLSession.shared)
        //リクエストの発行
        let request = GitHubAPI.SearchRepositories(keyword: searchWord)
        
        //リクエストの送信
        client.send(request: request){result in
            switch result{
            case .success(let response):
                getRepositories = response
                state = 2
                
                
            case .failure(let error):
                print("failure")
                state = 3
                print(error)
            }
        }
        
    }
    
    
    var body: some View {
        VStack{
            HStack{
                TextField("検索ワードを入力", text: $searchWord, onCommit: {
                    //空白じゃなかったら検索かける
                    if searchWord != ""{
                        state = 1
                        searching()
                    }
                })
                .textFieldStyle(.roundedBorder)
                .disabled(state != 1 ? false : true)
                
                if state == 2{
                    Button(action:{
                        searchWord = ""
                        state = 0
                    }){
                        Text("戻る")
                    }
                }
            }.padding(.horizontal)
            
            VStack{
                switch state {
                case 0:
                    Spacer()
                    VStack{
                        Image("search")
                            .resizable()
                            .scaledToFit()
                            .frame(width:systemData.widthOfPhone/2)
                            .padding(10)
                        Text("レポジトリを検索できます")
                            .font(.callout)
                    }
                    Spacer()
                    
                case 1:
                    Spacer()
                    ProgressView("検索中")
                    Spacer()
                    
                case 2:
                    ScrollView{
                        //getRepositoriesがnilでないことを確認
                        if let repositories = getRepositories {
                            ResultRow(repositories: repositories.items)
                        }
                    }
                    
                case 3:
                    Spacer()
                    VStack{
                        Image("notFound")
                            .resizable()
                            .scaledToFit()
                            .frame(width:systemData.widthOfPhone/2)
                            .padding(10)
                        Text("エラーが発生しました")
                            .font(.callout)
                        Button(action:{
                            state = 0
                        }){
                            Text("やり直す")
                                .font(.callout)
                        }
                    }
                    Spacer()
                    
                default:
                    Spacer()
                    VStack{
                        Text("不明なエラー")
                            .font(.callout)
                        Text("作成者にお問い合わせください。")
                            .font(.callout)
                        Button(action:{
                            state = 0
                        }){
                            Text("やり直す")
                                .font(.callout)
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    SearchView()
}
