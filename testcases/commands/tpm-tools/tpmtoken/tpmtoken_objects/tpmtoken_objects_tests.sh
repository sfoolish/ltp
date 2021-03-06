#! /bin/sh
#
# Copyright (c) International Business Machines  Corp., 2005
#
# This program is free software;  you can redistribute it and#or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program;  if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

setup()
{
	RC=0				# Return code from commands.

	if [ -z "$LTPTMP" ] && [ -z "$TMPBASE" ]
	then
		LTPTMP="/tmp"
	else
		LTPTMP="$TMPBASE"
	fi

	export TPM_TMPFILE="$LTPTMP/tst_tpm.err"
	rm -f $TPM_TMPFILE 2>&1

	# Set known password values
	if [ -z "$P11_SO_PWD" ]
	then
		export P11_SO_PWD="P11 SO PWD"
	fi
	if [ -z "$P11_USER_PWD" ]
	then
		export P11_USER_PWD="P11 USER PWD"
	fi

	tst_resm TINFO "INIT: Inititalizing tests."

	which tpmtoken_objects 1>$TPM_TMPFILE 2>&1 || RC=$?
	if [ $RC -ne 0 ]
	then
		tst_brk TBROK $TPM_TMPFILE NULL \
			"Setup: tpmtoken_objects command does not exist. Reason:"
		return $RC
	fi

	return $RC
}

test01()
{
	RC=0				# Return value from commands
	export TCID=tpmtoken_objects01	# Test ID
	export TST_COUNT=1		# Test number

	tpmtoken_objects_tests_exp01.sh 1>$TPM_TMPFILE 2>&1 || RC=$?
	if [ $RC -eq 0 ]
	then
		tst_resm TPASS "'tpmtoken_objects' passed."
		RC=0
	else
		tst_res TFAIL $TPM_TMPFILE "'tpmtoken_objects' failed."
		RC=1
	fi
	return $RC
}

test02()
{
	RC=0				# Return value from commands
	export TCID=tpmtoken_objects02	# Test ID
	export TST_COUNT=2		# Test number

	tpmtoken_objects -p 1>$TPM_TMPFILE 2>&1 || RC=$?
	if [ $RC -eq 0 ]
	then
		tst_resm TPASS "'tpmtoken_objects -p' passed."
		RC=0
	else
		tst_res TFAIL $TPM_TMPFILE "'tpmtoken_objects -p' failed."
		RC=1
	fi
	return $RC
}

cleanup()
{
	rm -f $TPM_TMPFILE 2>&1
}

# Function:	main
#
# Description:	- Execute all tests, report results.
#
# Exit:		- zero on success
# 		- non-zero on failure.

TFAILCNT=0			# Set TFAILCNT to 0, increment on failure.
RC=0				# Return code from tests.

export TCID=tpmtoken_objects	# Test ID
export TST_TOTAL=2		# Total numner of tests in this file.
export TST_COUNT=0		# Initialize identifier

if [ -n "$TPM_NOPKCS11" ]
then
	tst_resm TINFO "'tpmtoken_objects' skipped."
	exit $TFAILCNT
fi

setup || exit $RC		# Exit if initializing testcases fails.

test01 || TFAILCNT=$(($TFAILCNT+1))
test02 || TFAILCNT=$(($TFAILCNT+1))

cleanup

exit $TFAILCNT
