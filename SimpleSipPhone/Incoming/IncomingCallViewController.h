//
//  IncomingCallViewController.h
//  SimpleSipPhone
//
//  Created by zhanghan on 2018/2/27.
//  Copyright © 2018年 zhanghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomingCallViewController : UIViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) NSInteger callId;
@end
