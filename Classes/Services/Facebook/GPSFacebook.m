//
//  GPSFacebook.m
//  GhostPlusShare
//
//  Created by VANSTUDIO on 2016. 3. 21..
//  Copyright © 2016년 GhostPlus. All rights reserved.
//

#import "GPSFacebook.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
//#import <Social/Social.h>

@interface GPSFacebook () <FBSDKSharingDelegate>

@end

@implementation GPSFacebook

+ (NSString *)sharerTitle {
	return @"Facebook";
}

+ (BOOL)checkPrepare {
	BOOL result = YES;
	
	//////////////////////////////////////////////////////////////////////
	// Setting
	//////////////////////////////////////////////////////////////////////
	if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"] == nil ||
		[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookDisplayName"] == nil ||
		[[GPApplicationManager sharedManager] isAppScheme:[NSString stringWithFormat:@"fb%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"]]] == NO
		) {
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 설정이 필요합니다.", [self sharerTitle]);
		GPLogW(@"======================================================================");
		GPLogW(@"= %@ 관련 Info.plist 설정", [self sharerTitle]);
		GPLogW(@"= 예) FacebookAppID = 1234567890");
		GPLogW(@"======================================================================");
		if ([GhostPlus useLog]) {
			printf("<key>CFBundleURLTypes</key>\n");
			printf("<array>\n");
			printf("\t<dict>\n");
			printf("\t\t<key>CFBundleURLSchemes</key>\n");
			printf("\t\t<array>\n");
			printf("\t\t\t<string>fb1234567890</string>\n");
			printf("\t\t</array>\n");
			printf("\t</dict>\n");
			printf("</array>\n");
			printf("<key>FacebookAppID</key>\n");
			printf("<string>1234567890</string>\n");
			printf("<key>FacebookDisplayName</key>\n");
			printf("<string>앱이름</string>\n");
		}
		GPLogW(@"======================================================================");
		result = NO;
	}
	
	
	//////////////////////////////////////////////////////////////////////
	// LSApplicationQueriesSchemes
	//////////////////////////////////////////////////////////////////////
	NSMutableArray *needRegisterSchemes = [NSMutableArray new];
	NSArray *LSApplicationQueriesSchemes = @[
											 @"fbapi",
											 @"fb-messenger-share-api",
											 @"fbauth2",
											 @"fbshareextension"
											 ];
	
	for (NSString *scheme in LSApplicationQueriesSchemes) {
		if ([[GPApplicationManager sharedManager] isRegisteredCanOpenURLScheme:scheme] == NO) {
			[needRegisterSchemes addObject:scheme];
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
			printf("#import <FBSDKCoreKit/FBSDKCoreKit.h>\n");
			
			printf("\n");
			
			printf("- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {\n");
			printf("\t// Facebook for Track\n");
			printf("\t[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];\n");
			printf("}\n");
			
			printf("\n");
			
			printf("- (void)applicationDidBecomeActive:(UIApplication *)application {\n");
			printf("\t// Facebook for Track\n");
			printf("\t[FBSDKAppEvents activateApp];\n");
			printf("}\n");
			
			printf("\n");
			
			printf("- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {\n");
			printf("\t// Facebook\n");
			printf("\tif ([[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {\n");
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
	GPSFacebook *controller = [self new];
	controller.item = item;
	[controller shareFromViewController:fromViewController];
	return controller;
}

+ (id)shareWithLinkURL:(NSURL *)linkURL showFromViewController:(UIViewController *)fromViewController {
	GPSItem *item = [GPSItem new];
	item.contentURL = linkURL;
	return [self shareItem:item showFromViewController:fromViewController];
}

+ (id)shareWithImage:(UIImage *)image showFromViewController:(UIViewController *)fromViewController {
	GPSItem *item = [GPSItem new];
	item.image = image;
	return [self shareItem:item showFromViewController:fromViewController];
}

+ (id)shareWithImageURL:(NSURL *)imageURL showFromViewController:(UIViewController *)fromViewController {
	GPSItem *item = [GPSItem new];
	item.imageURL = imageURL;
	return [self shareItem:item showFromViewController:fromViewController];
}


#pragma mark - methods
- (void)shareFromViewController:(UIViewController *)fromViewController {
	GPLog(@"fromViewController : %@", fromViewController);
	
	//////////////////////////////////////////////////
	// FBSDKShareKit
	//////////////////////////////////////////////////
	// link type
	if (self.item.contentURL) {
		FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
		linkContent.contentURL = self.item.contentURL;
		[FBSDKShareDialog showFromViewController:fromViewController withContent:linkContent delegate:self];
	}
	// image type
	else if (self.item.image) {
		FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:self.item.image userGenerated:YES];
		FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
		photoContent.photos = @[photo];
		[FBSDKShareDialog showFromViewController:fromViewController withContent:photoContent delegate:self];
	}
	// image type (url)
	else if (self.item.imageURL) {
		__weak __typeof(self) weakSelf = self;
		[UIImage loadImageInBackgroundWithURL:self.item.imageURL complete:^(UIImage *image) {
			__strong __typeof(weakSelf) strongSelf = weakSelf;
			if (!image) {
				GPLogE(@"image is nil");
				return;
			}

			FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:YES];
			FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
			photoContent.photos = @[photo];
			[FBSDKShareDialog showFromViewController:fromViewController withContent:photoContent delegate:strongSelf];
		}];
	}
