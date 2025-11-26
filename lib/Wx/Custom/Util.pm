
package Wx::Custom::Util;
use v5.12;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw/check_named_args/;

sub check_named_args {
    my ($default_value, @args) = @_;
    return 'Default values has to be provided in a HASH ref' unless ref $default_value eq 'HASH';
    @args = %{$args[0]} if @args == 1 and ref $args[0] eq 'HASH';    # resolve if args already hash
    return 'Need a even amount of arguments' if @args % 2;
    my %args = @args;
    my %result;
    for my $key (keys %$default_value){
        return 'Required argument: "$key" is missing' if not defined $default_value->{$key} and not exists $args{$key};
        $result{$key} = (exists $args{$key})
                      ? $args{$key}
                      : $default_value->{$key};

    }
    return \%result;
}

1;

