//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 2/14/25.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitFuitModelNames {
    static let name = "name"
}

struct FruitModel: Hashable {
  let name: String
  let record: CKRecord
}

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        saveItem(record: newFruit)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record: \(String(describing: returnedRecord))")
            print("Error: \(String(describing: returnedError))")
            
            DispatchQueue.main.async {
                self?.text = ""
                self?.fetchItems()
            }
        }
    }
    
    func fetchItems() {
        
//        let predicate = NSPredicate(value: true)
        
        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 2 // 100 by default
        
        var returnedItems: [FruitModel] = []
        
        queryOperation.recordMatchedBlock = { (returnedrecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let name = record["name"] as? String else { return }
                returnedItems.append(FruitModel(name: name, record: record))
            case .failure(let error):
                print("Error recordMatchedBlock \(error)")
            }
            
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("RETURNED RESULT: \(returnedResult)")
            DispatchQueue.main.async {
                self?.fruits = returnedItems
            }
        }
        
        addOpertion(operation: queryOperation)
    }
    
    func addOpertion(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateItem(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = "NEW NAME"
        saveItem(record: record)
      }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordId, returnedError in
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)
            }
        }
    }
    
}

struct CloudKitCrudBootcamp: View {
    
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                textField
                buttonField
                
                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                        Text(fruit.name)
                            .onTapGesture {
                                vm.updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: vm.deleteItem)
                    
                    Text("Fetched items with ApplePayed Dev Acc")
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
        .toolbarVisibility(.hidden, for: .automatic)
    }
}


#Preview {
    CloudKitCrudBootcamp()
}

extension CloudKitCrudBootcamp {
    
    
    private var header: some View {
        Text("ClouKit CRUD ☁️🌤️🌨️")
            .font(.headline)
    }
    
    private var textField: some View {
        TextField("Add something string...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .clipShape(.rect(cornerRadius: 10))
    }
    
    private var buttonField: some View  {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .frame(height: 55)
                .font(.headline)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}
