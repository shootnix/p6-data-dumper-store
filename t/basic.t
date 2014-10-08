BEGIN { @*INC.unshift('lib') }

use Test;
#no warn;

use Data::Dumper::Store;

ok my $store = Data::Dumper::Store.new(path => '.'), 'new';
is $store.path, '.', 'path is "."';

ok ! $store.load, 'load empty data';
ok ! $store.commit, 'save with undefined filename';
ok ! $store.commit('somefile'), 'store with empty data';

my %data = (foo => 'bar', baz => 'bee');
ok $store.load(%data), 'load from (Hash)';
is $store.get('foo'), 'bar', 'get';
$store.set('one', 'two');
is $store.get('one'), 'two', 'get one';
ok $store.commit('test-dump'), 'save';

ok $store.load('test-dump'), 'load from file';
is $store.get('foo'), 'bar', 'loaded ok';
ok $store.destroy, 'destroy';
