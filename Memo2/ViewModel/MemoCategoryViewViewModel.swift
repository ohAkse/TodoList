//
//  MemoCategoryViewViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import Foundation

class MemoCategoryViewModel{
    var workoutButtonAction: (() -> Void)?
    var studyButtonAction: (() -> Void)?
    var meetingButtonAction : (() -> Void)?
 
    func onBindWorkoutButton(){
        self.workoutButtonAction?()
    }
    func onBindStudyButton(){
        self.studyButtonAction?()
    }
    func onBindMeetingDataAction(){
        self.meetingButtonAction?()
    }
}
