//
//  GPSKakaoTalk.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>


typedef NS_ENUM(NSInteger, GPSKakaoTalkButtonType) {
	GPSKakaoTalkButtonTypeNone,
	GPSKakaoTalkButtonTypeWebButton,
	GPSKakaoTalkButtonTypeAppButton,
	GPSKakaoTalkButtonTypeWebButtonAndAppButton
};


@interface GPSKakaoTalk : GPSSharer

+ (void)setWebButtonTitle:(NSString *)title;
+ (void)setAppButtonTitle:(NSString *)title;

+ (id)shareWithText:(NSString * _Nonnull)text imageURL:(NSURL * _Nonnull)imageURL linkURL:(NSURL * _Nonnull)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam;
+ (id)shareWithTitle:(NSString * _Nonnull)title desc:(NSString *)desc imageURL:(NSURL * _Nonnull)imageURL linkURL:(NSURL * _Nonnull)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam;

@end


@interface GPSKakaoTalkItem : GPSItem
/** 버튼 타입 */
@property (nonatomic) GPSKakaoTalkButtonType buttonType;
/** 카카오톡에서 사용자앱으로 넘어올때 파라미터 */
@property (nonatomic, strong) NSDictionary *execparam;
@end
