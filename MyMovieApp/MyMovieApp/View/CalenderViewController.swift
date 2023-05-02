//
//  CalenderViewController.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/23.
//
import FSCalendar
import RxSwift

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet private weak var calendarView: FSCalendar!
    var weaklyBoxOfficeVM = WeeklyBoxOfficeListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.allowsMultipleSelection = true
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    //캘린더에서 날짜 선택시 처리함수
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         //뷰가 닫힐때 선택된 날짜를 뷰모델로 넘겨줌
         //단 7일전인지 아닌지 체크필요
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          guard let selectedDate = dateFormatter.date(from: dateFormatter.string(from: date)) else {
              return
          }
          let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
          if selectedDate >= sevenDaysAgo {
              let alert = UIAlertController(title: "알림", message: "해당 날짜는 선택할 수 없습니다.7일전으로만 해주세요", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
              alert.addAction(okAction)
              self.present(alert, animated: true, completion: nil)
          } else {
              dismiss(animated: true) { [weak self] in
                  self?.weaklyBoxOfficeVM.item
                      .onNext(Calender(selectDate: dateFormatter.string(from: date)))
              }
          }
    }
//-------------input output 패턴 ---------------------
//    //캘린더에서 날짜 선택시 처리함수
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        weaklyBoxOfficeVM.selectDateInput.onNext(date)
//        dismiss(animated: true, completion: nil)
//    }
}
