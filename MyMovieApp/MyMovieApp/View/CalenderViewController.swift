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
        calendarView.allowsMultipleSelection = false //캘린더뷰에서 날짜 다중선택가능여부 
        calendarView.delegate = self
        calendarView.dataSource = self
    }

    //MARK FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if self.weaklyBoxOfficeVM.checkDate(inputDate: date) == true {
            let alert = UIAlertController(title: "알림", message: "해당 날짜는 선택할 수 없습니다.7일전으로만 해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            weaklyBoxOfficeVM.selectDateInput.onNext(date)
            dismiss(animated: true, completion: nil)

        }
    }
}
