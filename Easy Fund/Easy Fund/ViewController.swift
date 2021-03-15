//
//  ViewController.swift
//  Easy Fund
//
//  Created by Mimosa on 2021/3/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchFundHistory()
    }
    
    func fetchFundHistory() {
        let startDate = "&sdate=2020-09-01"
        let endDate = "&edate=2020-09-18"
        let fundCode = "110011"
        let page = 1
        let per = 40
        let urlStr = "http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code=\(fundCode)&page=\(page)&per=\(per)\(startDate)\(endDate)"
        
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            var dataStr = String(data: data!, encoding: .utf8)!
            dataStr.removeLast()
            dataStr = String(dataStr[dataStr.index(dataStr.startIndex, offsetBy: 199)..<dataStr.endIndex])
            dataStr.insert("{", at: dataStr.startIndex)
            dataStr = dataStr.replacingOccurrences(of: "<td>", with: "\"")
            dataStr = dataStr.replacingOccurrences(of: "</td>", with: "\",")
            dataStr = dataStr.replacingOccurrences(of: "<td class='tor bold'>", with: "\"")
            dataStr = dataStr.replacingOccurrences(of: "<td class='red unbold'>", with: "\"")
            dataStr = dataStr.replacingOccurrences(of: "<td class='tor bold grn'>", with: "\"")
            dataStr = dataStr.replacingOccurrences(of: "<td class='tor bold red'>", with: "\"")
            dataStr = dataStr.replacingOccurrences(of: "</table>\",", with: "")
            dataStr = dataStr.replacingOccurrences(of: "开放赎回,,", with: "开放赎回,")
            dataStr = dataStr.replacingOccurrences(of: "<tr>", with: "[")
            dataStr = dataStr.replacingOccurrences(of: "</tr>", with: "],")
            dataStr = dataStr.replacingOccurrences(of: "<tbody>", with: "\"body\": [")
            dataStr = dataStr.replacingOccurrences(of: "</tbody>", with: "],")
            dataStr = dataStr.replacingOccurrences(of: ",],", with: "],")
            dataStr = dataStr.replacingOccurrences(of: ",],", with: "],")
            dataStr = dataStr.replacingOccurrences(of: "records", with: "\"records\"")
            dataStr = dataStr.replacingOccurrences(of: "pages", with: "\"pages\"")
            dataStr = dataStr.replacingOccurrences(of: "curpage", with: "\"curpage\"")
            dataStr = dataStr.replacingOccurrences(of: "<td colspan='7' align='center'>暂无数据!", with: "\"noData")
            print(dataStr)
        }
        dataTask.resume()
    }
    
    func fetchFundDetails() {
        let timeInterval = Date().timeIntervalSince1970
        let fundCode = "161725"
        let urlStr = "http://fund.eastmoney.com/pingzhongdata/\(fundCode).js?v=\(timeInterval)"
        
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            let dataStr = String(data: data!, encoding: .utf8)!
            print(dataStr)
        }
        dataTask.resume()
    }
    
    func fetchFundList() {
        let urlStr = "http://fund.eastmoney.com/js/fundcode_search.js"
        
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            var dataStr = String(data: data!, encoding: .utf8)!
            let start = dataStr.index(dataStr.startIndex, offsetBy: 9)
            let end = dataStr.index(dataStr.endIndex, offsetBy: -1)
            let range = start..<end
            dataStr = String(dataStr[range])
            let jsonData = Data(dataStr.utf8)
            do {
                if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String]] {
                    array.forEach { (fundInfo) in
                        if fundInfo[0].contains("968061") {
                            print(fundInfo)
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    func fetchUpdate() {
        let timeInterval = Date().timeIntervalSince1970
        let fundCode = "161725"
        let urlStr = "http://fundgz.1234567.com.cn/js/\(fundCode).js?rt=\(timeInterval)"
        
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            var dataStr = String(data: data!, encoding: .utf8)!
            let start = dataStr.index(dataStr.startIndex, offsetBy: 8)
            let end = dataStr.index(dataStr.endIndex, offsetBy: -2)
            let range = start..<end
            dataStr = String(dataStr[range])
            let jsonData = Data(dataStr.utf8)
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    json.forEach { (key, value) in
                        print(key, " => ", value)
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }

}

