package Thingiverse::Pagination;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse::Types;

extends('Thingiverse');

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Category>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Comment>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has page        => ( isa => 'Page',           is => 'ro', required => 0, default => 1 );
has per_page    => ( isa => 'PerPage',        is => 'ro', required => 0, default => $Thingiverse::pagination_maximum );
has pages       => ( isa => 'Page',           is => 'ro', required => 0, );
has total_count => ( isa => 'ThingiCount',    is => 'ro', required => 0, );
has response    => ( isa => 'ThingiResponse', is => 'rw', required => 0, trigger => \&_extract_pagination_links_from_responseHeaders, );
has first_url   => ( isa => 'Str',            is => 'ro', required => 0, );
has last_url    => ( isa => 'Str',            is => 'ro', required => 0, );
has prev_url    => ( isa => 'Str',            is => 'ro', required => 0, );
has next_url    => ( isa => 'Str',            is => 'ro', required => 0, );
# has first_url   => ( isa => 'Str',            is => 'ro', required => 0, builder => '_first_page_url', );
# has last_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _last_page_url', );
# has prev_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _prev_page_url', );
# has next_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _next_page_url', );

sub as_string {
  my $self = shift;
  my ( $page, $per_page, $string );
  if ( $self->page > 1 ) {
    $page = "page=" . $self->page;
  }
  if ( $self->per_page < $Thingiverse::pagination_maximum ) {
    $per_page = "per_page=" . $self->per_page;
  }
  if ( $page || $per_page ) {
    if ( $page && $per_page ) {
      $string = $page . '&' . $per_page;
    } elsif ( $page ) {
      $string = $page;
    } else {
      $string = $per_page;
    }
    return '?' . $string;
  }
  return '';
}

sub _extract_pagination_links_from_responseHeaders {
  my $self = shift;
  my $page;
  my $response = $self->response;
  my $link_header = $response->responseHeader('Link');
  if ($link_header and $link_header =~ /rel=.(first|last|next|prev)/) {
    foreach my $link ( split( /,\s*/, $link_header ) ) {
      my ($page_url, $page_label) = ( $link =~ /<([^>]+)>;\s+rel="([^"]+)"/);
      $self->{$page_label}=$page_url;
	  if ( not $page and $page_label =~ /next/i ) { # if we haven't determined the current page, and have a link for the next page
	    ( $page, ) = ( $page_url =~ /page=(\s+)/ ); # find the next page's number
		$page--;                                    # and subtract 1 to obtain the current page's number
	  }
	  if ( not $page and $page_label =~ /prev/i ) { # if we haven't determined the current page, and have a link for the previous page
	    ( $page, ) = ( $page_url =~ /page=(\s+)/ ); # find the previous page's number
		$page--;                                    # and add 1 to obtain the current page's number
	  }
	  if ( $page_label =~ /last/i ) {
	    ( $self->{pages}, ) = ( $page_url =~ /page=(\d+)/i );
	  }
    }
  }
  $self->{total_count} = $response->responseHeader('Total-Count');
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

