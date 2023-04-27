//
//  APIService.swift
//  MyMovieApp
//
//  Created by deokhee park on 2023/04/23.
//

import Foundation
import RxSwift

class APIService {

    //파라미터로 targetDt, weekGb를 파라미터로 받고 WeeklyBoxOfficeList 배열이 Observable 형태로 반환 받는 함수
    static func loadBoxOffice(targetDt: String, weekGb: String) -> Observable<[WeeklyBoxOfficeList]> {
        
        //Observable.create 메소드를 호출하여 옵저버블 객체를 생성  옵저버블은 observer에게 전달하는데 사용
        return Observable.create { emitter in
            
            let realUrl = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=120a7e7be5ded64ebcc08b5bd3cdae7c" + "&targetDt=" + targetDt + "&weekGb=" + weekGb
            //URLSession 을 이용하여 HTTP 요청을 생성해서 서버로 데이터를 요청하고 응답을 받아옴
            let task = URLSession.shared.dataTask(with: URL(string: realUrl)!) { data, _, error in
                //에러처리
                if let error = error {
                    emitter.onError(error)
                    return
                }
                //데이터가 성공적으로 받아와졌다면, 받아온 JSON 데이터를 WeeklyBoxOfficeList 타입으로 디코딩하여, onNext 이벤트를 호출
                if let data = data,
                   let weeklyBoxOffice = try? JSONDecoder().decode(WeeklyBoxOffice.self, from: data)  {
                    emitter.onNext(weeklyBoxOffice.boxOfficeResult.weeklyBoxOfficeList)
                }
                //만약 JSON 디코딩이 실패하면 onCompleted 이벤트를 호출하여 Observable을 완료
                else {
                    emitter.onCompleted()
                    return
                }
                //옵져버블 완료
                emitter.onCompleted()
            }
            //HTTP 요청 실행
            task.resume()
            //Disposable 객체를 생성하고 반환. Disposable 객체는 Observable을 구독하는 동안 작업을 취소하거나 정리하는데 사용함 해당 Disposable 객체는 Observable을 해지할 때 취소 작업을 수행하기 위한 것ㄴ.
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
