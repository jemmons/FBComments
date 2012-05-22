#import "MCMViewController.h"
#import "Facebook.h"
#import "Facebook+Comments.h"

#import "MCMFacebookCommentsController.h"
#import "MCMFacebookCommentsViewController.h"

@interface MCMViewController () <FBRequestDelegate>
@property (strong) Facebook *facebook;
@property (copy) NSArray *comments;
@property (strong) MCMFacebookCommentsController *commentsController;
@end


@implementation MCMViewController
@synthesize facebook, comments, commentsController;

-(id)initWithFacebook:(Facebook *)aFacebook{
	if((self = [super initWithNibName:@"MainView" bundle:nil])){
		[self setFacebook:aFacebook];
    [self addObserver:self forKeyPath:@"comments" options:0 context:NULL];
	}
	return self;
}


-(void)viewDidLoad{
  [self setCommentsController:[MCMFacebookCommentsController commentsController]];
  [[[self commentsController] view] setFrame:CGRectMake(20.0f, 20.0f, 320.0f, 480.0f)];
  [[self view] addSubview:[[self commentsController] view]];
//	[[self facebook] fetchCommentsForURL:[NSURL URLWithString:@"http://web.graphicly.com/action-lab-entertainment/princeless/1"] delegate:self];
}


-(void)dealloc{
  [self removeObserver:self forKeyPath:@"comments"];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
  return YES;
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//  if([@"comments" isEqualToString:keyPath]){
//    [[self commentsView] reload:self];
//  } else{
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//  }
}


#pragma mark - FACEBOOK DELEGATE
-(void)request:(FBRequest *)request didLoad:(id)result{
  //NSLog(@"result: %@", [[result objectAtIndex:0] objectForKey:@"fql_result_set"]);
  [self setComments:[[result objectAtIndex:0] objectForKey:@"fql_result_set"]];
}

@end
