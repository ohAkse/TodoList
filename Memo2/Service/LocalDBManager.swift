//
//  LocalDBManager.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
final class LocalDBManager{
    static let instance = LocalDBManager()
    //아이템 생성할때
    func createData(category: String, item: SectionItem) {
        var categories = getCategoriesFromUserDefaults()
        if let index = categories.firstIndex(where: { $0.name == category }) {
            categories[index].items.append(item)
            saveCategoriesToUserDefaults(categories)
        } else {
            print("Category not found: \(category)")
        }
    }
    //내부적에서 카테고리 얻을때
    func getCategoriesFromUserDefaults() -> [Category] {
        do {
            if let data = UserDefaults.standard.data(forKey: "categories") {
                let categories = try JSONDecoder().decode([Category].self, from: data)
                return categories
            } else {
                return []
            }
        } catch {
            print("Error decoding categories from UserDefaults: \(error)")
            return []
        }
    }
    //변경사항 있을 때 저장
    func saveCategoriesToUserDefaults(_ categories: [Category]) {
        do {
            let data = try JSONEncoder().encode(categories)
            UserDefaults.standard.setValue(data, forKey: "categories")
            
        } catch {
            print("Error encoding categories: \(error)")
        }
    }
    //초기 카테고리 얻기
    func initializeCategoriesIfNeeded() {
        if UserDefaults.standard.object(forKey: "categories") == nil {
            let initialData: [Category] = [
                Category(name: "운동", items: [
                ]),
                Category(name: "공부", items: [
                ]),
                Category(name: "모임", items: [
                ])
            ]
            saveCategoriesToUserDefaults(initialData)
        }
    }
   //텍스트 변경시
    func updateData(category: String, originText: String, changeText: String) {
        var updatedCategories = getCategoriesFromUserDefaults()
        if let categoryIndex = updatedCategories.firstIndex(where: { $0.name == category }) {
            updatedCategories[categoryIndex].items = updatedCategories[categoryIndex].items.map { item in
                var updatedItem = item
                if item.memoText == originText {
                    updatedItem.memoText = changeText
                }
                return updatedItem
            }
            saveCategoriesToUserDefaults(updatedCategories)
        }
    }
    //스위치 눌렀을때
    func updateData(category: String, cellIndex: Int, content: String, isSwitchOn: Bool) {
        var updatedCategories = getCategoriesFromUserDefaults()
        if let categoryIndex = updatedCategories.firstIndex(where: { $0.name == category }) {
            if cellIndex < updatedCategories[categoryIndex].items.count {
                updatedCategories[categoryIndex].items[cellIndex].memoText = content
                updatedCategories[categoryIndex].items[cellIndex].isSwitchOn = isSwitchOn
                saveCategoriesToUserDefaults(updatedCategories)
            }
        }
    }
    //테이블뷰 셀 옆으로 슬라이딩을 끝까지 하거나 혹은 삭제버튼 눌렀을때
    func deleteData(category: String, content: String) {
        var updatedCategories = getCategoriesFromUserDefaults()
        if let categoryIndex = updatedCategories.firstIndex(where: { $0.name == category }) {
            updatedCategories[categoryIndex].items.removeAll { $0.memoText == content }
            saveCategoriesToUserDefaults(updatedCategories)
        }
    }
    //완료 리스트에 카테고리별 읽기
    func readCompleteData(category: CategoryType) -> [SectionItem] {
        let categories = getCategoriesFromUserDefaults()
        if let matchingCategory = categories.first(where: { $0.name == category.typeValue }) {
            return matchingCategory.items
        } else {
            return []
        }
    }
}
