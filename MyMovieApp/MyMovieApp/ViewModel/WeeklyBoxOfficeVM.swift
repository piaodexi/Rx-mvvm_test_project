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
    // Input
    let selectDateInput = PublishSubject<Date>()
    let targetDateInput = PublishSubject<String>()
    let weekGbInput = PublishSubject<String>()

    // Output
    let titleOutput = BehaviorSubject<String>(value: "")
    let listOutput = BehaviorSubject<[WeeklyBoxOfficeList]>(value: [])

    init() {
        /**
         DateFormatter 객체를 생성, 속성을 "yyyy-MM-dd"로 셋팅
         캘린더컨트롤뷰에서 선택된 날짜를 방출하는 selectDateInput 옵저버블을 구독
         map 연산자를 사용하여 선택된 날짜를 문자열로 변환
         변환된 문자열을 titleOutput 옵저버블에 바인딩
         */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectDateInput
            .map { dateFormatter.string(from: $0) }
            .bind(to: titleOutput)
            .disposed(by: disposeBag)

       /**
        combineLatest를 사용하여 argetDateInput과 weekGbInput 두 개의 Observable을 합쳐서 새로운 이벤트를 방출하는 Observable을 만들어줌
        flatMapLatest 연산자를 사용하여 loadBoxOffice 메소드가 반환하는 Observable을 구독하고 새로운 이벤트를 방출할 때마다 이전에 구독한 내부 Observable을 버리고새로운 내부 Observable을 구독
        bind(to:) 연산자를 이용하여 최종적으로 listOutput에 값을 바인딩
        마지막으로 disposed으로 메모리 해제함.
        */
        Observable.combineLatest(targetDateInput, weekGbInput)
            .flatMapLatest { (targetDt, weekGb) in
                APIService.loadBoxOffice(targetDt: targetDt, weekGb: weekGb)
            }
            .bind(to: listOutput)
            .disposed(by: disposeBag)
    }
    
    //입력된날짜가 7일전인지 아닌지 판별
    func checkDate(inputDate: Date) -> Bool {
        return inputDate >= Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date() ? true : false
    }
}
