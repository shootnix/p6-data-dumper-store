class Data::Dumper::Store {
    has $.path;
    has $.filename is rw;
    has %!data;

    multi method init(Str $filename) {
        $.filename = $filename;
        my $fh = open "$.path/$filename", :r;
        my $data = $fh.slurp;
        $fh.close;

        %!data = EVAL $data;

        return 1;
    }

    multi method init(%data) {
        %!data = %data;
    }

    multi method init { die "Undefined Resourse" }

    method get($key) { return %!data{$key} }
    method set($key, $val) { %!data{$key} = $val }

    method commit($filename = $.filename) {
        die "Undefined Filename" unless $filename;
        die "Nothing to Save" unless %!data;

        my $fh = open "$.path/$filename", :rw;
        $fh.print(%!data.perl);
        $fh.close;

        return 1;
    }

    method destroy (Str $filename = $.filename) { unlink "$.path/$filename" }

    method dump {
        return %!data;
    }
}