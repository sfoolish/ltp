  /*
 * Copyright (c) 2002, Intel Corporation. All rights reserved.
 * Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.

  Test that CLOCKS_PER_SEC is defined
  */

#include <time.h>

#ifndef CLOCKS_PER_SEC
#error CLOCKS_PER_SEC not defined
#endif