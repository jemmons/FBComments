#import "FBConnect.h"

@class MCMViewController;

@interface MCMAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) MCMViewController *viewController;
@property (strong) Facebook *facebook;

@end
