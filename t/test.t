#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use Test::More;
use YAML;

# each value is an arrayref with 2 elements, indexed by file name:
# - expected output from find_edid_in_string function
# - list of tuples foreach edid fragement:
#   - expected output from parse_edid function
#   - expected output from check_parsed_edid function
my $tests = Load(join('', <DATA>));

# use test
my $count = 1;
foreach my $test (keys %$tests) {
    # one find_edid test, plus two tests foreach fragment
    $count += 1 + (2 * scalar @{$tests->{$test}->[1]});
}
plan tests => $count;

use_ok('Parse::EDID');

foreach my $test (keys %$tests) {
    my $string = read_file("t/$test");

    my @edids = find_edid_in_string($string);
    is_deeply(
        \@edids,
        [ map { binary($_) } @{$tests->{$test}->[0]} ],
        "file $test: edids extraction"
    );

    for my $i (0 .. $#edids) {
        my $parsed_edid = parse_edid($edids[$i]);
        is_deeply(
            $parsed_edid,
            $tests->{$test}->[1]->[$i]->[0],
            "file $test, edid $i: parsing"
        );

        my $message = check_parsed_edid($parsed_edid);
        is(
            $message,
            $tests->{$test}->[1]->[$i]->[1],
            "file $test, edit $i: checking"
        );
    }
}

sub read_file {
    my ($file) = @_;
    local $RS;
    open (my $handle, '<', $file) or die "Can't open $file: $ERRNO";
    my $content = <$handle>;
    close $handle;
    return $content;
}

sub binary {
    my ($string) = @_;
    return pack("C*", map { hex($_) } $string =~ /(..)/g);
}
__DATA__
---
sample1:
  -
    - 00ffffffffffff0006af14a10000000001120103901a10780a50c59858528e2725505400000001010101010101010101010101010101ea1a007e502010303020360005a31000001aea1a007e502010303020360005a31000001a000000fe00593734374480423132314557300000000000000000000000000001010a202000a5
  -
    -
      - EISA_ID: AUOa114
        checksum: 165
        detailed_timings:
          - ModeLine: '"1280x800" 68.9 1280 1328 1360 1406 800 803 809 816 -hsync +vsync'
            ModeLine_comment: '# Monitor preferred modeline (60.1 Hz vsync, 49.0 kHz hsync, ratio 16/10, 124 dpi)'
            digital_composite: 3
            horizontal_active: 1280
            horizontal_blanking: 126
            horizontal_border: 0
            horizontal_dpi: 124.567049808429
            horizontal_image_size: 261
            horizontal_sync_offset: 48
            horizontal_sync_positive: 0
            horizontal_sync_pulse_width: 32
            interlaced: 0
            pixel_clock: 68.9
            preferred: 1
            stereo: 0
            vertical_active: 800
            vertical_blanking: 16
            vertical_border: 0
            vertical_dpi: 124.662576687117
            vertical_image_size: 163
            vertical_sync_offset: 3
            vertical_sync_positive: 1
            vertical_sync_pulse_width: 6
          - ModeLine: '"1280x800" 68.9 1280 1328 1360 1406 800 803 809 816 -hsync +vsync'
            ModeLine_comment: '# Monitor supported modeline (60.1 Hz vsync, 49.0 kHz hsync, ratio 16/10, 124 dpi)'
            digital_composite: 3
            horizontal_active: 1280
            horizontal_blanking: 126
            horizontal_border: 0
            horizontal_dpi: 124.567049808429
            horizontal_image_size: 261
            horizontal_sync_offset: 48
            horizontal_sync_positive: 0
            horizontal_sync_pulse_width: 32
            interlaced: 0
            pixel_clock: 68.9
            stereo: 0
            vertical_active: 800
            vertical_blanking: 16
            vertical_border: 0
            vertical_dpi: 124.662576687117
            vertical_image_size: 163
            vertical_sync_offset: 3
            vertical_sync_positive: 1
            vertical_sync_pulse_width: 6
        diagonal_size: 12.1148583788498
        edid_revision: 3
        edid_version: 1
        established_timings: []
        extension_flag: 0
        feature_support:
          DPMS_active_off: 0
          DPMS_standby: 0
          DPMS_suspend: 0
          GTF_compliance: 0
          has_preferred_timing: 1
          rgb: 0
          sRGB_compliance: 0
        gamma: 120
        manufacturer_name: AUO
        max_size_horizontal: 26.1
        max_size_precision: mm
        max_size_vertical: 16.3
        monitor_details: ''
        monitor_text:
          - "Y747D\x80B121EW0"
        product_code: 41236
        ratio: 1.60122699386503
        ratio_name: 16/10
        ratio_precision: mm
        serial_number: 0
        standard_timings: []
        video_input_definition:
          composite_sync: 0
          digital: 1
          separate_sync: 0
          sync_on_green: 1
          voltage_level: 0
        week: 1
        year: 2008
      - ''
