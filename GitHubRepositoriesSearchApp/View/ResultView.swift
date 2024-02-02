//
//  ResultCell.swift
//  GitHubRepositoriesSearchApp
//
//  Created by 金山義成 on 2024/02/02.
//

import SwiftUI

struct ResultRow: View{
    @ObservedObject var systemData = SystemData()
    var repositories:[Repository]
    
    @State var urlStr = "https://qiita.com/nao_h/items/d3729382fc0f3157efc8"
    @State var showSafariView = false
    
    var body: some View{
        VStack{
            //検索結果が空の時
            if repositories.isEmpty{
                Image("noData")
                    .resizable()
                    .scaledToFit()
                    .frame(width:systemData.widthOfPhone/2)
                    .padding(10)
                
                Text("検索結果がありません")
            }
            
            //検索結果がある時
            else{
                ScrollView{
                    ForEach(repositories, id: \.self){ repository in
                        Button(action:{
                            urlStr = repository.htmlUrl
                            
                            if URL(string: urlStr) != nil {
                                showSafariView = true
                                print(URL(string: urlStr)!)
                            }
                        }){
                            ResultCell(repository: repository)
                        }
                    }
                }
                .foregroundStyle(.black)
                .padding(.horizontal)
            }
        }.sheet(isPresented: $showSafariView){
            SafariView(url: URL(string: urlStr)!)
                .onAppear(){
                    print(urlStr)
                }
        }
    }
}

struct ResultCell: View {
    @ObservedObject var systemData = SystemData()
    
    let mainFontSize:CGFloat = 17.0
    let subFontSize:CGFloat = 13.0
    
    var repository:Repository
    
    var body: some View {
        HStack{
            //画像
            AsyncImage(url: URL(string: repository.owner.avatarUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .overlay(RoundedRectangle(cornerRadius: 5 ).stroke(Color.gray, lineWidth: 1))
                } else if phase.error != nil {
                    Text("エラー")
                        .font(.system(size: subFontSize))
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 50, height:50)
            
            //タイトル・言語・フルタイトル
            VStack(alignment: .leading){
                //タイトル
                Text(repository.name)
                    .font(.system(size: mainFontSize))
                
                HStack(spacing:0){
                    //言語
                    if let language = repository.language{
                        Text("\(language)・")
                    }
                    
                    //フルタイトル
                    Text(repository.fullName)
                }.foregroundStyle(.secondary)
                    .font(.system(size: subFontSize))
            }
            
            Spacer()
            
            HStack(spacing:5){
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(repository.stargazersCount)")
                    .font(.system(size: mainFontSize))
            }
        }
    }
}

#Preview {
    ResultRow(repositories: [Repository(id: 688352, name: "jmeter", fullName: "apache/jmeter", language: Optional("Java"), stargazersCount: 7725, htmlUrl: "https://github.com/apache/jmeter", owner: User(id: 47359, avatarUrl: "https://avatars.githubusercontent.com/u/47359?v=4", login: "apache"))])
}
#Preview {
    ResultRow(repositories: [])
}
