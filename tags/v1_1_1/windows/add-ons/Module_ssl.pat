VPAT      q�mI�j5  �B    $my $can_read;

            $can_read = ( ( $handle !~ /socket/i ) && ( $^O eq 'MSWin32' ) );

            if ( !$can_read ) {
                if ( $handle =~ /ssl/i ) {
                    # If using SSL, check internal buffer of OpenSSL first.
                    $can_read = ( $handle->pending() > 0 );
                }
                if ( !$can_read ) {
                    $can_read = defined( $slurp_data__{"$handle"}{select}->can_read( $self->global_config_( 'timeout' ) ) );
                }
            }
 
            if ( $can_read ) {! �C  