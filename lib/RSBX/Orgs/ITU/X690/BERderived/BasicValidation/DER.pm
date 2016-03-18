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


package RSBX::Orgs::ITU::X690::BERderived::BasicValidation::DER v0.1.0.0;


use strict;
use warnings;


use RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER;


require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( );
our @EXPORT_OK = qw( DER_profile );
our @EXPORT = qw( );


my @precheck_tables =
		(
		$RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER::BER_profile,
		);


our $DER_profile =
		{
		-1 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			0	=> \&ObjectCheck_DER_general_object_precheck,
			1	=> \&ObjectCheck_DER_general_begin_constructed_PASS,
			2	=> \&ObjectCheck_DER_general_finis_constructed_PASS,
			},
		0 =>
			{
			undef	=> \&ObjectCheck_PASS,
			1	=> \&ObjectCheck_DER_Boolean,
			3	=> \&ObjectCheck_DER_BitString,
			4	=> \&ObjectCheck_DER_OctetString,
			9	=> \&ObjectCheck_DER_Real,
			12	=> \&ObjectCheck_DER_UTF8String,
			14	=> \&ObjectCheck_DER_Time,
			17	=> \&ObjectCheck_DER_Set,
			18	=> \&ObjectCheck_DER_NumericString,
			19	=> \&ObjectCheck_DER_PrintableString,
			20	=> \&ObjectCheck_DER_TeletexString,
			21	=> \&ObjectCheck_DER_VideotexString,
			22	=> \&ObjectCheck_DER_IA5String,
			23	=> \&ObjectCheck_DER_UniversalTime,
			24	=> \&ObjectCheck_DER_GeneralizedTime,
			25	=> \&ObjectCheck_DER_GraphicString,
			26	=> \&ObjectCheck_DER_VisibleString,
			27	=> \&ObjectCheck_DER_GeneralString,
			28	=> \&ObjectCheck_DER_UniversalString,
			29	=> \&ObjectCheck_DER_UnrestrictedCharacterString,
			30	=> \&ObjectCheck_DER_BMPString,
			34	=> \&ObjectCheck_DER_Duration,
			},
		1 =>
			{
			undef	=> \&ObjectCheck_PASS,
			},
		2 =>
			{
			undef	=> \&ObjectCheck_PASS,
			},
		3 =>
			{
			undef	=> \&ObjectCheck_PASS,
			},
		};



sub ObjectCheck_PASS
	{
	return ('', undef);
	}


sub ObjectCheck_FAIL
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	return ("FAIL object type: Class: $class TagNumber: $tag_number", undef);
	}


sub ObjectCheck_RESERVED
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	return ("RESERVED object type: Class: $class TagNumber: $tag_number", undef);
	}


sub ObjectCheck_UNIMPLEMENTED
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	return ("UNIMPLEMENTED object type: Class: $class TagNumber: $tag_number", undef);
	}


sub ObjectCheck_DER_general_object_precheck
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;
	my $result = '';

	if ($length_length == 1 && $content_length == -1)
		{
		$result = 'DER object encoding: indefinite length form';
		}
	elsif ($length_length > 1 && $content_length < 128)
		{
		$result ='DER object encoding: length encoding not minimal';
		}
	elsif ($length_length > 2 && unpack('C', substr(${$pdu_ref}, $pdu_start+$tag_length+1, 1)) == 0)
		{
		$result = 'DER object encoding: length encoding not minimal';
		}
	else
		{
#		if (exists($RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER::BER_profile->{$class}) && defined($RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER::BER_profile->{$class}))
#			{
#			my $class_table = $RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER::BER_profile->{$class};
#			if (exists($class_table->{$tag_number}) && defined($class_table->{$tag_number}))
#				{
#				($result, undef) = &{$class_table->{$tag_number}}(@_);
#				}
#			}

		foreach my $table (@precheck_tables)
			{
			if (exists($table->{$class}) && defined($table->{$class}))
				{
				my $class_table = $table->{$class};
				if (exists($class_table->{$tag_number}) && defined($class_table->{$tag_number}))
					{
					($result, undef) = &{$class_table->{$tag_number}}(@_);
					last if $result ne '';
					}
				}
			}
		}

	return ($result, undef);
	}


