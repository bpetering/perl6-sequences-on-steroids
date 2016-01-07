use v6;

our constant OEIS_FILE = 'oeis_db.csv';


class SOS {

}

sub list-to-oeis-searchable(@l) {
    my @a = @l;
    @a.push('');
    @a.unshift('');
    @a.join(',')
}

sub find-oeis-line($s) {
    for OEIS_FILE.IO.lines -> $line {
        if $line.contains($s) {
            return $line;
        }
    }
    return False;
}

sub oeis-seq-number(@l) {
    my $line = find-oeis-line(list-to-oeis-searchable(@l));
    $line ~~ /^(A\d+)/;
    $0.Str
}

sub is-consistent(@l) {
    if @l.elems < 2 {
        die "Need > 1 elems";
    }

    my $first_diff = @l[1] - @l[0];
    my Bool $consistent = True;
    loop ( my $i = 1; $i < @l.end; $i++ ) {
        if @l[$i+1] - @l[$i] != $first_diff {
            $consistent = False;
            last;
        }
    }
    $consistent
}

sub infer(@l) is export {

    say @l.WHAT;
    say @l;

    # Check for an arithmetic progression - consistent with no transform
    if is-consistent(@l) {
        say "arithmetic progression\n"; return;
    }

    # Check for geometric progression - equivalent to trying various
    # transforms before consistency check
    for 2..100 -> $base {
        # 2 4 8 16 32
        my @transformed = @l.map({ $base ** $_ });
        say @transformed;
    }

    say "structure not inferred\n"; return;

}


# my @a = ^20;
# infer(@a);

# my @b = 1,2,3,5;
# infer(@b);

# my @c = 1.1, 1.2, 1.3;
# infer(@c);

# my @d = 1.1, 1.2, 1.3, 1.5;
# infer(@d);

# my @e = 3, 2, 1;
# infer(@e);

# my @f = 2.2, 2.1, 2.0;
# infer(@f);

# my @g = 2, 4, 8, 16, 32;
# infer(@g);

# my @x = 1,2,3,4;
# say list-to-oeis-searchable(@x);

say oeis-seq-number((2,4,8,16));
