//
//  CalenderVM.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/25.
//
import RxSwift

class CalenderVM {
    //새로운 구독자가 등록되면 발행된 이후의 값을 발행하는 PublishSubject를 사용하여 Calender 타입의 객체를 옵져버블인 item을 생성
    let item = PublishSubject<Calender>()
}

