//
//  QueueScheduler.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/09/10.
//

import Dispatch

struct MainQueueScheduler {
    var schedule:  (@escaping () -> Void) -> Void
}

extension MainQueueScheduler {
    static let live = Self(
        schedule: { action in
            DispatchQueue.main.async {
                action()
            }
        }
    )
}

extension MainQueueScheduler {
    static let immediate = Self(
        schedule: { action in
            action()
        }
    )
}

