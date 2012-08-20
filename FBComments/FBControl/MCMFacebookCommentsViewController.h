@class Facebook;

@interface MCMFacebookCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy) NSURL * commentsURL;

-(id)initWithURL:(NSURL *)aCommentsURL;
@end


