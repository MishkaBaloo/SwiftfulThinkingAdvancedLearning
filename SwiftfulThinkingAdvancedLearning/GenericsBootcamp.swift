//
//  GenericsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/1/24.
//

import SwiftUI

struct StringModel {
    
    let info: String?
    
    func removeInfo() -> StringModel {
        StringModel(info: nil)
    }
    
}

struct BoolModel {
    
    let info: Bool?
    
    func removeInfo() -> BoolModel {
        BoolModel(info: nil)
    }
    
}

struct GenericModel<T> { // CustomType - T is any type
    
    let info: T? // CustomType
    
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }

}

class GenericsViewModel: ObservableObject {
    
    @Published var stringModel = StringModel(info: "Hello, world!")
    @Published var boolModel = BoolModel(info: true)
    
    @Published var genericStringModel = GenericModel(info: "Hello, world!")
    @Published var genericBoolModel = GenericModel(info: true)
    
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
    
//    @Published var dataArray: [String] = [] // array accept generics type
//    
//    init() {
//        dataArray = ["one", "two", "three"]
//    }
//    
//    func removeDataFromDataArray() { // we can use this to any type of array
//        dataArray.removeAll()
//    }
    
}

struct GenericView<T:View> : View { // This T can only be a view
    
    let content: T
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsBootcamp: View {
    
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            GenericView(content: Text("Custom view content"), title: "New view!")
           // GenericView(title: "New view!")
            
//            ForEach(vm.dataArray, id: \.self) { item in
//                Text(item)
//                    .onTapGesture {
//                        vm.removeDataFromDataArray()
//                    }
//            }
            
            Text(vm.stringModel.info ?? "no data")
            Text(vm.boolModel.info?.description ?? "no data")
            Text(vm.genericStringModel.info ?? "no data")
            Text(vm.genericBoolModel.info?.description ?? "no data")
            
        }
        .onTapGesture {
            vm.removeData()
        }
    }
}

#Preview {
    GenericsBootcamp()
}