sample2:
  -
    - 00ffffffffffff0006af14a10000000001120103901a10780a50c59858528e2725505400000001010101010101010101010101010101ea1a007e502010303020360005a31000001aea1a007e502010303020360005a31000001a000000fe00593734374480423132314557300000000000000000000000000001010a202000a5
    - 00ffffffffffff0022f0f62601010101181401036e362378eece50a3544c99260f5054a56b8081408180a900a940b300d10001010101283c80a070b023403020360022602100001a000000fc004850204c5032343735770a2020000000fd0030551e5e15000a202020202020000000ff00434e43303234303343500a20200085
  -
    -
      - EISA_ID: AUOa114
        checksum: 165
        detailed_timings:
          - ModeLine: '"1280x800" 68.9 1280 1328 1360 1406 800 803 809 816 -hsync +vsync'
            ModeLine_comment: '# Monitor preferred modeline (60.1 Hz vsync, 49.0 kHz hsync, ratio 16/10, 124 dpi)'
            digital_composite: 3
            horizontal_active: 1280
            horizontal_blanking: 126
            horizontal_border: 0
            horizontal_dpi: 124.567049808429
            horizontal_image_size: 261
            horizontal_sync_offset: 48
            horizontal_sync_positive: 0
            horizontal_sync_pulse_width: 32
            interlaced: 0
            pixel_clock: 68.9
            preferred: 1
            stereo: 0
            vertical_active: 800
            vertical_blanking: 16
            vertical_border: 0
            vertical_dpi: 124.662576687117
            vertical_image_size: 163
            vertical_sync_offset: 3
            vertical_sync_positive: 1
            vertical_sync_pulse_width: 6
          - ModeLine: '"1280x800" 68.9 1280 1328 1360 1406 800 803 809 816 -hsync +vsync'
            ModeLine_comment: '# Monitor supported modeline (60.1 Hz vsync, 49.0 kHz hsync, ratio 16/10, 124 dpi)'
            digital_composite: 3
            horizontal_active: 1280
            horizontal_blanking: 126
            horizontal_border: 0
            horizontal_dpi: 124.567049808429
            horizontal_image_size: 261
            horizontal_sync_offset: 48
            horizontal_sync_positive: 0
            horizontal_sync_pulse_width: 32
            interlaced: 0
            pixel_clock: 68.9
            stereo: 0
            vertical_active: 800
            vertical_blanking: 16
            vertical_border: 0
            vertical_dpi: 124.662576687117
            vertical_image_size: 163
            vertical_sync_offset: 3
            vertical_sync_positive: 1
            vertical_sync_pulse_width: 6
        diagonal_size: 12.1148583788498
        edid_revision: 3
        edid_version: 1
        established_timings: []
        extension_flag: 0
        feature_support:
          DPMS_active_off: 0
          DPMS_standby: 0
          DPMS_suspend: 0
          GTF_compliance: 0
          has_preferred_timing: 1
          rgb: 0
          sRGB_compliance: 0
        gamma: 120
        manufacturer_name: AUO
        max_size_horizontal: 26.1
        max_size_precision: mm
        max_size_vertical: 16.3
        monitor_details: ''
        monitor_text:
          - "Y747D\x80B121EW0"
        product_code: 41236
        ratio: 1.60122699386503
        ratio_name: 16/10
        ratio_precision: mm
        serial_number: 0
        standard_timings: []
        video_input_definition:
          composite_sync: 0
          digital: 1
          separate_sync: 0
          sync_on_green: 1
          voltage_level: 0
        week: 1
        year: 2008
      - ''
    -
      - EISA_ID: HWP26f6
        HorizSync: 30-94
        VertRefresh: 48-85
        checksum: 133
        detailed_timings:
          - ModeLine: '"1920x1200" 154 1920 1968 2000 2080 1200 1203 1209 1235 -hsync +vsync'
            ModeLine_comment: '# Monitor preferred modeline (60.0 Hz vsync, 74.0 kHz hsync, ratio 16/10, 90 dpi)'
            bad_ratio: 1
            digital_composite: 3
            horizontal_active: 1920
            horizontal_blanking: 160
            horizontal_border: 0
            horizontal_dpi: 90.3111111111111
            horizontal_image_size: 546
            horizontal_sync_offset: 48
            horizontal_sync_positive: 0
            horizontal_sync_pulse_width: 32
            interlaced: 0
            pixel_clock: 154
            preferred: 1
            stereo: 0
            vertical_active: 1200
            vertical_blanking: 35
            vertical_border: 0
            vertical_dpi: 87.0857142857143
            vertical_image_size: 352
            vertical_sync_offset: 3
            vertical_sync_positive: 1
            vertical_sync_pulse_width: 6
        diagonal_size: 25.3348827451908
        edid_revision: 3
        edid_version: 1
        established_timings:
          - X: 640
            Y: 480
            vfreq: 60
          - X: 640
            Y: 480
            vfreq: 75
          - X: 720
            Y: 400
            vfreq: 70
          - X: 800
            Y: 600
            vfreq: 60
          - X: 800
            Y: 600
            vfreq: 75
          - X: 832
            Y: 624
            vfreq: 75
          - X: 1024
            Y: 768
            vfreq: 60
          - X: 1024
            Y: 768
            vfreq: 75
          - X: 1280
            Y: 1024
            vfreq: 75
        extension_flag: 0
        feature_support:
          DPMS_active_off: 1
          DPMS_standby: 1
          DPMS_suspend: 1
          GTF_compliance: 0
          has_preferred_timing: 1
          rgb: 0
          sRGB_compliance: 1
        gamma: 120
        manufacturer_name: HWP
        max_size_horizontal: 54
        max_size_precision: cm
        max_size_vertical: 35
        monitor_details: ''
        monitor_name: HP LP2475w
        monitor_range:
          horizontal_max: 94
          horizontal_min: 30
          pixel_clock_max: 210
          vertical_max: 85
          vertical_min: 48
        product_code: 9974
        ratio: 1.55113636363636
        ratio_name: 16/10
        ratio_precision: mm
        serial_number: 16843009
        serial_number2:
          - CNC02403CP
        standard_timings:
          - X: 1280
            Y: 960
            ratio: 4/3
            vfreq: 60
          - X: 1280
            Y: 1024
            ratio: 5/4
            vfreq: 60
          - X: 1600
            Y: 1000
            ratio: 16/10
            vfreq: 60
          - X: 1600
            Y: 1200
            ratio: 4/3
            vfreq: 60
          - X: 1680
            Y: 1050
            ratio: 16/10
            vfreq: 60
          - X: 1920
            Y: 1200
            ratio: 16/10
            vfreq: 60
        video_input_definition:
          composite_sync: 1
          digital: 0
          separate_sync: 1
          sync_on_green: 0
          voltage_level: 2
        week: 24
        year: 2010
      - ''
