//
//  GPSKakaoStory.h
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import <GhostPlusShare/GhostPlusShare.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

#define KEY_STORYLINK_URLINFO_TITLE		@"title"
#define KEY_STORYLINK_URLINFO_DESC		@"desc"
#define KEY_STORYLINK_URLINFO_IMAGEURL	@"imageurl"
#define KEY_STORYLINK_URLINFO_TYPE		@"type"

#define KEY_STORYLINK_URLINFO_TYPE_VIDEO	@"video"
#define KEY_STORYLINK_URLINFO_TYPE_MUSIC	@"music"
#define KEY_STORYLINK_URLINFO_TYPE_BOOK		@"book"
#define KEY_STORYLINK_URLINFO_TYPE_ARTICLE	@"article"
#define KEY_STORYLINK_URLINFO_TYPE_PROFILE	@"profile"
#define KEY_STORYLINK_URLINFO_TYPE_WEBSITE	@"website"

@interface GPSKakaoStory : GPSSharer
+ (id)shareWithText:(NSString *)text linkURL:(NSURL *)linkURL permission:(KOStoryPostPermission)permission execparam:(NSDictionary *)execparam;
+ (id)shareStoryLinkWithText:(NSString *)text linkURL:(NSURL *)linkURL appId:(NSString *)appId appVer:(NSString *)appVer appName:(NSString *)appName urlinfo:(NSDictionary *)urlinfo;
+ (NSDictionary *)createStoryLinkUrlInfoWithTitle:(NSString *)title desc:(NSString *)desc imageurl:(NSString *)imageurl type:(NSString *)type;
@end


@interface GPSKakaoStoryItem : GPSItem
/** 글쓰기 권한 */
@property (nonatomic) KOStoryPostPermission permission;
/** 카카오스토리에서 사용자앱으로 넘어올때 파라미터 */
@property (nonatomic, strong) NSDictionary *execparam;
@end