/*
 * Copyright (c) 2003, Intel Corporation. All rights reserved.
 * Created by:  salwan.searty REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.

 The resulting set shall be the signal set pointed to by set, if the value
 of the argument how is SIG_SETMASK
*/

#include <signal.h>
#include <stdio.h>
#include "posixtest.h"

int handler_called = 0;

void handler(int signo)
{
	handler_called = 1;
}

int main()
{
	struct sigaction act;
	sigset_t blocked_set, pending_set;
	sigemptyset(&blocked_set);
	sigaddset(&blocked_set, SIGABRT);

	act.sa_handler = handler;
	act.sa_flags = 0;
	sigemptyset(&act.sa_mask);
	if (sigaction(SIGABRT,  &act, 0) == -1) {
		perror("Unexpected error while attempting to setup test "
		       "pre-conditions");
		return PTS_UNRESOLVED;
	}

	if (sigprocmask(SIG_SETMASK, &blocked_set, NULL) == -1) {
		perror("Unexpected error while attempting to use sigprocmask.\n");
		return PTS_UNRESOLVED;
	}

	if (raise(SIGABRT) == -1) {
		perror("Unexpected error while attempting to setup test "
		       "pre-conditions");
		return PTS_UNRESOLVED;
	}

	if (handler_called) {
		printf("FAIL: Signal was not blocked\n");
		return PTS_FAIL;
	}

	if (sigpending(&pending_set) == -1) {
		perror("Unexpected error while attempting to use sigpending\n");
		return PTS_UNRESOLVED;
	}

	if (sigismember(&pending_set, SIGABRT) == -1) {
		perror("Unexpected error while attempting to use sigismember.\n");
		return PTS_UNRESOLVED;
	}

	if (sigismember(&pending_set, SIGABRT) != 1) {
		perror("FAIL: sigismember did not return 1\n");
		return PTS_UNRESOLVED;
	}

	printf("Test PASSED: signal was added to the process's signal mask\n");
	return PTS_PASS;
}