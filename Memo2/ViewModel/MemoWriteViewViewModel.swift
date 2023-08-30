//
//  MemoWriteViewViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import Foundation

class MemoWriteViewViewModel{
    
    private let instance = LocalDBManager.instance
    var createAction : (() ->Void)?
    var updateAction : (() ->Void)?
    var confirmAction : ((UISheetPaperType, Bool) -> Void)?
    
    func onUpdateText(category: String, originText: String, changeText: String){
        if originText.isEmpty || changeText.isEmpty{
            confirmAction?(UISheetPaperType.update,false)
            return
        }
        instance.updateData(category: category, originText: originText, changeText: changeText)
        confirmAction?(UISheetPaperType.update,true)
    }
    
    func onCreateData(category: String, item: SectionItem)
    {
        if item.memoText.isEmpty || item.memoText == ""{
            confirmAction?(UISheetPaperType.create, false)
            return
        }
        instance.createData(category: category, item: item)
        confirmAction?(UISheetPaperType.create, true)
    }
}
