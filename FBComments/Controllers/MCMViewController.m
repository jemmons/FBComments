#import "MCMViewController.h"
#import "Facebook.h"
#import "Facebook+Comments.h"

@interface MCMViewController () <FBRequestDelegate>
@property (strong) Facebook *facebook;
@property (strong, nonatomic) NSArray *comments;
@end


@implementation MCMViewController
@synthesize facebook, comments = _comments;

-(id)initWithFacebook:(Facebook *)aFacebook{
	if((self = [super initWithNibName:@"MainView" bundle:nil])){
		[self setFacebook:aFacebook];
	}
	return self;
}


#pragma mark - ACCESSORS
-(NSArray *)comments{
	if(nil == _comments){
		[[self facebook] fetchCommentsForURL:[NSURL URLWithString:@"http://web.graphicly.com/action-lab-entertainment/princeless/1"] delegate:self];
		//Will return «nil».
	}
	return _comments;
}


#pragma mark - COMMENTS DATASOURCE
-(NSUInteger)numberOfComments:(MCMFacebookCommentsView *)commentsView{
	return [[self comments] count];
}


-(BOOL)commentsViewIsAuthenticated:(MCMFacebookCommentsView *)commentsView{
	return [[self facebook] isSessionValid];
}


#pragma mark - COMMENTS DELEGATE
-(void)commentsViewDidRequestAuthentication:(MCMFacebookCommentsView *)commentsView{
	[[self facebook] authorize:nil];
}


#pragma mark - FACEBOOK DELEGATE
-(void)request:(FBRequest *)request didLoad:(id)result{
	NSLog(@"Result! %@", result);
}

@end
