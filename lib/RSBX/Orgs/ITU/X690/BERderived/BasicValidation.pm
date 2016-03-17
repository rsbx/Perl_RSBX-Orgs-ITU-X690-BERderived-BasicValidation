#!/usr/bin/perl

#  Copyright (c) 2016, Raymond S Brand
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#
#   * Redistributions in source or binary form must carry prominent
#     notices of any modifications.
#
#   * Neither the name of Raymond S Brand nor the names of its other
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
#  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
#  COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
#  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.


package RSBX::Orgs::ITU::X690::BERderived::BasicValidation v0.1.0.1;


use strict;
use warnings;


use RSBX::Orgs::ITU::X690::BERderived::Common qw( ObjectHeaderValidate ObjectHeaderDecode ) ;


require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( );
our @EXPORT_OK = qw( Validate );
our @EXPORT = qw( );


sub _find_checker
	{
	my ($tables_ref, $class, $tag_number) = @_;
	my $checker = sub {return ("INVOCATION: Validation code not found: class=$class tag=$tag_number", undef);};

	if (exists($tables_ref->{$class}) && defined($tables_ref->{$class}))
		{
		my $class_table = $tables_ref->{$class};
		if (exists($class_table->{$tag_number}) && defined($class_table->{$tag_number}))
			{
			$checker = $class_table->{$tag_number};
			}
		elsif (exists($class_table->{undef}) && defined($class_table->{undef}))
			{
			$checker = $class_table->{undef};
			}
		}
	return $checker;
	}


