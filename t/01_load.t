#!/usr/bin/perl -w
use v5.12;
use lib 'lib';
use Test::More tests => 5;

use_ok( 'Wx::Custom::Util' );
use_ok( 'Wx::Custom::Widget::ColorDisplay' );
use_ok( 'Wx::Custom::Widget::ColorToggle' );
use_ok( 'Wx::Custom::Widget::PositionMarker' );
use_ok( 'Wx::Custom::Widget::ProgressBar' );
