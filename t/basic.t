BEGIN { @*INC.unshift('lib') }

use Test;
use Data::Dumper::Store;

ok my $storage = Data::Dumper::Store.new(path => '.'), 'new';
is $storage.path, '.', 'path is "."';

try { $storage.init }
if $! {
    pass 'load empty data';
}

try { $storage.commit }
if $! {
    pass 'save with undefined filename';
    is $!, 'Undefined Filename', 'Msg is "Undefined Filename"';
}

try { $storage.commit('somefile') }
if $! {
    pass 'store with empty data';
    is $!, 'Nothing to Save', 'Msg is "Nothing to Save"';
}

try { $storage.init('non-existing-file') }
if $! {
    pass 'init with non-existing-file';
}

my %data = (foo => 'bar', baz => 'bee');
ok $storage.init(%data), 'load from (Hash)';

ok $storage.dump, 'dump';
is $storage.dump<foo>, 'bar', '"foo" from dump eq "bar"';

is $storage.get('foo'), 'bar', 'get';
$storage.set('one', 'two');
is $storage.get('one'), 'two', 'get one';
ok $storage.commit('test-dump'), 'save';

ok $storage.init('test-dump'), 'load from file';
is $storage.get('foo'), 'bar', 'loaded ok';
ok $storage.destroy, 'destroy';
