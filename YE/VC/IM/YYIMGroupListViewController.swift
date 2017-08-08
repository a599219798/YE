//
//  YYIMGroupViewController.swift
//  YueYe
//
//  Created by 侯佳男 on 2017/7/12.
//  Copyright © 2017年 侯佳男. All rights reserved.
//

import UIKit
import EaseUILite

class YYIMGroupListViewController: YYBaseTableViewController {

    weak var delegate: YYPushDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.ga_addRefreshHeaderXIB(headerView: GA_AnimationRefreshHeaderView.loadView()) {
            [weak self] in
            if let weakSelf = self {
                weakSelf.hx_groupList()
            }
        }
        self.tableView.ga_XIBbeginRefreshing()
    }
    
    func initNavigationView() {
        self.myTitle = "群组"
    }
    
    override func initTableView() {
        super.initTableView()
        isShowTabbar = true
        tableViewFrameType = .normal0
        registerNibWithIdentifier(YYIMGroupCell.identifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hx_groupList() {
        DispatchQueue.global().async {
            self.dataSource = HXManager.share.getJoindGroups() ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.ga_XIBendRefreshing()
            }
        }
    }

    func hx_groupDetails() {EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: (self.dataSource[0] as! EMGroup).groupId) { (group, error) in
            print(group?.groupId ?? "", group?.subject ?? "", group?.description ?? "")
        }
    }
}

extension YYIMGroupListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YYIMGroupCell = tableView.dequeueReusableCell(withIdentifier: YYIMGroupCell.identifier) as! YYIMGroupCell
        cell.titleLabel.text = String(describing: self.dataSource[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushAction(model: self.dataSource[indexPath.row], type: .group)
    }
}