//
//  GPSSharer.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GhostPlusShare/GPSItem.h>


@protocol GPSSharerDelegate;


@interface GPSSharer : NSObject

/** 공유 아이템 */
@property (nonatomic, strong) GPSItem *item;

/**
 타이틀
 */
+ (NSString *)sharerTitle;

/**
 준비 확인
 */
+ (BOOL)checkPrepare;

/**
 공유
 @param item				아이템
 @param	fromViewController	컨트롤러를 표시 할 뷰컨트롤러
 */
+ (id)shareItem:(GPSItem *)item showFromViewController:(UIViewController *)fromViewController;

@end
