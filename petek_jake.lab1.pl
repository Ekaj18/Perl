######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Jake Petek >			
#  < jakedpetek@gmail.com >			
#										
#########################################

# Replace the string value of the following variable with your names.
my $name = "Jake Petek";
my $partner = "Rohan Khante";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
#bigrams will be stored in here
my %bigrams = ();

# This loops through each line of the file
while($line = <INFILE>) {

	# YOUR CODE BELOW...

	#remove Track and Artist
	$line =~ s/.*<SEP>//g;

	my $title = $line;

	#remove the new line character
	$title =~ s/\n//; 

	#remove things after certain special characters and feat.
	$title =~ s/([\(\[\{\\\/_\-:"`=\*]|(feat\.)).*//g;

	#remove special characters
	$title =~ s/[\?¿!¡\.;&\$\@%#\|]/ /g;

	#checks for non english characters
	$title =~ s/.*[^(\w|\'|\s)].*//g;

	#make lowercase
	$title = lc($title);

	#remove extra spaces
	#$title =~ s/(^\s*|\s*$)//;

	#remove stop words
	$title =~ s/((^|\s)(a|an|and|by|for|from|in|of|on|or|out|the|to|with))*($|\s)/ /g;

	#store words in an array
	my @words = split/\s+/, $title;

	#loop through all bigrams in the title
	for (my $i = 0; $i < $#words; $i++){
		#increment bigrams
		$bigrams{$words[$i]}{$words[$i+1]}++;
		if($words[$i] eq 'the'){
			print "$title\n";
		}
	}
}

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";


# User control loop
while ($input ne "q"){
	#get input
	print "Enter a word [Enter 'q' to quit]: ";
	$input = <STDIN>;
	chomp($input);
	print "\n";
	#if the input is not q build a title
	if($input ne "q"){	
		my $first = $input;
		my $title = $input;
		my $done = 0;

		#loops while there are no repeat words
		while(!$done){

			#gets the next word
			$first = mcw($first);
			
			#makes sure the word isn't empty and isn't already in the title
			if($first ne "" && $title !~ m/(^|\s)$first($|\s)/){
				$title = $title . " " . $first;
			}
			
			else{
				$done = 1;
			}
		}
		print "$title\n\n";
	}
}

# MORE OF YOUR CODE HERE....

sub mcw {
	my ($word) = @_;
	my $greatest = 1;
	my $next;
	my @ties = ();

	#loop through all present bigrams for word
	foreach my $current (keys %{$bigrams{$word}}){

		#if new grestest, set greatest and next, and remove entries from ties
		if($bigrams{$word}{$current} > $greatest){
			$greatest = $bigrams{$word}{$current};
			$next = $current;
			@ties = ();
			push @ties, $current;
		}

		#if there is a tie add the word to ties
		elsif($bigrams{$word}{$current} == $greatest){
			push @ties, $current;
		}
	}
	#randomly pick a word from the list of top words
	$next = $ties[rand @ties];
	return $next;
}