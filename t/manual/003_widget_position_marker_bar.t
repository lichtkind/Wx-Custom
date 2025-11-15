#!/usr/bin/perl -w

use v5.12;
use warnings;
use lib 'lib', '../lib', '../../lib';

PositionMarkerTester->new->MainLoop( );
exit 0;

package PositionMarkerTester;
use v5.12;
use Wx;
use base qw/Wx::App/;

sub OnInit {
    my $app   = shift;
    my $frame = PositionMarkerTester::Frame->new( undef, __PACKAGE__);
    $frame->Show(1);
    $frame->CenterOnScreen();
    $app->SetTopWindow($frame);
    1;
}
sub OnQuit { my( $self, $event ) = @_; $self->Close( 1 ); }
sub OnExit { my $app = shift;  1; }


package PositionMarkerTester::Frame;
use base qw/Wx::Frame/;
use Wx::Custom::Widget::PositionMarker;

sub new {
    my ( $class, $parent, $title ) = @_;
    my $self = $class->SUPER::new( $parent, -1, $title );
    $self->SetIcon( Wx::GetWxPerlIcon() );

    my $marker = Wx::Custom::Widget::PositionMarker->new( $self, [30, 30], [20, 20, 200], 'empty');

    my $button_left  = Wx::Button->new( $self, -1, 'left');
    my $button_right = Wx::Button->new( $self, -1, 'right');
    my $button_up    = Wx::Button->new( $self, -1, 'up');
    my $button_down  = Wx::Button->new( $self, -1, 'down');
    my $button_empty = Wx::Button->new( $self, -1, 'empty');
    my $button_dis   = Wx::Button->new( $self, -1, 'disabled');
    my $button_red   = Wx::Button->new( $self, -1, 'red');
    my $button_blue  = Wx::Button->new( $self, -1, 'blue');
    my $button_white = Wx::Button->new( $self, -1, 'white');
    my $button_grey  = Wx::Button->new( $self, -1, 'gray');
    my $button_1     = Wx::Button->new( $self, -1, '1');
    my $button_2     = Wx::Button->new( $self, -1, '2');
    my $button_3     = Wx::Button->new( $self, -1, '3');
    my $button_4     = Wx::Button->new( $self, -1, '4');

    Wx::Event::EVT_BUTTON( $button_left,  $button_left,  sub { $marker->set_state('left') } );
    Wx::Event::EVT_BUTTON( $button_right, $button_right, sub { $marker->set_state('right') } );
    Wx::Event::EVT_BUTTON( $button_up,    $button_up,    sub { $marker->set_state('up') } );
    Wx::Event::EVT_BUTTON( $button_down,  $button_down,  sub { $marker->set_state('down') } );
    Wx::Event::EVT_BUTTON( $button_empty, $button_empty, sub { $marker->set_state('empty') } );
    Wx::Event::EVT_BUTTON( $button_dis,   $button_dis,   sub { $marker->set_state('disabled') } );
    Wx::Event::EVT_BUTTON( $button_red,   $button_red,   sub { $marker->set_foreground_color( [200,  20,  20] ) } );
    Wx::Event::EVT_BUTTON( $button_blue,  $button_blue,  sub { $marker->set_foreground_color( [ 20,  20, 220] ) } );
    Wx::Event::EVT_BUTTON( $button_white, $button_white, sub { $marker->set_background_color( [250, 250, 250] ) } );
    Wx::Event::EVT_BUTTON( $button_grey,  $button_grey,  sub { $marker->set_background_color( [170, 170, 170] ) } );
    Wx::Event::EVT_BUTTON( $button_1,     $button_1,     sub { $marker->set_line_thickness( 1 ) } );
    Wx::Event::EVT_BUTTON( $button_2,     $button_2,     sub { $marker->set_line_thickness( 2 ) } );
    Wx::Event::EVT_BUTTON( $button_3,     $button_3,     sub { $marker->set_line_thickness( 3 ) } );
    Wx::Event::EVT_BUTTON( $button_4,     $button_4,     sub { $marker->set_line_thickness( 4 ) } );

    my $item = &Wx::wxALIGN_CENTER_VERTICAL | &Wx::wxALIGN_CENTER_HORIZONTAL | &Wx::wxALL;
    my $row = &Wx::wxALIGN_CENTER_VERTICAL | &Wx::wxALIGN_LEFT | &Wx::wxLEFT;
    my $grow = &Wx::wxEXPAND|&Wx::wxGROW;
    my $mark_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $mark_sizer->Add( $marker,  0, $item,  10);
    $mark_sizer->Add( 0,        1, $grow);
    my $button_dir_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $button_dir_sizer->Add( $button_left,  0, $item,  10);
    $button_dir_sizer->Add( $button_right, 0, $item,  10);
    $button_dir_sizer->Add( $button_up,    0, $item,  10);
    $button_dir_sizer->Add( $button_down,  0, $item,  10);
    $button_dir_sizer->Add( 0,             1, $grow);
    my $button_state_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $button_state_sizer->Add( $button_empty, 0, $item,  10);
    $button_state_sizer->Add( $button_dis,   0, $item,  10);
    $button_state_sizer->Add( 0,             1, $grow);
    my $button_color_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $button_color_sizer->Add( $button_red,   0, $item,  10);
    $button_color_sizer->Add( $button_blue,  0, $item,  10);
    $button_color_sizer->Add( $button_white, 0, $item,  10);
    $button_color_sizer->Add( $button_grey,  0, $item,  10);
    $button_color_sizer->Add( 0,             1, $grow);
    my $button_thick_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $button_thick_sizer->Add( $button_1,     0, $item,  10);
    $button_thick_sizer->Add( $button_2,     0, $item,  10);
    $button_thick_sizer->Add( $button_3,     0, $item,  10);
    $button_thick_sizer->Add( $button_4,     0, $item,  10);
    $button_thick_sizer->Add( 0,             1, $grow);
    my $sizer = Wx::BoxSizer->new(&Wx::wxVERTICAL);
    $sizer->Add( $mark_sizer,         1, $row|&Wx::wxGROW,   5);
    $sizer->Add( $button_dir_sizer,   0, $row,   5);
    $sizer->Add( $button_state_sizer, 0, $row,   5);
    $sizer->Add( $button_color_sizer, 0, $row,   5);
    $sizer->Add( $button_thick_sizer, 0, $row,   5);
    $sizer->Add( 0,                   1, $grow);
    $self->SetSizer($sizer);
    $self->SetSize( [600, 300]);
    $self;
}
