//
//  BoxOfficeListViewModel.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/23.
//
import RxSwift

class WeeklyBoxOfficeListVM {
    //Disposable 객체들을 담을 DisposeBag 객체를 생성
    let disposeBag = DisposeBag()
    //새로운 구독자가 등록되면 발행된 이후의 값을 발행하는 PublishSubject를 사용하여 WeeklyBoxOfficeList[] 타입의 객체를 옵져버블인 list을 생성
    let list = PublishSubject<[WeeklyBoxOfficeList]>()
    //갤런디버큐컨트롤러에서 쓸 옵져버블 item 객체 생성
    //PublishSubject가 아닌 BehaviorSubject를 사용하여 처리
    //let item = PublishSubject<Calender>()//DateFormatter().string(from: Date())
    let item = BehaviorSubject<Calender>(value: Calender(selectDate: ""))
   //오늘날짜로 초기값을 잡아줌.
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        item.onNext(Calender(selectDate: dateString))
    }
    
    
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
    /**
     
     */
//-------------input output 패턴 ---------------------
//    // Input
//    let selectDateInput = PublishSubject<Date>()
//    let targetDateInput = PublishSubject<String>()
//    let weekGbInput = PublishSubject<String>()
//
//    // Output
//    let titleOutput = BehaviorSubject<String>(value: "")
//    let listOutput = BehaviorSubject<[WeeklyBoxOfficeList]>(value: [])
//
//    init() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        selectDateInput
//            .map { dateFormatter.string(from: $0) }
//            .bind(to: titleOutput)
//            .disposed(by: disposeBag)
//

    //   //combineLatest() 메소드는 두 Observable에서 최신 값을 가져와서 튜플로 반환
//        Observable.combineLatest(targetDateInput, weekGbInput)
        //APIService.loadBoxOffice() 메소드가 반환하는 새로운 Observable로 전환,flatMapLatest()는 새로운 Observable을 반환하므로 새로운 값을 방출하면 기존의 Observable을 취소하고 새로운 Observable에 대한 구독을 시작
//            .flatMapLatest { (targetDt, weekGb) in
//                APIService.loadBoxOffice(targetDt: targetDt, weekGb: weekGb)
//            }
//            .observe(on: MainScheduler.instance)
    //          // listOutput Observable과 UITableView에 데이터를 바인딩
    //            .bind(to: listOutput)
//            .disposed(by: disposeBag)
//    }
}
