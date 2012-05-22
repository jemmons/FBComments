@class MCMFacebookCommentsView;


@protocol MCMFacebookCommentsDelegate <NSObject>
@optional
-(void)commentsViewDidRequestAuthentication:(MCMFacebookCommentsView *)commentsView;
@end


@protocol MCMFacebookCommentsDataSource <NSObject>
-(NSUInteger)numberOfComments:(MCMFacebookCommentsView *)commentsView;
@optional
-(BOOL)commentsViewIsAuthenticated:(MCMFacebookCommentsView *)commentsView;
@end


@interface MCMFacebookCommentsView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (weak) IBOutlet id<MCMFacebookCommentsDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<MCMFacebookCommentsDataSource> dataSource;

-(IBAction)reload:(id)sender;

@end
