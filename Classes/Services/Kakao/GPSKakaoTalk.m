//
//  GPSKakaoTalk.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import "GPSKakaoTalk.h"

static NSString *WEBBUTTONTITLE = @"웹으로 보기";
static NSString *APPBUTTONTITLE = @"앱으로 보기";

@interface GPSKakaoTalk ()
@property (nonatomic) CGSize imageSize;
@end

@implementation GPSKakaoTalk

+ (NSString *)sharerTitle {
	return @"KakaoTalk";
}

+ (BOOL)checkPrepare {
	BOOL result = YES;
	
	//////////////////////////////////////////////////////////////////////
	// Setting
	//////////////////////////////////////////////////////////////////////
	if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"KAKAO_APP_KEY"] == nil ||
		[[GPApplicationManager sharedManager] isAppScheme:[NSString stringWithFormat:@"kakao%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"KAKAO_APP_KEY"]]] == NO
		) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 설정이 필요합니다.", [self sharerTitle]);
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 Info.plist 설정", [self sharerTitle]);
		GPLogW(@"= 예) 카카오앱키 = 1234567890");
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("<key>CFBundleURLTypes</key>\n");
			printf("<array>\n");
			printf("\t<dict>\n");
			printf("\t\t<key>CFBundleURLSchemes</key>\n");
			printf("\t\t<array>\n");
			printf("\t\t\t<string>kakao1234567890</string>\n");
			printf("\t\t</array>\n");
			printf("\t</dict>\n");
			printf("</array>\n");
			printf("<key>KAKAO_APP_KEY</key>\n");
			printf("<string>1234567890</string>\n");
		}
		GPLogW(@"======================================================================");
		result = NO;
	}
	
	
	//////////////////////////////////////////////////////////////////////
	// LSApplicationQueriesSchemes
	//////////////////////////////////////////////////////////////////////
	NSMutableArray *needRegisterSchemes = [NSMutableArray new];
	NSArray *LSApplicationQueriesSchemes = @[
											 // 간편로그인
											 @"kakaokompassauth",
											 @"storykompassauth",
											 
											 // 카카오톡링크
											 @"kakaolink",
											 @"kakaotalk-5.9.7",
											 
											 // 카카오스토리링크
											 @"storylink"
											 ];
	
	for (NSString *scheme in LSApplicationQueriesSchemes) {
		if ([[GPApplicationManager sharedManager] isRegisteredCanOpenURLScheme:scheme] == NO) {
			[needRegisterSchemes addObject:scheme];
		}
	}
	
	NSString *KAKAO_APP_KEY = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"KAKAO_APP_KEY"];
	if (KAKAO_APP_KEY) {
		if ([[GPApplicationManager sharedManager] isRegisteredCanOpenURLScheme:[NSString stringWithFormat:@"kakao%@", KAKAO_APP_KEY]] == NO) {
			[needRegisterSchemes addObject:[NSString stringWithFormat:@"kakao%@", KAKAO_APP_KEY]];
		}
	}
	
	if (needRegisterSchemes.count > 0) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ LSApplicationQueriesSchemes 설정이 필요합니다.", [self sharerTitle]);
		GPLogW(@"= Info.plist 에 아래 항목을 추가해주세요");
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("<key>LSApplicationQueriesSchemes</key>\n");
			printf("<array>\n");
			for (NSString *scheme in needRegisterSchemes) {
				printf("\t<string>%s</string>\n", [scheme UTF8String]);
			}
			printf("</array>\n");
		}
		GPLogW(@"======================================================================");
		result = NO;
	}
	
	
	//////////////////////////////////////////////////////////////////////
	// AppDelegate
	//////////////////////////////////////////////////////////////////////
	if (result == NO) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 AppDelegate 설정", [self sharerTitle]);
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("#import <KakaoOpenSDK/KakaoOpenSDK.h>\n");
			printf("#import <KakaoLink/KakaoLink.h>\n");
			
			printf("\n");
			
			printf("- (void)applicationDidEnterBackground:(UIApplication *)application {\n");
			printf("\t// kakao\n");
			printf("\t[KOSession handleDidEnterBackground];\n");
			printf("}\n");
			
			printf("\n");
			
			printf("- (void)applicationDidBecomeActive:(UIApplication *)application {\n");
			printf("\t// kakao\n");
			printf("\t[KOSession handleDidBecomeActive];\n");
			printf("}\n");
			
			printf("\n");
			
			printf("- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {\n");
			printf("\t// kakao\n");
			printf("\tif ([KOSession handleOpenURL:url]) {\n");
			printf("\t\treturn YES;\n");
			printf("\t}\n");
			printf("\tif ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url]) {\n");
			printf("\t\tNSLog(@\"KakaoLink/KakaoStory callback! query string : %%@\", [url query]);\n");
			printf("\t\treturn YES;\n");
			printf("\t}\n");
			printf("\treturn NO;\n");
			printf("}\n");
			
			printf("\n");
			
			printf("- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {\n");
			printf("\t// kakao\n");
			printf("\tif ([KOSession handleOpenURL:url]) {\n");
			printf("\t\treturn YES;\n");
			printf("\t}\n");
			printf("\tif ([[KLKTalkLinkCenter sharedCenter] isTalkLinkCallback:url]) {\n");
			printf("\t\tNSLog(@\"KakaoLink/KakaoStory callback! query string : %%@\", [url query]);\n");
			printf("\t\treturn YES;\n");
			printf("\t}\n");
			printf("\treturn NO;\n");
			printf("}\n");
		}
		GPLogW(@"======================================================================");
	}
	
	return result;
}

