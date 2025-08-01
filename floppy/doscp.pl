#####
#
#   doscp.pl -- copies a file from a FAT floppy image.
#
#   usage: doscp.pl <imagename> <filename>
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

if($#ARGV == 1) {
	# open image given image file.
	open my $file, "<:raw", $ARGV[0] or
		die "E2: cannot open file $ARGV[0].\n";

	# read whole file into memory.
	my $count = read $file, my $image, $NUMBER_OF_BLOCKS * $BLOCK_SIZE or
		die "E3: cannot read file $ARGV[0].\n";

	# file no longer needed.
	close $file;

	# $BLOCK_SIZE = unpack "v", substr $image, 0x0B, 2;
	# $NUMBER_OF_BLOCKS = unpack "v", substr $image, 0x13, 2;

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

		# get file attributes.
		my $attr = unpack "C", substr $entry, 11, 1;

		# only take care of plain files.
		if(grep { $_ == $attr } (0, 1, 32, 33))
		{
			# get name from root directory.
			my $name = unpack "a11", substr $entry, 0, 11;
			
			# translate it into 8.3 notation.
			if($name =~ /^([^\s]{1,8})\s*([^\s]{1,3})?\s*$/) {
				$name = $2 eq "" ? "$1" : "$1.$2";
			}

			# is it file we're looking for?
			if($name eq uc $ARGV[1])
			{
				# get FAT from image.
				my $fat = substr $image, BLOCK_SIZE, BLOCK_SIZE * BLOCKS_PER_FAT;

				# get size of file.
				my $size = unpack "L", substr $entry, 0x1C, 4;

				# get first file cluster.
				my $cluster = unpack "v", substr $entry, 0x1A, 2;

				# get absolute offset on floppy.
				my $offset = (31 + $cluster) * $BLOCK_SIZE;

				# finally get file contents (1st cluster only).
				my $data = substr $image, $offset, $size < $BLOCK_SIZE ? $size : $BLOCK_SIZE;
				
				print STDOUT $data;
				
				exit;
			}
		}
	}
} else {
	# nothing to do.
	print STDERR "E1: no finename given.\n";
}
