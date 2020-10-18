//
//  AddingQuotes.swift
//  Quotes
//
//  Created by Aarish  Brohi on 10/16/20.
//

import SwiftUI

struct AddingQuotes: View {
    //to dismiss from view
    @Environment(\.presentationMode) var presentationMode
    
    //types except for 'all' to categorize in picker
    let types = ["Strong", "Wise", "Hope", "Philosophy", "Inspire"]
    @State private var selectedType = 0
    @State private var name: String = ""
    @State private var quote: String = ""
    @State private var showAlert = false;
    
    //upload to database
    func uploadToDB(updatedQuote : Quotes) -> Void {
        let params = ["name":"\(updatedQuote.name)", "type":"\(updatedQuote.type)","quote":"\(updatedQuote.quote)"] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:5000/post_quote")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")){
                    TextField("Author", text: $name)
                    TextField("Quote", text: $quote)
                }
                Section(header: Text("Type")){
                    Picker(selection: $selectedType, label: Text("Please choose a type")) {
                        ForEach(0 ..< types.count) {
                            Text(self.types[$0])
                        }
                    }
                }
                Section {
                    Button(action: {
                        if(name.isEmpty || quote.isEmpty){
                            self.showAlert = true
                        }
                        else{
                            //add to database
                            uploadToDB(updatedQuote: Quotes(name: name, quote: quote, type: types[selectedType]))
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ) {
                        Text("Submit Quote")
                    }
                    .alert(
                        isPresented: $showAlert,
                        content: {Alert(title: Text("Error"), message: Text("Please fill in all information before submitting"), dismissButton: .default(Text("OK")))}
                    )
                }
            }
            .navigationBarTitle("Add Quote")
        }
    }
}

//Users/aarishbrohi/Desktop/Apps/Quotes/Quotes.json
struct AddingQuotes_Previews: PreviewProvider {
    static var previews: some View {
        AddingQuotes()
    }
}
