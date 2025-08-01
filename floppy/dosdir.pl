#####
#
#   dosdir.pl -- display contents of a FAT floppy image.
#
#   usage: dosdir.pl <imagename>
#
#   changes:
#   2025/07/30   creation.
#
#   remarks:
#   - currently only takes care of 1.44MB floppies
#
#####

$NUMBER_OF_BLOCKS = 2880;
$BLOCK_SIZE       = 512;

if($#ARGV == 0) {
	# open image given image file.
	open my $file, "<:raw", $ARGV[0] or
		die "E2: cannot open file $ARGV[0].\n";

	# read whole file into memory.
	my $count = read $file, my $image, $NUMBER_OF_BLOCKS * $BLOCK_SIZE or
		die "E3: cannot read file $ARGV[0].\n";

	# file no longer needed.
	close $file;

	# make sure we read exactly 1.44MB.
	die "E4: file $ARGV[0] has wrong size.\n"
		unless $count == $NUMBER_OF_BLOCKS * $BLOCK_SIZE;

	$BLOCKS_PER_FAT = unpack "C", substr $image, 0x16, 2;
	$NUMBER_ROOT_ENTRIES = unpack "v", substr $image, 0x11, 2;
	$ROOT_SIZE = $NUMBER_ROOT_ENTRIES * 32;

	# get root directory.
	my $root = substr $image, $BLOCK_SIZE + 2 * $BLOCKS_PER_FAT * $BLOCK_SIZE, $ROOT_SIZE;

	# iterate through root directory.
	for my $index (0 .. $NUMBER_ROOT_ENTRIES - 1) {
		my $entry = substr($root, $index * 32, 32);

		my $name = unpack "a8", substr $entry, 0, 8;
		my $ext  = unpack "a3", substr $entry, 8, 3;
		my $attr = unpack "C", substr $entry, 11, 1;
		my $size = unpack "L", substr $entry, 28, 4;

		# file empty or marked deleted.
		next if $name eq '' || $name =~ /^\x00/;

		# only display plain files.
		next unless
			(grep { $_ == $attr } (0, 1, 32, 33));

		printf "%s %3s %10i\n", $name, $ext, $size;
	}
} else {
	# nothing to do.
	print STDERR "E1: no finename given.\n";
}
