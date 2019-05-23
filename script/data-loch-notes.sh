#!/bin/bash
# Script to upload advising notes, topics, and attachment data to Data Loch S3.

# Make sure the normal shell environment is in place, since it may not be
# when running as a cron job.
source "$HOME/.bash_profile"

cd $( dirname "${BASH_SOURCE[0]}" )/..

LOG=`date +"$PWD/log/data_loch_l_and_s_%Y-%m-%d.log"`
LOGIT="tee -a $LOG"

# Enable rvm and use the correct Ruby version and gem set.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
source .rvmrc

export RAILS_ENV=${RAILS_ENV:-production}
export LOGGER_STDOUT=only
export LOGGER_LEVEL=INFO
export JRUBY_OPTS="--dev"

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "`date`: About to run the Data Loch Advising Notes script..." | $LOGIT

cd deploy

bundle exec rake data_loch:notes | $LOGIT
