##==================================================================================================
##                                 Copyright 2015 Joel Falcou
##
##                   Distributed under the Boost Software License, Version 1.0.
##                        See accompanying file LICENSE.txt or copy at
##                            http://www.boost.org/LICENSE_1_0.txt
##==================================================================================================

##==================================================================================================
## if they don't already exist, create a target and all of its logical parents
## e.g. foo.bar.baz.thing -> foo.baz.thing -> foo.thing -> thing
##==================================================================================================
function(add_target_parent target)
  string(REGEX REPLACE "[^.]+\\.([^.]+)$" "\\1" parent_target ${target})
  string(REGEX REPLACE "^.*\\.([^.]+)$" "\\1" suffix ${parent_target})

  if(NOT TARGET ${target})
    add_custom_target(${target})
    set_property(TARGET ${target} PROPERTY FOLDER ${suffix})
  endif()

  if(NOT parent_target STREQUAL ${target})
    add_target_parent(${parent_target})
    add_dependencies(${parent_target} ${target})
  endif()
endfunction()