+ (void)setWebButtonTitle:(NSString *)title {
	WEBBUTTONTITLE = title;
}

+ (void)setAppButtonTitle:(NSString *)title {
	APPBUTTONTITLE = title;
}

+ (id)shareItem:(GPSItem *)item showFromViewController:(UIViewController *)fromViewController {
	GPLogI(@"item : %@", item);
	//GPLog(@"fromViewController : %@", fromViewController);
	GPSKakaoTalk *controller = [self new];
	controller.item = item;
	[controller share];
	return controller;
}

+ (id)shareWithText:(NSString * _Nonnull)text imageURL:(NSURL * _Nonnull)imageURL linkURL:(NSURL * _Nonnull)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam {
	GPSKakaoTalkItem *item = [GPSKakaoTalkItem new];
	item.contentTitle = text;
	item.imageURL = imageURL;
	item.contentURL = linkURL;
	item.buttonType = buttonType;
	item.execparam = execparam;
	return [self shareItem:item showFromViewController:nil];
}

+ (id)shareWithTitle:(NSString * _Nonnull)title desc:(NSString *)desc imageURL:(NSURL * _Nonnull)imageURL linkURL:(NSURL * _Nonnull)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam {
	GPSKakaoTalkItem *item = [GPSKakaoTalkItem new];
	item.contentTitle = title;
	item.contentDescription = desc;
	item.imageURL = imageURL;
	item.contentURL = linkURL;
	item.buttonType = buttonType;
	item.execparam = execparam;
	return [self shareItem:item showFromViewController:nil];
}


#pragma mark - methods
- (void)share {
//	GPSKakaoTalkItem *item = (GPSKakaoTalkItem *)self.item;
	
	// exception
	if ([KLKTalkLinkCenter sharedCenter].isAvailable == NO) {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오톡 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
		return;
	}
	
//	// check image
//	if (item.imageURL) {
//		self.imageSize = CGSizeZero;
//
//		// get image size
//		[UIImage loadImageSizeInBackgroundWithURL:item.imageURL complete:^(BOOL success, CGSize imageSize) {
//			GPLogD(@"get imagesize : %@ %@", PrintBool(success), PrintSize(imageSize));
//			if (success) {
//				self.imageSize = imageSize;
//			}
//			else {
//				self.item.imageURL = nil;
//			}
//
//			// share
//			[self shareProcess];
//		}];
//		return;
//	}
	
	// share
	[self shareProcess];
}

- (void)shareProcess {
	__block GPSKakaoTalkItem *item = (GPSKakaoTalkItem *)self.item;
	
	// Feed 타입 템플릿 오브젝트 생성
	KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
		
		// 컨텐츠
		feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
			// title
			if (item.contentTitle) {
				contentBuilder.title = item.contentTitle;
			}
			// desc
			if (item.contentDescription) {
				contentBuilder.desc = item.contentDescription;
			}
			// imageURL
			if (item.imageURL) {
				contentBuilder.imageURL = item.imageURL;
			}
			// link
			if (item.contentURL) {
				contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
					linkBuilder.mobileWebURL = item.contentURL;
				}];
			}
		}];
		
//		// 소셜
//		feedTemplateBuilder.social = [KMTSocialObject socialObjectWithBuilderBlock:^(KMTSocialBuilder * _Nonnull socialBuilder) {
//			socialBuilder.likeCount = @(286);
//			socialBuilder.commnentCount = @(45);
//			socialBuilder.sharedCount = @(845);
//		}];
		
		// 버튼
		if (item.contentURL) {
			// webbutton
			if (item.buttonType == GPSKakaoTalkButtonTypeWebButton || item.buttonType == GPSKakaoTalkButtonTypeWebButtonAndAppButton) {
				[feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
					buttonBuilder.title = WEBBUTTONTITLE;
					buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
						linkBuilder.mobileWebURL = item.contentURL;
					}];
				}]];
			}
			
			// appbutton
			if (item.buttonType == GPSKakaoTalkButtonTypeAppButton || item.buttonType == GPSKakaoTalkButtonTypeWebButtonAndAppButton) {
				[feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
					buttonBuilder.title = APPBUTTONTITLE;
					buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
						// convert execparam to query string
						NSString *executionParams = nil;
						if (item.execparam) {
							NSURLComponents *components = [NSURLComponents new];
							NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
							for (NSString *key in item.execparam) {
								NSObject *value = item.execparam[key];
								if ([value isMemberOfClass:[NSURL class]]) {
									value = ((NSURL *)value).absoluteString;
								}
								GPLogD(@"key : %@", key);
								GPLogD(@"value : %@", value);
								[queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[((NSString *)value) URLEncode]]];
							}
							components.queryItems = [queryItems copy];
							executionParams = components.query;
						}
						GPLogI(@"executionParams : %@", executionParams);
						
						linkBuilder.androidExecutionParams = executionParams;
						linkBuilder.iosExecutionParams = executionParams;
					}];
				}]];
			}
		}
	}];
	GPLogD(@"template : %@", template);
	
	// 카카오링크 실행
	[[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
		// 성공
		GPLogI(@"warning message : %@", warningMsg);
		GPLogI(@"argument message : %@", argumentMsg);
	} failure:^(NSError * _Nonnull error) {
		// 실패
		GPLogE(@"error : %@", error);
	}];
}

@end


@implementation GPSKakaoTalkItem

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\nbuttonType : %d\nexecparam : %@", [super description], (int)self.buttonType, self.execparam];
}

@end
