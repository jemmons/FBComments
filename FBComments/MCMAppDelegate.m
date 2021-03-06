#import "MCMAppDelegate.h"

#import "MCMViewController.h"

#import "constants.h"


@implementation MCMAppDelegate

@synthesize window, viewController, facebook;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [self setFacebook:[[Facebook alloc] initWithAppId:MCMFacebookAppID andDelegate:self]];
  if([userDefaults objectForKey:MCMFacebookAccessTokenKey] && [userDefaults objectForKey:MCMFacebookExpirationDateKey]){
    [[self facebook] setAccessToken:[userDefaults objectForKey:MCMFacebookAccessTokenKey]];
    [[self facebook] setExpirationDate:[userDefaults objectForKey:MCMFacebookExpirationDateKey]];
  }
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// Override point for customization after application launch.
	self.viewController = [[MCMViewController alloc] initWithFacebook:facebook];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[self facebook] handleOpenURL:url]; 
}




- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

#pragma mark - FACEBOOK DELEGATES
-(void)fbDidLogin{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[facebook accessToken] forKey:MCMFacebookAccessTokenKey];
	[defaults setObject:[facebook expirationDate] forKey:MCMFacebookExpirationDateKey];
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:MCMFacebookDidLogInNotification object:[self facebook]];
}

@end
