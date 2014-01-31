
@implementation PRStatus

@dynamic state;
@dynamic targetUrl;
@dynamic descriptionText;
@dynamic createdAt;
@dynamic serverId;
@dynamic updatedAt;
@dynamic url;
@dynamic userId;
@dynamic userName;
@dynamic pullRequestId;

+ (PRStatus *)statusWithInfo:(NSDictionary *)info moc:(NSManagedObjectContext *)moc
{
	PRStatus *s = [DataItem itemWithInfo:info type:@"PRStatus" moc:moc];

	s.url = [info ofk:@"url"];
	s.state = [info ofk:@"state"];
	s.targetUrl = [info ofk:@"target_url"];
	s.descriptionText = [info ofk:@"description"];

	NSDictionary *userInfo = [info ofk:@"creator"];
	s.userName = [userInfo ofk:@"login"];
	s.userId = [userInfo ofk:@"id"];

	return s;
}

+ (NSArray *)statusesForPullRequestId:(NSNumber *)pullRequestId inMoc:(NSManagedObjectContext *)moc
{
	NSFetchRequest *f = [NSFetchRequest fetchRequestWithEntityName:@"PRStatus"];
	f.predicate = [NSPredicate predicateWithFormat:@"pullRequestId = %@",pullRequestId];
	return [moc executeFetchRequest:f error:nil];
}

- (COLOR_CLASS *)colorForDisplay
{
	static COLOR_CLASS *STATUS_RED, *STATUS_YELLOW, *STATUS_GREEN;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		STATUS_RED = [COLOR_CLASS colorWithRed:0.5 green:0.2 blue:0.2 alpha:1.0];
		STATUS_YELLOW = [COLOR_CLASS colorWithRed:0.6 green:0.5 blue:0.0 alpha:1.0];
		STATUS_GREEN = [COLOR_CLASS colorWithRed:0.3 green:0.5 blue:0.3 alpha:1.0];
	});

	if([self.state isEqualToString:@"pending"])
		return STATUS_YELLOW;
	else if([self.state isEqualToString:@"success"])
		return STATUS_GREEN;
	else
		return STATUS_RED;
}

- (NSString *)displayText
{
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
	});
	return [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:self.createdAt],self.descriptionText];
}

@end
