//
//  GPSKakaoStory.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import "GPSKakaoStory.h"

@interface GPSKakaoStoryItem ()
@property (nonatomic) BOOL isStoryLink;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appVer;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSDictionary *urlinfo;
@end

@implementation GPSKakaoStory

+ (NSString *)sharerTitle {
	return @"KakaoStory";
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

+ (id)shareItem:(GPSItem *)item showFromViewController:(UIViewController *)fromViewController {
	GPLogI(@"item : %@", item);
	//GPLog(@"fromViewController : %@", fromViewController);
	GPSKakaoStory *controller = [self new];
	controller.item = item;
	[controller share];
	return controller;
}

+ (id)shareWithText:(NSString *)text linkURL:(NSURL *)linkURL permission:(KOStoryPostPermission)permission execparam:(NSDictionary *)execparam {
	GPSKakaoStoryItem *item = [GPSKakaoStoryItem new];
	item.contentDescription = text;
	item.contentURL = linkURL;
	item.permission = permission;
	item.execparam = execparam;
	return [self shareItem:item showFromViewController:nil];
}

+ (id)shareStoryLinkWithText:(NSString *)text linkURL:(NSURL *)linkURL appId:(NSString *)appId appVer:(NSString *)appVer appName:(NSString *)appName urlinfo:(NSDictionary *)urlinfo {
	GPSKakaoStoryItem *item = [GPSKakaoStoryItem new];
	item.contentDescription = text;
	item.contentURL = linkURL;
	item.isStoryLink = YES;
	item.appId = appId;
	item.appVer = appVer;
	item.appName = appName;
	item.urlinfo = urlinfo;
	return [self shareItem:item showFromViewController:nil];
}

+ (NSDictionary *)createStoryLinkUrlInfoWithTitle:(NSString *)title desc:(NSString *)desc imageurl:(NSString *)imageurl type:(NSString *)type {
	NSMutableDictionary *urlinfo = [NSMutableDictionary new];
	if (title) {
		[urlinfo setObject:title forKey:KEY_STORYLINK_URLINFO_TITLE];
	}
	if (desc) {
		[urlinfo setObject:desc forKey:KEY_STORYLINK_URLINFO_DESC];
	}
	if (imageurl) {
		[urlinfo setObject:@[imageurl] forKey:KEY_STORYLINK_URLINFO_IMAGEURL];
	}
	if (type) {
		[urlinfo setObject:type forKey:KEY_STORYLINK_URLINFO_TYPE];
	}
	return urlinfo;
}


#pragma mark - methods
- (void)share {
	GPLogI();
	
	GPSKakaoStoryItem *item = (GPSKakaoStoryItem *)self.item;
	
	if (item.isStoryLink) {
		[self shareProcess];
	}
	else {
		// login
		if ([KOSession sharedSession].isOpen == NO) {
			[[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
				GPLog(@"error : %@", error);
				
				// login success
				if ([[KOSession sharedSession] isOpen]) {
					// retry
					[self share];
				}
			}];
			return;
		}
		
		// exception - 카카오스토리 사용자확인
		[KOSessionTask storyIsStoryUserTaskWithCompletionHandler:^(BOOL isStoryUser, NSError *error) {
			if (!error) {
				// isStoryUser의 boolean으로 판단합니다. true일 경우 story 사용자입니다.
				if (isStoryUser) {
					NSLog(@"You are a KakaoStory's user");
					[self shareProcess];
				} else {
					NSLog(@"You are not a KakaoStory's user");
					[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오스토리 사용자가 아닙니다." cancelButtonTitle:@"확인"];
				}
			} else {
				// error
				NSLog(@"%@", error);
			}
		}];
	}
}

- (void)shareProcess {
	GPLogI();
	GPSKakaoStoryItem *item = (GPSKakaoStoryItem *)self.item;
	
	// exception
	if (item.contentDescription == nil && item.contentURL == nil) {
		GPLogW(@"공유 할 내용이 없습니다.");
		return;
	}
	
	// check storylink
	if (item.isStoryLink) {
		NSURL *url = nil;
		NSString *post = @"";
		if (item.contentDescription) {
			post = [post stringByAppendingString:item.contentDescription];
		}
		if (item.contentURL) {
			if (post.length != 0) post = [post stringByAppendingString:@"\n"];
			post = [post stringByAppendingString:item.contentURL.absoluteString];
		}
		if (item.urlinfo) {
			url = [NSURL URLWithString:[NSString stringWithFormat:@"storylink://posting?post=%@&appid=%@&appver=%@&appname=%@&apiver=1.0&urlinfo=%@", [post URLEncode], [item.appId URLEncode], [item.appVer URLEncode], [item.appName URLEncode], [[item.urlinfo JSONString] URLEncode]]];
		}
		else {
			url = [NSURL URLWithString:[NSString stringWithFormat:@"storylink://posting?post=%@&appid=%@&appver=%@&appname=%@&apiver=1.0", [post URLEncode], [item.appId URLEncode], [item.appVer URLEncode], [item.appName URLEncode]]];
		}
		GPLog(@"url : %@", url);
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
			[[UIApplication sharedApplication] openURL:url];
		}
		else {
			[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오스토리 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
		}
		return;
	}
	
	// check session
	GPLog(@"[[KOSession sharedSession] isOpen] : %d", [[KOSession sharedSession] isOpen]);
	if ([[KOSession sharedSession] isOpen] == NO) {
		[[KOSession sharedSession] close];
		[[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
			GPLog(@"error : %@", error);
			
			// login success
			if ([[KOSession sharedSession] isOpen]) {
				// retry
				[self share];
			}
		}];
		return;
	}
	
	// kakaostory post
	if (item.contentURL != nil) {
		[KOSessionTask storyGetLinkInfoTaskWithUrl:item.contentURL.absoluteString
								 completionHandler:^(KOStoryLinkInfo *link, NSError *error) {
									 GPLog(@"link : %@", link);
									 GPLog(@"error : %@", error);
									 
									 // exception - 링크 정보 요청 실패
									 if (error) {
										 [GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"옳바른 링크가 아닙니다" cancelButtonTitle:@"확인"];
										 return;
									 }
									 
									 // 링크 정보 요청 성공
									 // post a link
									 [KOSessionTask storyPostLinkTaskWithLinkInfo:link
																		  content:item.contentDescription
																	   permission:item.permission
																		 sharable:YES
																 androidExecParam:item.execparam
																	 iosExecParam:item.execparam
																completionHandler:^(KOStoryPostInfo *post, NSError *error) {
																	GPLog(@"post : %@", post);
																	GPLog(@"error : %@", error);
																	
																	// exception
																	if (error) {
																		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"옳바른 링크가 아닙니다" cancelButtonTitle:@"확인"];
																		return;
																	}
																	
																	// post success
																	[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오스토리에 등록되었습니다" cancelButtonTitle:@"확인"];
																}];
								 }];
	}
	else {
		[KOSessionTask storyPostNoteTaskWithContent:item.contentDescription
										 permission:item.permission
										   sharable:YES
								   androidExecParam:item.execparam
									   iosExecParam:item.execparam
								  completionHandler:^(KOStoryPostInfo *post, NSError *error) {
									  GPLog(@"post : %@", post);
									  GPLog(@"error : %@", error);
									  
									  // exception
									  if (error) {
										  [GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"옳바른 내용이 아닙니다" cancelButtonTitle:@"확인"];
										  return;
									  }
									  
									  // post success
									  [GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오스토리에 등록되었습니다" cancelButtonTitle:@"확인"];
								  }];
	}
}
@end


@implementation GPSKakaoStoryItem

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\npermission : %d\nexecparam : %@", [super description], (int)self.permission, self.execparam];
}

@end
