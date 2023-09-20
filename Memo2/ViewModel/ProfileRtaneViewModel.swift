//
//  ProfileRtaneViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//
protocol ProfileRtaneViewModelProtocol{
    func setName(name : String)
    func setAge(age : Int)
}
class ProfileRtaneViewModel : ProfileRtaneViewModelProtocol
{
    var age : Observable<Int> = Observable<Int>(0)
    var name : Observable<String> = Observable<String>("문자열 입력")
    func setName(name : String){
        self.name.value = name
    }
    func setAge(age : Int){
        self.age.value = age
    }   
}
