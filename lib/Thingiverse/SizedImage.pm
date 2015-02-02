package Thingiverse::SizedImage;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse::Types;

has url   => ( isa => 'Str',                  is => 'ro', required => 0, );
has type  => ( isa => 'ThingiverseImageType', is => 'ro', required => 0, );
has size  => ( isa => 'ThingiverseImageSize', is => 'ro', required => 0, );

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Category>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

from images attribute of Thingiverse::Image
  sizes: [15]
  0:  {
    type: "thumb"
    size: "large"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_large.jpg"
  }-
  1:  {
    type: "thumb"
    size: "medium"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_medium.jpg"
  }-