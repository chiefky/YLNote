//
//  YLQuestionDataManager.swift
//  YLNote
//
//  Created by tangh on 2021/3/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import YYModel

@objc protocol YLQuestionDataProtocol {
    
    // MARK: 必须实现
    var jsonFile: String { get }
    var headerIdentifier: String { get }
    var cellIdentifier: String { get }
    
    //
    //    // MARK: 可选实现
     @objc optional func doFunction(with name: String, paramete: Any)
    //    @objc optional func actionHandler()
}

class YLQuestionDataManager: NSObject {
    
    @objc weak var dataSource: YLQuestionDataProtocol? {
        didSet {
            if let tmp = dataSource {
                allDatas = makeupDatas(tmp)
            }
        }
    }
    
    //   @objc var allDatas: [YLNoteSectionData] {
    //        guard let source = self.dataSource else { return [] }
    //        return makeupDatas(source)
    //    }
    
    @objc var allDatas = [YLNoteSectionData]()
    
    
    func makeupDatas(_ source: YLQuestionDataProtocol) -> [YLNoteSectionData] {
        let json = YLFileManager.jsonParse(withLocalFileName: source.jsonFile)
        let array = NSArray.yy_modelArray(with: YLNoteSectionData.self, json: json) as? [YLNoteSectionData]
        return array ?? []
    }
    
    
}

extension YLQuestionDataManager: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.allDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let datasource = self.dataSource,let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: datasource.headerIdentifier) as? YLGroupHeaderView else { return UIView() }
        
        let sectionData = self.allDatas[section]
        header.title = sectionData.group.name
        header.unfoldStatus = sectionData.unfoldStatus
        header.actionHandler = {
            sectionData.unfoldStatus = !sectionData.unfoldStatus
            //刷新当前的分组
            let set = IndexSet(integer: section)
            tableView.reloadSections(set, with: .none)
            
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = self.allDatas[section]
        return sectionData.unfoldStatus ? sectionData.group.questions.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.dataSource,let cell = tableView.dequeueReusableCell(withIdentifier: datasource.cellIdentifier, for: indexPath) as? YLQuestionTableViewCell else { return UITableViewCell() }
        let sectionData = self.allDatas[indexPath.section]
        let group = sectionData.group
        if let question = group.questions[safe: indexPath.row] {
            let title = question.title
            cell.titleLabel.text = "\(indexPath.row + 1). " + title
            cell.articleHandler = {
                UIWindow.pushToArticle(question.article.fileName)
            }
        }        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = self.allDatas[indexPath.section]
        guard let question = sectionData.group.questions[safe: indexPath.row] else { return }
        if question.hasDemo {
            UIWindow.pushToDemo(with: question)
        } else {           
            if let delegate = self.dataSource {
                delegate.doFunction?(with: question.function, paramete: indexPath.row)
            }
        }
        
        return
    }
    
    
//    func doFunction(with question: YLQuestion, index: Int) {
//        let functionName = "test_" + question.function
//        if let delegate = self.dataSource as? NSObject {
//            let function = Selector(functionName)
//
//            if delegate.responds(to: function) {
//                if functionName.contains(":") {
//                    delegate.perform(function, with: index)
//                } else {
//                    delegate.perform(function)
//                }
//            }
//        }
//
//    }
}
