//
//  helpers.swift
//  volunteam
//
//  Created by Ryan Wolande on 11/16/15.
//  Copyright © 2015 Ryan Wolande. All rights reserved.
//

import Foundation

func run_on_background_thread(code: () -> Void)
{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
}

func run_on_main_thread(code: () -> Void)
{
        dispatch_async(dispatch_get_main_queue(), code)
}