sub Validate
	{
	my ($pdu_ref, $start, $end, $profile_ref, %state, ) = @_;
	my $current_pos = $start;
	my $result;

	if ($start > $end)
		{
		return ('INVOCATION: Start after end', $current_pos, $start, $end);
		}

	my @context = ();
	push @context, [ $start, $end, $profile_ref, 0, ];

	while (scalar(@context))
		{
		my ($pdu_start, $pdu_end, $tables_ref, $indefinite_flag) = @{pop @context};
		my $pre_check = _find_checker($tables_ref, -1, 0);

		while ($current_pos < $pdu_end)
			{
			my ($new_tables_ref, $object_pdu_end);
			my ($class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length);

			($class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = ObjectHeaderDecode($pdu_ref, $current_pos, $pdu_end);
			if (!defined($class))
				{
				return ('DATA: Incomplete or damaged', $current_pos, $pdu_start, $pdu_end);
				}
			if ($content_length < 0 && $length_length > 1)
				{
				return ('IMPLEMENTATION: Content size limit exceeded', $current_pos, $pdu_start, $pdu_end);
				}
			if ($content_length >= 0 && $current_pos + $tag_length + $length_length + $content_length > $pdu_end)
				{
				return ('DATA: Nested objects exceed outer object size', $current_pos, $pdu_start, $pdu_end);
				}

			$object_pdu_end = ($content_length < 0) ? $pdu_end : $current_pos + $tag_length + $length_length + $content_length;
			if ((($result) = &{$pre_check}(\%state, $pdu_ref, $current_pos, $object_pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length))[0] ne ''
					|| (($result, $new_tables_ref) = &{_find_checker($tables_ref, $class, $tag_number)}(\%state, $pdu_ref, $current_pos, $object_pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length))[0] ne '')
				{
				return ($result, $current_pos, $pdu_start, $pdu_end);
				}

			if (!$class && !$tag_number)
				{
				if (!$indefinite_flag)
					{
					return ('DATA: Spurious EndOfContents', $current_pos, $pdu_start, $pdu_end);
					}
				$current_pos += $tag_length + $length_length + $content_length;
				last;
				}

			if (!$constructed_flag)
				{
				$current_pos += $tag_length + $length_length + $content_length;
				}
			else
				{
				if ($result = (&{_find_checker($tables_ref, -1, 1)}(\%state, $pdu_ref, $current_pos, $pdu_end, 0, -1, 0, 0, 0, 0))[0] ne '')
					{
					return ($result, $current_pos, $pdu_start, $pdu_end);
					}
				push @context, [ $pdu_start, $pdu_end, $tables_ref, $indefinite_flag, ];
				$pdu_start = $current_pos;
				$pdu_end = $object_pdu_end;
				$current_pos += $tag_length + $length_length;
				$indefinite_flag = ($length_length == 1 && $content_length == -1) ? 1 : 0;
				if (defined $new_tables_ref)
					{
					$tables_ref = $new_tables_ref;
					}
				}
			}

		if ($result = (&{_find_checker($tables_ref, -1, 2)}(\%state, $pdu_ref, $current_pos, $pdu_end, 0, -1, 0, 0, 0, 0))[0] ne '')
			{
			return ($result, $current_pos, $pdu_start, $pdu_end);
			}
		}

	return ('', $current_pos, $start, $end);
	}


1;


__END__


=pod

=head1 NAME

RSBX::Orgs::ITU::X690::BERderived::BasicValidation - Basic validation of BER derived encodings.

=head1 SYNOPSIS

 use RSBX::Orgs::ITU::X690::BERderived::BasicValidation;
 ...
 my ($result, $object, $start, $end)
         = Validate(\$data, 0, length($data), \%profile);
 if ($result ne '')
     {
     print "ERROR: obj=$object start=$start end=$end \"$result\"\n";
     }

=head1 DESCRIPTION

Provides functions for basic validation of BER derived encoded data using
profilesi to validate specific encoding derivations.

=head1 FUNCTIONS

=over 4

=item Validate( I<data_REF>, I<start_offset>, I<end_offset>, I<validation_profile>, [ OPTIONS ] )

Determine if an octet sequence is a valid encoding of a specified BER derived encoding.

=over 4

=item PARAMETERS

=over 4

=over 4

=item I<data_REF>

Reference to the buffer (string) containing the encoding to validate.

=item I<start_offset>

Offset into the data buffer where the encoding to validate begins.

=item I<end_offset>

Offset into the data buffer where the encoding to validate ends.
The length of the encoding to validate is C<I<end_offset> - I<start_offset>>.

=item I<validation_profile>

The encoding validation profile to use to validate the encoding.
See L</VALIDATION PROFILE REQUIREMENTS> for details.

=back

=back

=item OPTIONS

Name/value pair paramters passed to the validation profile code.

=item RETURNS

An I<ARRAY> containing:

=over 4

=over 4

=item I<hint_string>

The I<empty string> if no issues were identified; otherwise, a I<string>
containing a hint as to why the data did not validate.

=item I<position_offset>

Offset into the data buffer of the object that did not validate or the last
object checked if no issues were identified. For I<constructed> object types,
this may be the last (sub)part of the object that did not validate.

=item I<start_offset>

Offset into the data buffer where the I<enclosing> encoding begins.

=item I<end_offset>

Offset into the data buffer where the I<enclosing> encoding ends, if known.

=back

=back

=back

=back

=head1 VALIDATION PROFILE REQUIREMENTS

A I<validation profile> is implemented as a 2 level I<hash REF>.
The keys for the first level are object type class values.
The keys for the second level are object type tag values.
There may also be a special second level hash entry with the key C<undef> that
will match any object type tag value, with the object type class value of the
second level hash, for which a hash key does not exist.

The second level hash values are I<code REFs> for object type encoding
validators that determine if the an encoded object type conforms the to the
expected encoding.

=over 4

Each object type encoding validator takes following paramters:

=over 4

=over 4

=item state

A I<hash REF> with the name/value pairs provided to C<Validate()> and any
other data that the is to persist between validator executions during a
C<Validate()> execution.

=item data_REF

Reference to the buffer (string) containing the encoding to validate.

=item start_offset

Offset into the data buffer where the encoding to validate begins.

=item end_offset

Offset into the data buffer where the encoding to validate ends.
The length of the encoding to validate is C<I<end_offset> - I<start_offset>>.

=item class_number

The class number of the object type encoding.

=item tag_number

The tag number of the object type encoding.

=item constructed_flag

Will be I<true> of the object is not I<primative>.

=item tag_length

The length of the I<tag> information in the object type encoding header.

=item length_length

The length of the object content length information in the object type encoding header.

=item content_length

The length of the object content or C<-1> if the object was encoded using the
I<indefinite form>.

=back

=back

Each object type encoding validator returns an I<ARRAY> containing:

=over 4

=over 4

=item hint_string

The I<empty string> if no issues were identified; otherwise, a I<string>
containing a hint as to why the data did not validate.

=item validation_profile

The encoding validation profile to use to validate component (nested) encodings.
This value is ignored if the object type encoding was not I<constructed>.

=back

=back

=back

There is also a set of special set of validators with a first level hash entry
with the key C<-1>.

=over 4

In this set, the following entries are expected:

=over 4

=over 4

=item C<0>

This validator will be called for all object type encodings before the more
specific validator is called.

=item C<1>

This validator will be called for all I<constructed> object type encodings
after the more specific validator is called.

=item C<2>

This validator is called after all of the component object type encodings of
an enclosing (I<constructed>) object type encoding have been validated.
If the enclosing (I<constructed>) object type encoding used the I<indefinite>
length form, this validator will be called after the validators for the
End-of-Contents object type encoding.

=back

=back

And the following entry is permitted:

=over 4

=over 4

=item C<undef>

This validator will be called for any more specific entry that does not exist.

=back

=back

=back

See L<ITU-T Rec. X.690|/SEE ALSO> for information on object type class and tag
values.

=head1 DIAGNOSTICS

In addition to the dignostics from the I<validation profile> used, the following
may be returned:

=over 4

=item * 'DATA: Incomplete or damaged'

C<RSBX::Orgs::ITU::X690::BERderived::Common::ObjectHeaderDecode()> was unable
to decode the object type header.
See L<RSBX::Orgs::ITU::X690::BERderived::Common|/SEE ALSO> for more information.

=item * 'DATA: Nested objects exceed outer object size'

A component object type encoding extends past the end of the enclosing object
type encoding.
See L<ITU-T Rec. X.690|/SEE ALSO>.

=item * 'DATA: Spurious EndOfContents'

An End-of-Contents object type was found where none were expected.
See L<ITU-T Rec. X.690|/SEE ALSO>.

=item * 'IMPLEMENTATION: Content size limit exceeded'

Content length value exceeded implemetation limits.
See L<RSBX::Orgs::ITU::X690::BERderived::Common|/SEE ALSO>.

=item * 'INVOCATION: Start after end'

C<Validate()> called with C<I<start_offset> E<gt> I<end_offset>>.

=item * 'INVOCATION: Validation code not found:'

A class and tag pair was found without a corresponding validation profile entry.
See L</VALIDATION PROFILE REQUIREMENTS> for more information.

=back

=head1 BUGS AND LIMITATIONS

=over 4

=item * This is not an ASN.1 based encoding validator. In other words, the
application or protocol specific encoding requirements and expectations are
not known. The validations performed are entirely based on the requirements
of L<ITU-T Rec. X.690|/SEE ALSO> and the I<validation profile> used.

=item * The size of the data to validate is limited by the amount of memory
available.

=item * The quality of the validation performed is determined by the quality
of the I<validation profile> implementation used.

=item * Tag values may be limited by limitations of
L<RSBX::Orgs::ITU::X690::BERderived::Common|/SEE ALSO>.

=item * Content length values may be limited by limitations of
L<RSBX::Orgs::ITU::X690::BERderived::Common|/SEE ALSO>.

=item * Almost no parameter validation is performed. Code wisely.

=back

Please report problems to Raymond S Brand E<lt>rsbx@acm.orgE<gt>.

Problem reports without included demonstration code and/or tests will be ignored.

Patches are welcome.

=head1 SEE ALSO

L<ITU-T Rec. X.690|https://en.wikipedia.org/wiki/X.690>,
L<ITU-T Rec. X.680|https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One>,
L<RSBX::Orgs::ITU::X690::BERderived::Common>

=head1 AUTHOR

Raymond S Brand E<lt>rsbx@acm.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2016 Raymond S Brand. All rights reserved.

=head1 LICENSE

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

=over 4

=item *

Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

=item *

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in
the documentation and/or other materials provided with the
distribution.

=item *

Redistributions in source or binary form must carry prominent
notices of any modifications.

=item *

Neither the name of Raymond S Brand nor the names of its other
contributors may be used to endorse or promote products derived
from this software without specific prior written permission.

=back

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

=cut

