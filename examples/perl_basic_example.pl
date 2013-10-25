$global = "Everywhere";

sub show_it {
  print "Show it: ", $global, "\n";
}

sub mask_it {
  local $global = "Nowhere";
  show_it();
}

show_it();  # => Everywhere
mask_it();  # => Nowhere
  