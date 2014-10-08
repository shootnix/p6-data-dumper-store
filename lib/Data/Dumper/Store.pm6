class Data::Dumper::Store {
    has $.path;
    has $.filename is rw;
    has %!data;

    multi method load(Str $filename) {
        $.filename = $filename;
        my $fh = open "$.path/$filename", :r;
        my $data = $fh.slurp;
        $fh.close;

        %!data = EVAL $data;

        return 1;
    }

    multi method load(%data) {
        %!data = %data;
    }

    multi method load { warn "ERROR: Undefined Resourse"; return False }

    method get($key) { return %!data{$key} }
    method set($key, $val) { %!data{$key} = $val; return $val }

    method commit($filename = $.filename) {
        #die "Undefined filename" unless $filename;
        unless ($filename) {
            warn "ERROR: Undefined Filename";
            return False;
        }

        unless (%!data) {
            warn "ERROR: Nothing to Save";
            return False;
        }

        my $fh = open "$.path/$filename", :rw;
        $fh.print(%!data.perl);
        $fh.close;

        return 1;
    }

    method destroy (Str $filename = $.filename) {

        unlink "$.path/$filename";
    }
}