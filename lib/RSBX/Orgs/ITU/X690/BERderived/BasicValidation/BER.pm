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


package RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER v0.1.0.0;


use strict;
use warnings;


require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( );
our @EXPORT_OK = qw( BER_profile );
our @EXPORT = qw( );


our $BER_profile =
		{
		-1 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			0	=> \&ObjectCheck_BER_general_object_precheck_PASS,
			1	=> \&ObjectCheck_BER_general_begin_constructed_PASS,
			2	=> \&ObjectCheck_BER_general_finis_constructed_PASS,
			},
		0 =>
			{
			undef	=> \&ObjectCheck_UNIMPLEMENTED,
			0	=> \&ObjectCheck_BER_EndOfContents,
			1	=> \&ObjectCheck_BER_Boolean,
			2	=> \&ObjectCheck_BER_Integer,
			3	=> \&ObjectCheck_BER_BitString,
			4	=> \&ObjectCheck_BER_OctetString,
			5	=> \&ObjectCheck_BER_Null,
			6	=> \&ObjectCheck_BER_ObjectIdentifier,
			7	=> \&ObjectCheck_UNIMPLEMENTED,
			8	=> \&ObjectCheck_UNIMPLEMENTED,
			9	=> \&ObjectCheck_BER_Real,
			10	=> \&ObjectCheck_BER_Enumerated,
			11	=> \&ObjectCheck_UNIMPLEMENTED,
			12	=> \&ObjectCheck_BER_UTF8String,
			13	=> \&ObjectCheck_BER_RelativeObjectIdentifier,
			14	=> \&ObjectCheck_BER_Time,
			15	=> \&ObjectCheck_RESERVED,
			16	=> \&ObjectCheck_BER_Sequence,
			17	=> \&ObjectCheck_BER_Set,
			18	=> \&ObjectCheck_BER_NumericString,
			19	=> \&ObjectCheck_BER_PrintableString,
			20	=> \&ObjectCheck_BER_TeletexString,
			21	=> \&ObjectCheck_BER_VideotexString,
			22	=> \&ObjectCheck_BER_IA5String,
			23	=> \&ObjectCheck_BER_UniversalTime,
			24	=> \&ObjectCheck_BER_GeneralizedTime,
			25	=> \&ObjectCheck_BER_GraphicString,
			26	=> \&ObjectCheck_BER_VisibleString,
			27	=> \&ObjectCheck_BER_GeneralString,
			28	=> \&ObjectCheck_BER_UniversalString,
			29	=> \&ObjectCheck_BER_UnrestrictedCharacterString,
			30	=> \&ObjectCheck_BER_BMPString,
			31	=> \&ObjectCheck_BER_Date,
			32	=> \&ObjectCheck_BER_TimeOfDay,
			33	=> \&ObjectCheck_BER_DateTime,
			34	=> \&ObjectCheck_BER_Duration,
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


my $BER_contructed_OctetString_check_table =
		{
		-1 =>	$BER_profile->{-1},
		0 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			0	=> \&ObjectCheck_BER_EndOfContents,
			4	=> \&ObjectCheck_BER_OctetString,
			},
		1 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			},
		2 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			},
		3 =>
			{
			undef	=> \&ObjectCheck_FAIL,
			},
		};



sub ObjectCheck_PASS
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

#say join('  ', ($pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length));

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


sub ObjectCheck_BER_general_object_precheck_PASS
	{
#say STDERR 'PRE';
	return ('', undef);
	}


sub ObjectCheck_BER_general_begin_constructed_PASS
	{
#say STDERR 'BEGIN';
	return ('', undef);
	}


sub ObjectCheck_BER_general_finis_constructed_PASS
	{
#say STDERR 'FINIS';
	return ('', undef);
	}


