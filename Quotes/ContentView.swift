//
//  ContentView.swift
//  Quotes
//
//  Created by Aarish  Brohi on 10/15/20.
//

import SwiftUI
import UIKit

struct Quotes: Codable, Hashable{
    var name: String
    var quote: String
    var type: String

}

//get random quote for quote of the day
func getQOTD()->String{
    let quotes = getDataBaseQuotes {}
    let number = Int.random(in: 0..<quotes.count)
    return quotes[number].quote
}

//call api to get [Quotes] from database
//use Dispatch group to wait for async call
func getDataBaseQuotes(completion: @escaping () -> ()) -> [Quotes] {
    let group = DispatchGroup()
    group.enter()
    var products = [Quotes]()
    if let url = URL(string: "http://127.0.0.1:5000/get_quotes") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    //decorder used to parse objects
                    products = try JSONDecoder().decode([Quotes].self, from: data)
                    group.leave()
                } catch let error {
                    print(error)
                }
            }
            completion()
        }.resume()
    }
    //wait till group leaves to finish function
    group.wait()
    return products
}


struct ContentView: View {
    
    @State private var isSharePresented: Bool = false
    @State private var preference : String = "All"
    @State var index : Int = 0
    @State var showingDetail = false

    
    let types = ["All", "Strong", "Wise", "Hope", "Philosophy", "Inspire"]
    let quoteDay = getQOTD()


    var body: some View {
        let allQuotes = getDataBaseQuotes(){}
        VStack(alignment: .leading) {
            Text("Motivational Quotes")
                .fontWeight(.bold)
                .foregroundColor(.black)
                .font(.title)
                .padding(.bottom, 2.5)
            VStack{
                HStack{
                    Text("Quote of the Day")
                        .italic()
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action:{
                        self.showingDetail.toggle()
                    }){
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showingDetail){
                        AddingQuotes()
                    }
                    
                    Button(action: {
                        self.isSharePresented = true
                    })
                    {
                        Image(systemName: "square.and.arrow.up")
                    }.sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss Activity View")
                    }, content: {
                        ActivityViewController(activityItems: [quoteDay])
                        
                    })
                    
                }.padding(.bottom, 2.5)
                
                Text(quoteDay)
                    .bold()
                    .frame(width: UIScreen.main.bounds.size.width * 9 / 10 , height: 125.0, alignment: .center)
                    .cornerRadius(50)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.lightBlue, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(types, id: \.self){ item in
                        Button(item, action: {
                            preference = item
                        }).buttonStyle(PlainButtonStyle())
                        .frame(width: 90, height: 70, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10.0)
                        .padding(2.5)
                        .shadow(color: .blue, radius: 3)
                    }
                }
            }.padding(.bottom, 2.5)
            
            List{
                ForEach(allQuotes, id: \.self) { item in

                    if(preference == "All"){
                        HStack{
                            Image("fixedImage\(Int.random(in: 0..<6))")
                                .resizable()
                                .frame(width: 75, height: 75, alignment: .center)
                                .background(Color(.gray))
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("\"\(item.quote)\"")
                                    .fontWeight(.semibold)
                                Text("- \(item.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                            Spacer()
                            
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2)
                                .shadow(radius: 5)
                        )
                    }
                    
                    if(item.type == preference){
                        HStack{
                            Image("fixedImage\(Int.random(in: 0..<6))")
                                .resizable()
                                .frame(width: 75, height: 75, alignment: .center)
                                .background(Color(.gray))
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("\"\(item.quote)\"")
                                    .fontWeight(.semibold)
                                Text("- \(item.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                            Spacer()
                            
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2)
                                .shadow(radius: 5)
                        )
                    }
                }
            }
            
            Spacer()
            
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//struct to use UIkit for ActivtyViewController
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

extension Color {
    public static var lightBlue: Color {
        return Color(red: 52/255, green: 190/255, blue: 255/255)
    }
}
