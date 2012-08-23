#import "MCMViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "MCMFacebookCommentsController.h"
#import "MCMFacebookCommentsViewController.h"

@interface MCMViewController ()
@property (strong) Facebook *facebook;
@property (copy) NSArray *comments;
@property (strong) MCMFacebookCommentsController *commentsController;
@end


@implementation MCMViewController
@synthesize facebook, comments, commentsController;

-(id)init{
	if((self = [super initWithNibName:@"MainView" bundle:nil])){
	}
	return self;
}


-(void)viewDidLoad{
  MCMFacebookCommentsController *aCommentsController = [[MCMFacebookCommentsController alloc] initWithURL:[NSURL URLWithString:@"http://web.graphicly.com/action-lab-entertainment/princeless/1"]];
  [self setCommentsController:aCommentsController];
  [[[self commentsController] view] setFrame:CGRectMake(20.0f, 20.0f, 500.0f, 480.0f)];
  [[[self commentsController] view] setAutoresizingMask:UIViewAutoresizingNone];
  [[self view] addSubview:[[self commentsController] view]];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
  return YES;
}


-(IBAction)tapped:(id)sender {
  [FBSession openActiveSessionWithAllowLoginUI:YES];
}
@end