sub ObjectCheck_BER_EndOfContents
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (substr(${$pdu_ref}, $pdu_start, 2) ne "\x00\x00")
		{
		return ('BER object encoding: EndOfContents', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_Boolean
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (substr(${$pdu_ref}, $pdu_start, 2) ne "\x01\x01")
		{
		return ('BER object encoding: Boolean', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_Integer
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;
	my $result = '';

	if ($constructed_flag)
		{
		$result = 'BER object encoding: Integer/Enumerated';
		}
	elsif ($content_length > 4)
		{
		$result = 'Implementation limit exceeded: Integer/Enumerated magnitude';
		}
	elsif ($content_length > 1)
		{
		my $msbs = unpack('n', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, 2)) & 0xff80;

		if ($msbs == 0 || $msbs == 0xff80)
			{
			$result = 'BER content encoding: Integer/Enumerated';
			}
		}
	elsif ($content_length == 0)
		{
		$result = 'BER content encoding: Integer/Enumerated';
		}

	return ($result, undef);
	}


sub ObjectCheck_BER_BitString
	{
	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_OctetString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (!$constructed_flag)
		{
		return ('', undef);
		}

	return ('', $BER_contructed_OctetString_check_table);
	}


sub ObjectCheck_BER_Null
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (substr(${$pdu_ref}, $pdu_start, 2) ne "\x05\x00")
		{
		return ('BER object encoding: Null', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_ObjectIdentifier
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: ObjectIdentifier/RelativeObjectIdentifier', undef);
		}

	my $result = '';
	my $start = 1;
	my $byte = 0;
	for (my $i=$pdu_start+$tag_length+$length_length; $i<$pdu_start+$tag_length+$length_length+$content_length; $i++)
		{
		$byte = unpack('C', substr(${$pdu_ref}, $i, 1));

		if ($byte == 0x80 && $start)
			{
			$result = 'BER content encoding: ObjectIdentifier/RelativeObjectIdentifier subidentifier';
			last
			}
		$start = 0;
		if (!($byte & 0x80))
			{
			$start = 1;
			}
		}
	if (!$start)
		{
		$result = 'BER content encoding: ObjectIdentifier/RelativeObjectIdentifier subidentifier';
		}

	return ($result, undef);
	}


sub ObjectCheck_BER_Real
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: Real', undef);
		}

	if (!$content_length)
		{
		return ('', undef);
		}

	my $byte = unpack('C', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, 1));
	if ($byte & 0xc0 == 0x40)
		{
		return (($content_length == 1 && !($byte & 0x3c)) ? '' : 'BER content encoding: Real', undef);
		}
	elsif ($byte & 0xc0 == 0x00)
		{
		my $nrform = $byte & 0x3f;
		my $nrstring = substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length-1);

		if ($nrform == 1
				&& $nrstring =~ /^ *(\+|-| )?[0-9]+$/
				&& $nrstring !~ /^ *-0+$/
				)
			{
			return ('', undef);
			}
		elsif ($nrform == 2
				&& $nrstring =~ /^ *(\+|-| )?[0-9]*([0-9](\.|,)|(\.|,)[0-9])[0-9]*$/
				&& $nrstring !~ /^ *-0*(0(\.|,)|(\.|,)0)0*$/
				)
			{
			return ('', undef);
			}
		elsif ($nrform == 3
				&& $nrstring =~ /^ *(\+|-| )[0-9]*([0-9](\.|,)|(\.|,)[0-9])[0-9]*E(\+|-)[0-9]+$/
				&& $nrstring !~ /^ *-0*(0(\.|,)|(\.|,)0)0*E(\+|-)[0-9]+$/
				&& $nrstring !~ /^ *(\+| )0*(0(\.|,)|(\.|,)0)0*E(\+|-)0*([1-9]0*)+$/
				)
			{
			return ('', undef);
			}

		return ('BER content encoding: Real', undef);
		}

	if (($byte & 0x30) == 0x30)
		{
		return ('BER content encoding: Real', undef);
		}

	my $header_len = 1;
	my $exponent_len = ($byte & 0x03) + 1;
	if ($exponent_len > 3)
		{
		$header_len++;
		$byte = unpack('C', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length+1, 1));
		if (!$byte)
			{
			return ('BER content encoding: Real', undef);
			}
		$exponent_len = $byte + 1;

		my $msbs = unpack('n', substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length+$header_len, 2)) & 0xff80;

		if ($msbs == 0 || $msbs == 0xff80)
			{
			return ('BER content encoding: Real', undef);
			}
		}

	if ($header_len+$exponent_len >= $content_length)
		{
		return ('BER content encoding: Real', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_Enumerated
	{
	return ObjectCheck_BER_Integer(@_);
	}


sub ObjectCheck_BER_UTF8String
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_RelativeObjectIdentifier
	{
	return ObjectCheck_BER_ObjectIdentifier(@_);
	}


sub ObjectCheck_BER_Time
	{
	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_Sequence
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (!$constructed_flag)
		{
		return ('BER object encoding: Sequence', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_Set
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if (!$constructed_flag)
		{
		return ('BER object encoding: Set', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_NumericString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_PrintableString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_TeletexString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_VideotexString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_IA5String
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_UniversalTime
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('UNIMPLEMENTED form: UniversalTime constructed form unsupported', undef);	# BUG
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
					([0-1][0-9]|2[0-3])			# hh
					[0-5][0-9]				# mm
					([0-5][0-9])?				# ss
				(
					Z					# UTC
				|
					(\+|-)[0-9]{2}([0-9]{2})?		# local offset
				)
				$/x
			)
		{
		return ('BER content encoding: UniversalTime', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_GeneralizedTime
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('UNIMPLEMENTED form: GeneralizedTime constructed form unsupported', undef);	# BUG
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
				(
					([0-1][0-9]|2[0-3])			# hh
					(
						[0-5][0-9]			# mm
						([0-5][0-9]|60)?		# ss
					)?
					((\.|,)[0-9]+)?				# .f+
				|
					24					# hh
					(
						00				# mm
						(00)?				# ss
					)?
					((\.|,)0+)?				# .f+
				)
				(
					Z					# UTC
				|
					(\+|-)[0-9]{2}([0-9]{2})?		# local offset
				)?
				$/x
			)
		{
		return ('BER content encoding: GeneralizedTime', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_GraphicString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_VisibleString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_GeneralString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_UniversalString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_UnrestrictedCharacterString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_BMPString
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

return ObjectCheck_BER_OctetString(@_);

	return ObjectCheck_UNIMPLEMENTED(@_);
	}


sub ObjectCheck_BER_Date
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: Date', undef);
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
				$/x
			)
		{
		return ('BER content encoding: Date', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_TimeOfDay
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: TimeOfDay', undef);
		}

	if (substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length)
			!~ /^
				(
					([0-1][0-9]|2[0-3])			# hh
					[0-5][0-9]				# mm
					[0-5][0-9]				# ss
				|
					24					# hh
					00					# mm
					00					# ss
				)
				$/x
			)
		{
		return ('BER content encoding: TimeOfDay', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_DateTime
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: DateTime', undef);
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
				T						# 'T'
				(
					([0-1][0-9]|2[0-3])			# hh
					[0-5][0-9]				# mm
					[0-5][0-9]				# ss
				|
					24					# hh
					00					# mm
					00					# ss
				)
				$/x
			)
		{
		return ('BER content encoding: DateTime', undef);
		}

	return ('', undef);
	}


sub ObjectCheck_BER_Duration
	{
	my ($state, $pdu_ref, $pdu_start, $pdu_end, $class, $tag_number, $constructed_flag, $tag_length, $length_length, $content_length) = @_;

	if ($constructed_flag)
		{
		return ('BER object encoding: Duration', undef);
		}

	my $duration = substr(${$pdu_ref}, $pdu_start+$tag_length+$length_length, $content_length);
	if ($content_length && $duration !~ /(\.|,)([0-9]*[^0-9]){2}/)
		{
		foreach my $chunktype (qw(Y M D))
			{
			if ($duration =~ /^(0|[1-9][0-9]*)$chunktype(.*)$/)
				{
				$duration = $2;
				}
			elsif ($duration =~ /^(0|[1-9][0-9]*(\.|,)[0-9]+)$chunktype(.*)$/)
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
				elsif ($duration =~ /^(0|[1-9][0-9]*(\.|,)[0-9]+)$chunktype(.*)$/)
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

	return ('BER content encoding: Duration', undef);
	}


1;


__END__


=pod

=head1 NAME

RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER - BasicValidation BER Profile.

=head1 SYNOPSIS

 use RSBX::Orgs::ITU::X690::BERderived::BasicValidation qw( Validate );
 use RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER qw( BER_profile );
 ...
 my ($result, $object, $start, $end)
         = Validate(\$data, 0, length($data), $BER_profile);
 if ($result ne '')
     {
     print "ERROR: obj=$object start=$start end=$end \"$result\"\n";
     }

=head1 DESCRIPTION

Provides the L<ITU-T Rec. X.690|/SEE ALSO> Basic Encoding Rules (BER) profile
for use with RSBX::Orgs::ITU::X690::BERderived::BasicValidation::Validate().

=head1 DIAGNOSTICS

The following types of BER object type encoding validation failure hints are
provided by this profile. Each validation failure hint also identifies the
specifiec object type encoding(s) that failed the validation.

=over 4

=item * 'BER content encoding:'

The encoded object type content does not conform to that specified in
L<ITU-T Rec. X.690|/SEE ALSO>.

=item * 'BER object encoding:'

The object type encoding does not conform to that specified in
L<ITU-T Rec. X.690|/SEE ALSO>.

=item * 'Implementation limit exceeded:'

The encoding exceedes some implemention limit.

=item * 'FAIL object type: Class:'

Validation of an unexpected encoded object type class and tag was requested.
This is most likely caused by a bug in the
RSBX::Orgs::ITU::X690::BERderived::BasicValidation::BER module.

=item * 'RESERVED object type:'

An (purported) encoding for a reserved object type class and tag number was
encountered.

=item * 'UNIMPLEMENTED form:'

An (purported) encoding for an unimplemented form of an object type class and
tag number was encountered.

=item * 'UNIMPLEMENTED object type:'

An (purported) encoding for an object type class and tag number without an
implemented validator was encountered.

=back

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

=item The I<constructed> form of Universal Time

=item The I<constructed> form of Generalized Time

=back

=back

=item * The following I<string> object type encodings are treated as an
I<Octet String> encoding and the object type encoding specifi restrictions
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
L<RSBX::Orgs::ITU::X690::BERderived::BasicValidation>

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

