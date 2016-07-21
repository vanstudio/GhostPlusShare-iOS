//
//  GPSKakaoTalk.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import "GPSKakaoTalk.h"

static NSString *WEBLINKTITLE = @"웹으로 이동";
static NSString *WEBBUTTONTITLE = @"웹으로 이동";
static NSString *APPBUTTONTITLE = @"앱으로 이동";

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
											 @"kakaokompassauth",
											 @"storykompassauth",
											 @"kakaolink",
											 @"kakaotalk-4.5.0",
											 @"kakaostory-2.9.0",
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
			printf("\tif ([KOSession isKakaoAccountLoginCallback:url]) {\n");
			printf("\t\treturn [KOSession handleOpenURL:url];\n");
			printf("\t}\n");
			printf("\tif ([KOSession isKakaoLinkCallback:url] || [KOSession isStoryPostCallback:url]) {\n");
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

+ (void)setWebLinkTitle:(NSString *)title {
	WEBLINKTITLE = title;
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

+ (id)shareWithText:(NSString *)text imageURL:(NSURL *)imageURL linkURL:(NSURL *)linkURL buttonType:(GPSKakaoTalkButtonType)buttonType execparam:(NSDictionary *)execparam {
	GPSKakaoTalkItem *item = [GPSKakaoTalkItem new];
	item.contentDescription = text;
	item.imageURL = imageURL;
	item.contentURL = linkURL;
	item.buttonType = buttonType;
	item.execparam = execparam;
	return [self shareItem:item showFromViewController:nil];
}


#pragma mark - methods
- (void)share {
	GPSKakaoTalkItem *item = (GPSKakaoTalkItem *)self.item;
	
	// exception
	if ([KOAppCall canOpenKakaoTalkAppLink] == NO) {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"카카오톡 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
		return;
	}
	
	// check image
	if (item.imageURL) {
		self.imageSize = CGSizeZero;
		
		// get image size
		[UIImage loadImageSizeInBackgroundWithURL:item.imageURL complete:^(BOOL success, CGSize imageSize) {
			GPLogD(@"get imagesize : %@ %@", PrintBool(success), PrintSize(imageSize));
			if (success) {
				self.imageSize = imageSize;
			}
			else {
				self.item.imageURL = nil;
			}
			
			// share
			[self shareProcess];
		}];
		return;
	}
	
	// share
	[self shareProcess];
}

- (void)shareProcess {
	GPSKakaoTalkItem *item = (GPSKakaoTalkItem *)self.item;
	NSMutableArray *appLinkArray = [NSMutableArray new];
	
	// label
	if (item.contentDescription) {
		KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:item.contentDescription];
		[appLinkArray addObject:label];
	}
	
	// image
	if (item.imageURL) {
		KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:item.imageURL.absoluteString width:self.imageSize.width height:self.imageSize.height];
		[appLinkArray addObject:image];
	}
	
	// weblink
	if (item.buttonType == GPSKakaoTalkButtonTypeWebLink || item.buttonType == GPSKakaoTalkButtonTypeWebLinkWithAppButton) {
		KakaoTalkLinkObject *webLink = [KakaoTalkLinkObject createWebLink:WEBLINKTITLE url:item.contentURL.absoluteString];
		[appLinkArray addObject:webLink];
	}
	
	// webbutton
	if (item.buttonType == GPSKakaoTalkButtonTypeWebButton) {
		KakaoTalkLinkObject *webButton = [KakaoTalkLinkObject createWebButton:WEBBUTTONTITLE url:item.contentURL.absoluteString];
		[appLinkArray addObject:webButton];
	}
	
	// appbutton
	if (item.buttonType == GPSKakaoTalkButtonTypeAppButton || item.buttonType == GPSKakaoTalkButtonTypeWebLinkWithAppButton) {
		KakaoTalkLinkAction *androidAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:item.execparam];
		KakaoTalkLinkAction *iphoneAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:item.execparam];
		KakaoTalkLinkAction *webLinkActionUsingPC = [KakaoTalkLinkAction createWebAction:item.contentURL.absoluteString];
		KakaoTalkLinkObject *appButton = [KakaoTalkLinkObject createAppButton:APPBUTTONTITLE actions:@[androidAppAction, iphoneAppAction, webLinkActionUsingPC]];
		[appLinkArray addObject:appButton];
	}
	
	// open kakaotalk
	[KOAppCall openKakaoTalkAppLink:appLinkArray];
}

@end


@implementation GPSKakaoTalkItem

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\nbuttonType : %d\nexecparam : %@", [super description], (int)self.buttonType, self.execparam];
}

@end