sub ObjectCheck_DER_general_begin_constructed_PASS
	{
	return ('', undef);
	}


sub ObjectCheck_DER_general_finis_constructed_PASS
	{
	return ('', undef);
	}


sub ObjectCheck_DER_Boolean
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;
	my $result = '';

	if (substr(${$pdu_ref}, $pdu_start+2, 1) ne "\x00" && substr(${$pdu_ref}, $pdu_start+2, 1) ne "\xff")
		{
		$result = 'DER content encoding: Boolean';
		}

	return ($result, undef);
	}


sub ObjectCheck_DER_BitString
	{
	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_OctetString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('DER object encoding: OctetString or Restricted String type', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_DER_Real
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (!$content_length)
		{
		return ('', undef);
		}

	my $byte = unpack('C', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, 1));
	if ($byte & 0xc0 == 0x40)
		{
		return ('', undef);
		}
	elsif ($byte & 0xc0 == 0x00)
		{
		my $nrform = $byte & 0x3f;
		my $nrstring = substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length-1);

		if ($nrform == 3 && $nrstring =~ /^-?[1-9]([0-9]*[1-9])?\.E(\+0|-?[1-9][0-9]*)$/)
			{
			return ('', undef);
			}

		return ('DER content encoding: Real', undef);
		}

	if (!($byte & 0x30) && ($byte & 0xc0))
		{
		return ('DER content encoding: Real', undef);
		}

	my $header_len = 1;
	my $exponent_len = ($byte & 0x03) + 1;
	if (1 < $exponent_len && $exponent_len <= 3)
		{
		my $msbs = unpack('n', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length+1, 2)) & 0xff80;

		if ($msbs == 0 || $msbs == 0xff80)
			{
			return ('DER content encoding: Real', undef);
			}
		}

	if (substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length+$header_len+$exponent_len, 1) eq "\x00"
			|| !(unpack('C', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length+$content_length-1, 1)) & 0x01)
			)
		{
		return ('DER content encoding: Real', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_DER_UTF8String
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_Time
	{
	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_Set
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	return ('', undef);
	}


sub ObjectCheck_DER_NumericString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_PrintableString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_TeletexString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_VideotexString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_IA5String
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_UniversalTime
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('DER object encoding: UniversalTime', undef);	# BUG
		}

	if (substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length)
			!~ /^
				[0-9]{2}					# YY
				(
					02					# MM
					(0[1-9]|[12][0-9])			# DD
				|
					(0[13578]|1[02])			# MM
					(0[1-9]|[12][0-9]|3[01])		# DD
				|
					(0[469]|11)				# MM
					(0[1-9]|[12][0-9]|30)			# DD
				)
				([0-1][0-9]|2[0-3])				# hh
				[0-5][0-9]					# mm
				[0-5][0-9]					# ss
				Z						# UTC
				$/x
			)
		{
		return ('DER content encoding: UniversalTime', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_DER_GeneralizedTime
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('DER object encoding: GeneralizedTime', undef);
		}

	if (substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length)
			!~ /^
				[0-9]{4}					# YYYY
				(
					02					# MM
					(0[1-9]|[12][0-9])			# DD
				|
					(0[13578]|1[02])			# MM
					(0[1-9]|[12][0-9]|3[01])		# DD
				|
					(0[469]|11)				# MM
					(0[1-9]|[12][0-9]|30)			# DD
				)
				([0-1][0-9]|2[0-3])				# hh
				[0-5][0-9]					# mm
				([0-5][0-9]|60)					# ss
				(\.[0-9]*[1-9])?				# .f+
				Z						# UTC
				$/x
			)
		{
		return ('DER content encoding: GeneralizedTime', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_DER_GraphicString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_VisibleString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_GeneralString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_UniversalString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_UnrestrictedCharacterString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_BMPString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_DER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_DER_Duration
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	my $duration = substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length);
	if ($content_length
			&& $duration !~ /T.*T/					# No more than 1 'T'
			&& $duration =~ /^
						(
							T?
							[1-9][0-9]*[YMDHS]
						)*
						(
							(0|[1-9][0-9]*)
							(\.[0-9]*[1-9])?
							[YMDHS]
						)?
						$/x
			)
		{
		foreach my $chunktype (qw(Y M D))
			{
			if ($duration =~ /^(0|[1-9][0-9]*)$chunktype(.*)$/)
				{
				$duration = $2;
				}
			elsif ($duration =~ /^(0|[1-9][0-9]*\.[0-9]+)$chunktype(.*)$/)
				{
				$duration = $3;
				last
				}
			}

		if ($duration =~ /^T(.+)$/)
			{
			$duration = $1;

			foreach my $chunktype (qw(H M S))
				{
				if ($duration =~ /^(0|[1-9][0-9]*)$chunktype(.*)$/)
					{
					$duration = $2;
					}
				elsif ($duration =~ /^(0|[1-9][0-9]*\.[0-9]+)$chunktype(.*)$/)
					{
					$duration = $3;
					last
					}
				}
			}

		if ($duration eq '')
			{
			return ('', undef);
			}
		}

	return ('DER content encoding: Duration', undef);
	}