//	// video type
//	else if () {
//		FBSDKShareVideo *video = [FBSDKShareVideo videoWithVideoURL:videoURL];
//		FBSDKShareVideoContent *videoContent = [[FBSDKShareVideoContent alloc] init];
//		videoContent.video = video;
//		videoContent.previewPhoto = [FBSDKSharePhoto photoWithImage:previewImage userGenerated:YES];
//		[FBSDKShareDialog showFromViewController:fromViewController withContent:videoContent delegate:self];
//	}
	
	
	//////////////////////////////////////////////////
	// Social.framework
	// - FBSDKShareKit 대체로 인해 사용안함
	//////////////////////////////////////////////////
	/*
	// facebook app available
	if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		// exception - load image from url
		if (self.item.image == nil && self.item.imageURL != nil) {
			[UIImage loadImageInBackgroundWithURL:self.item.imageURL complete:^(UIImage *image) {
				self.item.image = image;
				self.item.imageURL = nil;
				[self shareFromViewController:fromViewController];
			}];
			return;
		}
		
		SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
		// IMAGE
		if (self.item.image) {
			BOOL addedImage = [facebook addImage:self.item.image];
			if (!addedImage) {
				[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"이미지 정보가 옳바르지 않습니다." cancelButtonTitle:@"확인"];
				return;
			}
		}
		
		// URL
		if (self.item.contentURL) {
			BOOL addedURL = [facebook addURL:self.item.contentURL];
			if (!addedURL) {
				[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"URL 정보가 옳바르지 않습니다." cancelButtonTitle:@"확인"];
				return;
			}
		}
		
		// TEXT
		// don't work
		//[facebook setInitialText:@"Hello, world"];
		
		// handler
		facebook.completionHandler = ^(SLComposeViewControllerResult result){
			switch (result) {
				case SLComposeViewControllerResultCancelled:
				{
					GPLog(@"SLComposeViewControllerResultCancelled");
				}
					break;
				case SLComposeViewControllerResultDone:
				{
					GPLog(@"SLComposeViewControllerResultDone");
				}
					break;
			}
		};
		[fromViewController presentViewController:facebook animated:YES completion:nil];
	}
	// facebook app not found
	else {
		[GPAlert showAlertWithTitle:[self.class sharerTitle] message:@"Facebook 앱을 설치하신 후에 이용하실 수 있습니다." cancelButtonTitle:@"확인"];
	}
	*/
}


#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
	GPLogD(@"results : %@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
	GPLogE(@"error : %@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
	GPLog();
}

@end
