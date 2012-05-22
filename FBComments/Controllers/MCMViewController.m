#import "MCMViewController.h"
#import "Facebook.h"
#import "Facebook+Comments.h"

@interface MCMViewController () <FBRequestDelegate>
@property (strong) Facebook *facebook;
@property (copy) NSArray *comments;
@end


@implementation MCMViewController
@synthesize commentsView;
@synthesize facebook, comments;

-(id)initWithFacebook:(Facebook *)aFacebook{
	if((self = [super initWithNibName:@"MainView" bundle:nil])){
		[self setFacebook:aFacebook];
    [self addObserver:self forKeyPath:@"comments" options:0 context:NULL];
	}
	return self;
}


-(void)viewDidLoad{
	[[self facebook] fetchCommentsForURL:[NSURL URLWithString:@"http://web.graphicly.com/action-lab-entertainment/princeless/1"] delegate:self];
}


-(void)dealloc{
  [self removeObserver:self forKeyPath:@"comments"];
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  if([@"comments" isEqualToString:keyPath]){
    [[self commentsView] reload:self];
  } else{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
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
  //NSLog(@"result: %@", [[result objectAtIndex:0] objectForKey:@"fql_result_set"]);
  [self setComments:[[result objectAtIndex:0] objectForKey:@"fql_result_set"]];
}

@end