1;


__END__


=pod

=head1 NAME

RSBX::Orgs::ITU::X690::BERderived::BasicValidation::DER - BasicValidation DER Profile.

=head1 SYNOPSIS

 use RSBX::Orgs::ITU::X690::BERderived::BasicValidation qw( Validate );
 use RSBX::Orgs::ITU::X690::BERderived::BasicValidation::DER qw( DER_profile );
 ...
 my ($result, $object, $start, $end)
         = Validate(\$data, 0, length($data), $DER_profile);
 if ($result ne '')
     {
     print "ERROR: obj=$object start=$start end=$end \"$result\"\n";
     }

=head1 DESCRIPTION

Provides the L<ITU-T Rec. X.690|/SEE ALSO> Distinguished Encoding Rules (DER) profile
for use with RSBX::Orgs::ITU::X690::BERderived::BasicValidation::Validate().

=head1 DIAGNOSTICS

The following types of DER object type encoding validation failure hints are
provided by this profile. Each validation failure hint also identifies the
specific object type encoding(s) that failed the validation.

=over 4

=item * 'DER content encoding:'

The encoded object type content does not conform to that specified in
L<ITU-T Rec. X.690|/SEE ALSO>.

=item * 'DER object encoding:'

The object type encoding does not conform to that specified in
L<ITU-T Rec. X.690|/SEE ALSO>.

=back

This profile is a specialization of the
L<RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER|/SEE ALSO> profile
and may provide validation failure hints from that profile also.

=head1 BUGS AND LIMITATIONS

=over 4

=item * Validators for the following object type encodings are not implemented:

=over 4

=over 4

=item Bit String

=item Object Descriptor

=item External and Instance OF

=item Embedded pdv

=item Time

=back

=back

=item * The ordering of Set and Set-of components is not validated.

=item * The following I<string> object type encodings are treated as an
I<Octet String> encoding and the object type encoding specific restrictions
are not validated:

=over 4

=over 4

=item UTF8 String

=item Numeric String

=item Printable String

=item Teletex String

=item Videotex String

=item IA5 String

=item Graphic String

=item Visible String

=item General String

=item Universal String

=item Unrestricted Character String

=item BMP String

=back

=back

=item * Almost no parameter validation is performed. code wisely.

=back

Please report problems to Raymond S Brand E<lt>rsbx@acm.orgE<gt>.

Problem reports without included demonstration code and/or tests will be ignored.

Patches are welcome.

=head1 SEE ALSO

L<ITU-T Rec. X.690|https://en.wikipedia.org/wiki/X.690>,
L<ITU-T Rec. X.680|https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One>,
L<RSBX::Orgs::ITU::X690::BERderived::BasicValidation>,
L<RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER>

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

