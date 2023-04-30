//
//  BoxOfficeListViewModel.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/23.
//
import RxSwift

class WeeklyBoxOfficeListVM {
    //새로운 구독자가 등록되면 발행된 이후의 값을 발행하는 PublishSubject를 사용하여 WeeklyBoxOfficeList[] 타입의 객체를 옵져버블인 list을 생성
    let list = PublishSubject<[WeeklyBoxOfficeList]>()
    //갤런디버큐컨트롤러에서 쓸 옵져버블 item 객체 생성
    //let item = PublishSubject<Calender>()//DateFormatter().string(from: Date())
    //let item = BehaviorSubject<Calender>(value: Calender.init(selectDate: "hello"))
    let item = BehaviorSubject<Calender>(value: Calender(selectDate: ""))
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        item.onNext(Calender(selectDate: dateString))
    }
    //Disposable 객체들을 담을 DisposeBag 객체를 생성
    let disposeBag = DisposeBag()
    
    //주간 주말리스트 처리
    func dataSetUp(targetDt: String, weekGb: String) {
        //APIService에서 제공하는 loadBoxOffice 메소드를 호출하여, Observable 객체를 생성
        APIService.loadBoxOffice(targetDt: targetDt, weekGb: weekGb)
        //MainScheduler를 사용하여 subscribe 이벤트가 메인 스레드에서 실행되도록 설정
            .observe(on: MainScheduler.instance)
        //subscribe 메소드를 호출하여 옵저버를 등록하고 onNext를 통해 WeeklyBoxOfficeList 배열을 전달하고, BehaviorSubject의 list에 저장. Disposable 객체를 disposeBag에 추가하여 Observable이 해지될 때 메모리 해제 수행
            .subscribe(onNext: {weeklyBoxOfficeList in
                self.list.onNext(weeklyBoxOfficeList)
            }).disposed(by: disposeBag)
    }
    
    //오늘날짜 반환
    func getToday() -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let current_date_string = formatter.string(from: Date())
         return current_date_string
    }
}
