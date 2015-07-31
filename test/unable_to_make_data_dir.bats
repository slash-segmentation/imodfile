#!/usr/bin/env bats


# 
# Load the helper functions in test_helper.bash 
# Note the .bash suffix is omitted intentionally
# 
load test_helper

#
# Test to run is denoted with at symbol test like below
# the string after is the test name and will be displayed
# when the test is run
#
# This test is as the test name states a check when everythin
# is peachy.
#
@test "Test where unable to make data dir" {

  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/foo"
  echo "hi" > "$THE_TMP/foo/some.mod"
  touch "$THE_TMP/data"
  # Run kepler.sh
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -imodfile "$THE_TMP/foo" -CWS_outputdir $THE_TMP $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # will only see this if kepler fails
  echoArray "${lines[@]}"
  

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  # Will be output if anything below fails
  cat "$THE_TMP/$README_TXT"

  # Verify we did not get a WORKFLOW.FAILED.txt file
  [ -e "$THE_TMP/$WORKFLOW_FAILED_TXT" ]

  # Verify we got a README.txt
  [ -s "$THE_TMP/$README_TXT" ]

  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"

  # Check read me header
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "simple.error.message=Unable to create directory" ]
  [[ "${lines[1]}" == "detailed.error.message=Caught exception trying to make $THE_TMP/data : "* ]]
  
  # Check we got a workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]

}
 
