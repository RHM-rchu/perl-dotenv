# == Summery: ==
# Load dotenv from 
# 1. parameter passed
# 2. predifined shell or HTTPD `DOTENV_FILE=./_path_to_dotenv` enviroment varaible 
# 3. `.env` in you HTTPD document DOCUMENT_ROOT. Check in your HTTPD document root for `.env`
#
# assign to global $ENV{} hash
#
# == Usage: ==
# Ensure this module is in a search path and...
#
# use DotenvSimple;
# DotenvSimple::source_dotenv();
# # DotenvSimple::list_env();

package DotenvSimple;

use strict;
use base qw(Exporter);
use Carp ();

@DotenvSimple::EXPORT = qw(source_dotenv list_env);

BEGIN {
    $DotenvSimple::VERSION = '0.1.0';
    # $DotenvSimple::DEBUG   = 0 unless (defined $DotenvSimple::DEBUG);
    $DotenvSimple::DEBUG   = $ENV{ PERL_DOTENV_DEBUG } if exists $ENV{ PERL_DOTENV_DEBUG };
}

###################
# load shell style enviroment vaiable, expect full file path as
#
sub source_dotenv {
	my ($my_dotenv_file) = @_;
    my $DOTENV_FILE;
    if ( -e $my_dotenv_file ) {    #defined as an apache var
        $DOTENV_FILE = "$my_dotenv_file";
    }
    elsif ( -e $ENV{DOTENV_FILE} ) {    #defined as an apache var
        $DOTENV_FILE = "$ENV{DOTENV_FILE}";
    }
    elsif ( -e $ENV{DOCUMENT_ROOT} ) {
        $DOTENV_FILE = "$ENV{DOCUMENT_ROOT}/.env";
    }
    else {
        die "ERROR: Could not deterine dotenv location, please pass location as a parameter!";
    }

    $DEBUG::DEBUG and  Carp::carp("In DotenvSimple::source_dotenv processing $DOTENV_FILE");

    open my $fh, "<", $DOTENV_FILE
        or die "could not open $DOTENV_FILE: $!";

FORA: while (<$fh>) {
        chomp;
        my ( $k, $v ) = split /=/, $_, 2;
        $k =~ s/^\s+|\s+$//g;
        $k =~ s/^export[\s\t]+//g;
        $v =~ s/^\s+|\s+$//g;
        $v =~ s/^(['"])(.*)\1/$2/;    #' fix highlighter
        $v =~ s/\$([a-zA-Z]\w*)/$ENV{$1}/g;
        $v =~ s/`(.*?)`/`$1`/ge;      #dangerous
        $v =~ s/[\;\,]$//;
        next FORA if ( $k =~ m/^$/
            || $k =~ m/^\#.*/ );
        $ENV{$k} = $v;
        $DEBUG::DEBUG and  Carp::carp("ENV: $k => $v");
    }
}

sub list_env {
    print "Content-type:text/html\n\n";
    foreach ( sort keys %ENV ) {
        print "$_  =  $ENV{$_}<br />\n";
    }
    exit;
}

