
# numeric value input with a display, slider and nudge buttons

package Wx::Custom::Widget::NumericRangeInput;
use v5.12;
use warnings;
use Wx;
use base qw/Wx::Panel/;
use Wx::Custom::Util qw/check_named_args/;

sub new {
    my $class = shift @_;
	my $arg = check_named_args( { 
			size => [100, 20], 
      init_value => 0,
       min_value => 0,
       max_value => 10,
     value_delta =>  1,
     slider_size => 100,
            name => '',
            help => '',
    }, @_ );
    return $arg unless ref $arg;

    my $self = $class->SUPER::new( $parent, -1);
    $self->{'attr'} = $arg;
    my $lbl  = Wx::StaticText->new($self, -1, $arg->{'name'});
    $self->{'value'} = $arg->{'init_value'};
    $self->{'callback'} = sub {};

    my @l = map {length $_}  $arg->{'min_value'}, $arg->{'min_value'} + $arg->{'value_delta'},  
                             $arg->{'max_value'} - $arg->{'value_delta'}, $arg->{'max_value'};
    my $max_txt_size = 0;
    map {$max_txt_size = $_ if $max_txt_size < $_} @l;
    $self->{'widget'}{'txt'} = Wx::TextCtrl->new( $self, -1, $init_value, [-1,-1], [(6 * $max_txt_size) + 26,-1], &Wx::wxTE_RIGHT);
    $self->{'widget'}{'button'}{'-'} = Wx::Button->new( $self, -1, '-', [-1,-1],[27,27] );
    $self->{'widget'}{'button'}{'+'} = Wx::Button->new( $self, -1, '+', [-1,-1],[27,27] );

    $self->{'widget'}{'slider'} = Wx::Slider->new(
        $self, -1, $arg->{'init_value'} / $arg->{'value_delta'}, 
        $arg->{'min_value'} / $arg->{'value_delta'}, $arg->{'max_value'} / $arg->{'value_delta'},
        [-1, -1], [$arg->{'slider_size'}, -1], &Wx::wxSL_HORIZONTAL | &Wx::wxSL_BOTTOM ) if $arg->{'slider_size'};

    $lbl->SetToolTip( $arg->{'help'} );
    $self->{'widget'}{'txt'}->SetToolTip( $arg->{'help'} );
    $self->{'widget'}{'slider'}->SetToolTip( $arg->{'help'} ) if exists $self->{'widget'}{'slider'};
    $self->{'widget'}{'button'}{'-'}->SetToolTip( 'decrease '.(($arg->{'name'}) ? $arg->{'name'}.' ':'').'by '.$arg->{'value_delta'} );
    $self->{'widget'}{'button'}{'+'}->SetToolTip( 'increase '.(($arg->{'name'}) ? $arg->{'name'}.' ':'').'by '.$arg->{'value_delta'} );

    my $sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    my $attr = &Wx::wxLEFT | &Wx::wxALIGN_CENTER_VERTICAL | &Wx::wxALIGN_LEFT;
    $sizer->Add( $lbl,                             0, $attr,  5);
    $sizer->Add( $self->{'widget'}{'txt'},         0, $attr, 10);
    $sizer->Add( $self->{'widget'}{'button'}{'-'}, 0, $attr,  0);
    $sizer->Add( $self->{'widget'}{'button'}{'+'}, 0, $attr,  0);
    $sizer->Add( $self->{'widget'}{'slider'},      0, $attr, 10);
    $sizer->Add( 0,     1, &Wx::wxEXPAND|&Wx::wxGROW);
    $self->SetSizer($sizer);

    Wx::Event::EVT_TEXT( $self, $self->{'widget'}{'txt'}, sub {
        my ($self, $cmd) = @_;
        my $value = $cmd->GetString;
        $value =  $self->{'attr'}{'init_value'} if not defined $value;
        $self->SetValue( $value );
    });
    Wx::Event::EVT_BUTTON( $self, $self->{'widget'}{'button'}{'-'}, sub {
        $self->SetValue( $self->{'value'} - $self->{'value_delta'} )
    });
    Wx::Event::EVT_BUTTON( $self, $self->{'widget'}{'button'}{'+'}, sub {
        $self->SetValue( $self->{'value'} + $self->{'value_delta'} )
    });
    Wx::Event::EVT_SLIDER( $self, $self->{'widget'}{'slider'},   sub {
        my ($self, $cmd) = @_;
        $self->SetValue( $cmd->GetInt * $self->{'value_delta'} );
    }) if defined $self->{'widget'}{'slider'};

    return $self;
}

sub GetValue { $_[0]->{'value'} }

sub SetValue {
    my ( $self, $value, $passive) = @_;
    return if not defined $value or $self->{'value'} == $value or exists $self->{'no_recursive_events'};
    $value = $self->{'value_delta'} * int( $value / $self->{'value_delta'}) if $self->{'value_delta'};
    $value = $self->{'min_value'} if int($value) < $self->{'min_value'};
    $value = $self->{'max_value'} if int($value) > $self->{'max_value'};
    return if $self->{'value'} == $value;
    $self->{'no_recursive_events'}++;

    $self->{'value'} = $value;
    my $slider_val = $value / $self->{'value_delta'};
    $self->{'widget'}{'button'}{'-'}->Enable( $value != $self->{'min_value'} );
    $self->{'widget'}{'button'}{'+'}->Enable( $value != $self->{'max_value'} );
    $self->{'widget'}{'txt'}->SetValue( $value ) unless $value == $self->{'widget'}{'txt'}->GetValue;
    $self->{'widget'}{'slider'}->SetValue( $slider_val ) if
        defined $self->{'widget'}{'slider'} and $slider_val != $self->{'widget'}{'slider'}->GetValue;
    $self->{'callback'}->( $value ) unless defined $passive;
    delete $self->{'no_recursive_events'}
}

sub set_callback {
    my ( $self, $code) = @_;
    return unless ref $code eq 'CODE';
    $self->{'callback'} = $code;
}

sub mod_real {
    my ($value, $mod) = @_;
    my $div = int $value / $mod;
    return ($value - ($div * $mod));
}

1;
