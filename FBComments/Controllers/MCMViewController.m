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
	}
	return self;
}


-(void)viewDidLoad{
  [self setCommentsController:[MCMFacebookCommentsController commentsControllerWithURL:[NSURL URLWithString:@"http://web.graphicly.com/action-lab-entertainment/princeless/1"] andFacebookObject:facebook]];
  [[[self commentsController] view] setFrame:CGRectMake(20.0f, 20.0f, 500.0f, 480.0f)];
  [[[self commentsController] view] setAutoresizingMask:UIViewAutoresizingNone];
  [[self view] addSubview:[[self commentsController] view]];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
  return YES;
}
@end
