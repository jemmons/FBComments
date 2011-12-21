#import "MCMFacebookCommentsView.h"

@class Facebook;

@interface MCMViewController : UIViewController <MCMFacebookCommentsDataSource, MCMFacebookCommentsDelegate>
@property (weak) IBOutlet MCMFacebookCommentsView *commentsView;

-(id)initWithFacebook:(Facebook *)aFacebook;

@end
