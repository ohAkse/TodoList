//
//  MemoCompleteViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import UIKit
class MemoCompleteViewModel {
    let instance = LocalDBManager.instance
    var filterData: [SectionItem] = []
    var menuItems: [UIMenuElement] = []
    
    var ascendingDataAction: (() -> Void)?
    var descendingDataAction: (() -> Void)?
    var categoryDataAction : (() -> Void)?
    func onAscendingButtonTapped(){
        self.ascendingDataAction?()
    }
    func onDescendingButtonTapped(){
        self.descendingDataAction?()
    }
    
    func filterAndReloadData(for category: CategoryType) {
        filterData = instance.readCompleteData(category: category).filter { $0.isSwitchOn == true }
    }
    init(){
        filterData = instance.readCompleteData(category: .workout).filter{$0.isSwitchOn == true} //초기데이터 설정
        setupCategoryMenu()
    }
    
    func setupCategoryMenu(){
        let workoutItem = UIAction(title: CategoryType.workout.typeValue, image: UIImage(systemName: "figure.walk")) { [weak self] _ in
            guard let self = self else {
                return
            }
            filterAndReloadData(for: .workout)
            categoryDataAction?()
        }
        let studyItem = UIAction(title: CategoryType.study.typeValue, image: UIImage(systemName: "sum")) { [weak self] _ in
            guard let self = self else {
                return
            }
            filterAndReloadData(for: .study)
            categoryDataAction?()
        }
        let meetingItem = UIAction(title: CategoryType.meeting.typeValue, image: UIImage(systemName: "person.3.sequence.fill")) { [weak self] _ in
            guard let self = self else {
                return
            }
            filterAndReloadData(for: .meeting)
            categoryDataAction?()
        }
        self.menuItems = [workoutItem,studyItem,meetingItem]
    }
}
