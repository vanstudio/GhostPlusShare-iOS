//
//  GhostPlusShare.h
//  GhostPlusShare
//
//  Created by VANSTUDIO
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// GhostPlus
#import <GhostPlus/GhostPlus.h>

// Constant
#define GhostPlusShare_BUNDLE	[GhostPlusShare bundle]

// Module
//#import <GhostPlusShare/GPSSharer.h>
//#import <GhostPlusShare/GPSItem.h>

/**
 GhostPlusShare 메인클래스
 */
@interface GhostPlusShare : NSObject

/**
 GhostPlusShare 번들
 */
+ (NSBundle *)bundle;

/** 
 GhostPlusMedia 번들로부터 이미지 불러오기
 @param filename 파일이름
 */
+ (UIImage *)imageWithFilename:(NSString *)filename;

@end
