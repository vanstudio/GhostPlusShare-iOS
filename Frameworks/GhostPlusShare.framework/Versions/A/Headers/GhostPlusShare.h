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
#import <GhostPlusShare/GPSSharer.h>
#import <GhostPlusShare/GPSItem.h>
#import <GhostPlusShare/GPSMail.h>
#import <GhostPlusShare/GPSMessage.h>

// Constans
#define GHOSTPLUSSHARE_VERSION           @"1.09";
#define GHOSTPLUSSHARE_BUILD_VERSION     @"109";

/**
 GhostPlusShare 메인클래스
 */
@interface GhostPlusShare : NSObject

/**
 준비 확인
 */
+ (void)checkPrepare;

/**
 GhostPlusShare 번들
 */
+ (NSBundle *)bundle;

/** 
 GhostPlusMedia 번들로부터 이미지 불러오기
 @param filename 파일이름
 */
+ (UIImage *)imageWithFilename:(NSString *)filename;

/**
 Sharer 레퍼런스 유지
 @pararm sharer
 */
+ (void)keepSharerReference:(GPSSharer *)sharer;

/**
 Sharer 레퍼런스 제거
 @pararm sharer
 */
+ (void)removeSharerReference:(GPSSharer *)sharer;
@end
