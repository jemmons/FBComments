#import "MCMFacebookCommentsView.h"

@class Facebook;

@interface MCMViewController : UIViewController <MCMFacebookCommentsDataSource, MCMFacebookCommentsDelegate>
-(id)initWithFacebook:(Facebook *)aFacebook;

@end
