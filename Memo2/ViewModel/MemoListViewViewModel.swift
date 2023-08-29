import Foundation

class MemoListViewViewModel {
    private let instance = LocalDBManager.instance
    var uncompletedItemListCount = 0
    var categories: Observable<[Category]> = Observable([])
    var updateTextAction : ((String)->Void)?
    var switchDataAction: (() -> Void)?
    var createDataAction: (() -> Void)?
    init() {
        InitLocalDBData()
    }
    func setupUncompletedItemListCount() {
        uncompletedItemListCount = categories.value.reduce(0) { count, category in
            let categoryCount = category.items.reduce(0) { itemCount, sectionItem in
                return itemCount + (sectionItem.isSwitchOn == true ? 0 : 1)
            }
            return count + categoryCount
        }
    }
    func InitLocalDBData() {
        instance.initializeCategoriesIfNeeded()
        categories.value = instance.getCategoriesFromUserDefaults()
    }
    func onUpdateButtonTapped(text : String) {
        updateTextAction?(text)
    }
    func onCreateButtonTapped() {
        createDataAction?()
    }
    func onSwitchButtonTapped(category: String, cellIndex: Int, content: String, isSwitchOn: Bool) {
        instance.updateData(category: category, cellIndex: cellIndex, content: content, isSwitchOn: isSwitchOn)
        categories.value = instance.getCategoriesFromUserDefaults()
    }
    func onDeleteButtonTapped(category: Category, sectionItem: SectionItem) {
        instance.deleteData(category: category.name, content: sectionItem.memoText)
        categories.value = instance.getCategoriesFromUserDefaults()
    }
}
