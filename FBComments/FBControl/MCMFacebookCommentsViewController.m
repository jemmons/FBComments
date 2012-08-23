#import "MCMFacebookCommentsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "MCMComment.h"
#import "MCMCommentCell.h"
#import "MCMDetailViewController.h"

static NSString * const kCommentCellIdentifier = @"MCM Facebook comment cell identifier";

@interface MCMFacebookCommentsViewController ()
@property (copy, nonatomic) NSArray *comments;

@property (weak) id facebookDidLogInObserver;
@property (weak) id commentDidUpdateDataObserver;

-(void)fetchCommentsForURL:(NSURL*)aURL;
-(IBAction)authenticateButtonTapped:(id)sender;
-(void)reloadButtons;
-(NSArray *)mergeFacebookQuery:(NSArray *)oneThing with:(NSArray *)anotherThing;
@end

@implementation MCMFacebookCommentsViewController
@synthesize commentsURL;
@synthesize comments;
@synthesize facebookDidLogInObserver, commentDidUpdateDataObserver;

-(id)initWithURL:(NSURL *)aCommentsURL{
  if((self = [super initWithNibName:nil bundle:nil])){
    [self setCommentsURL:aCommentsURL];
  }
  return self;
}

-(void)loadView{
  UITableView *aView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f) style:UITableViewStylePlain];
  [aView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [aView setDelegate:self];
  [aView setDataSource:self];
  [aView setRowHeight:70.0f];
  [aView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCellIdentifier];
  [self setView:aView];
}


-(void)viewDidLoad{  
//	[self setFacebookDidLogInObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMFacebookDidLogInNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
//		[self reloadButtons];
//	}]];
  
  [self setCommentDidUpdateDataObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMCommentDidUpdateDataNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    MCMComment *updatedComment = [note object];
    NSUInteger updatedIndex = [[self comments] indexOfObject:updatedComment];
    NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedIndex inSection:0];
    MCMCommentCell *cell = (MCMCommentCell *)[(UITableView *)[self view] cellForRowAtIndexPath:updatedIndexPath];
    if(cell){
      [[cell image] setImage:[updatedComment profileImage]];
    }
  }]];
  
  [self fetchCommentsForURL:[self commentsURL]];
}


-(void)viewDidUnload{
  [[NSNotificationCenter defaultCenter] removeObserver:[self commentDidUpdateDataObserver]];
//  [[NSNotificationCenter defaultCenter] removeObserver:[self facebookDidLogInObserver]];
//  [self setFacebookDidLogInObserver:nil];
}


#pragma mark - ACCESSORS
-(void)setComments:(NSArray *)someComments{
  comments = someComments;
  [(UITableView *)[self view] reloadData];
}


#pragma mark - ACTIONS
-(IBAction)authenticateButtonTapped:(id)sender{
//	if([[self delegate] respondsToSelector:@selector(commentsViewDidRequestAuthentication:)]){
//		[[self delegate] commentsViewDidRequestAuthentication:[self parent]];	
//	}
}


#pragma mark - TABLE VIEW DELEGATES
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[self comments] count];
}


-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	MCMCommentCell *cell = [aTableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
  NSInteger row = [indexPath row];
  MCMComment *comment = [[self comments] objectAtIndex:row];

  [[cell comment] setText:[comment comment]];
  [[cell name] setText:[comment name]];
  [[cell image] setImage:[comment profileImage]];
  [cell setIndented:[comment isIndented]];
	return cell;
}


-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIViewController *detailViewController = [[MCMDetailViewController alloc] initWithComment:[[self comments] objectAtIndex:[indexPath row]]];
  [[self navigationController] pushViewController:detailViewController animated:YES];
  [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - FACEBOOK STUFF
-(void)fetchCommentsForURL:(NSURL*)aURL{
  NSString* fql = [NSString stringWithFormat:@"{\"comments\":\"SELECT fromid, text, time, comments FROM comment WHERE object_id IN (SELECT comments_fbid FROM link_stat WHERE url ='%@')\", \"users\":\"SELECT name, id FROM profile WHERE id IN (SELECT fromid FROM #comments)\"}", aURL];

  [FBRequestConnection startWithGraphPath:@"/fql" parameters:@{@"q":fql} HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", [error localizedDescription]);
    } else {
      NSArray *fbComments = result[@"data"][0][@"fql_result_set"];
      NSArray *fbUsers = result[@"data"][1][@"fql_result_set"];
      [self setComments:[self mergeFacebookQuery:fbComments with:fbUsers]];
    }
  }];
}


#pragma mark - PRIVATE
-(NSArray *)mergeFacebookQuery:(NSArray *)someComments with:(NSArray *)someUsers{
  NSMutableArray *newComments = [NSMutableArray arrayWithCapacity:[someComments count]];
  
  [someComments enumerateObjectsUsingBlock:^(id aComment, NSUInteger idx, BOOL *stop) {
    NSDictionary *aUser = someUsers[idx];
    
    MCMComment *newComment = [[MCMComment alloc] init];
    [newComment setName:aUser[@"name"]];
    [newComment setComment:aComment[@"text"]];
    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", aUser[@"id"]];
    [newComment setProfileImageURL:[NSURL URLWithString:urlString]];
    [newComments addObject:newComment];
    
    id replies = aComment[@"comments"];
    if([replies count]){
      [[replies objectForKey:@"data"] enumerateObjectsUsingBlock:^(id aReply, NSUInteger idx, BOOL *stop) {
        MCMComment *newReply = [[MCMComment alloc] init];
        [newReply setComment:[aReply objectForKey:@"message"]];
        [newReply setName:[[aReply objectForKey:@"from"] objectForKey:@"name"]];
        NSString *replyURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [[aReply objectForKey:@"from"] objectForKey:@"id"]];
        [newReply setProfileImageURL:[NSURL URLWithString:replyURLString]];
        [newReply setIndented:YES];
        [newComments addObject:newReply];
      }];
    }
  }];
  return newComments;
}


-(void)reloadButtons{	
//	[[self authenticateButton] setHidden:[self isAuthenticated]];
}


-(BOOL)isAuthenticated{
  BOOL isAuthenticated = NO;
//  if([[self dataSource] respondsToSelector:@selector(commentsViewIsAuthenticated:)]){
//    isAuthenticated = [[self dataSource] commentsViewIsAuthenticated:[self parent]];
//  }
	return isAuthenticated;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
  return YES;
}


@end