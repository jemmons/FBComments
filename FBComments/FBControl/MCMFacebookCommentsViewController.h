@class Facebook;

@interface MCMFacebookCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy) NSURL * commentsURL;
@property (weak) Facebook *facebook;

-(id)initWithURL:(NSURL *)aCommentsURL andFacebook:(Facebook *)aFacebook;
@end


