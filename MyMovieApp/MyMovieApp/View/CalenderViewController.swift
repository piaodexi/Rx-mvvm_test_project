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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        //뷰가 닫힐때 선택된 날짜를 뷰모델로 넘겨줌
        dismiss(animated: true) { [weak self] in
            self?.weaklyBoxOfficeVM.item
                .onNext(Calender(selectDate: dateFormatter.string(from: date)))
        }
    }
}
