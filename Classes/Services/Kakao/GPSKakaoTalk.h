//
//  GPSKakaoTalk.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>


typedef NS_ENUM(NSInteger, GPSKakaoTalkButtonType) {
	GPSKakaoTalkButtonTypeNone,
	GPSKakaoTalkButtonTypeWebLink,
	GPSKakaoTalkButtonTypeWebButton,
	GPSKakaoTalkButtonTypeWebLinkWithAppButton,
	GPSKakaoTalkButtonTypeAppButton
};


@interface GPSKakaoTalk : GPSSharer

+ (void)setWebLinkTitle:(NSString *)title;
+ (void)setWebButtonTitle:(NSString *)title;
+ (void)setAppButtonTitle:(NSString *)title;

+ (id)shareWithText:(NSString *)text imageURL:(NSURL *)imageURL linkURL:(NSURL *)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam;

@end


@interface GPSKakaoTalkItem : GPSItem
/** 버튼 타입 */
@property (nonatomic) GPSKakaoTalkButtonType buttonType;
/** 카카오톡에서 사용자앱으로 넘어올때 파라미터 */
@property (nonatomic, strong) NSDictionary *execparam;
@end
