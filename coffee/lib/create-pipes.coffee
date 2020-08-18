
fs = require 'fs'

timeout = require './timeout'


# creates tmp files to pipe process info
#
# @return String path to tmp directory

module.exports = ->

  t_limit = Date.now() + 1000 # 1 second timeout

  tmp_dir = '/tmp'
  for name in ['TMPDIR', 'TMP', 'TEMP']
    tmp_dir = dir.replace /\/$/, '' if (dir = process.env[name])?

  until created
    try
      dir = fs.mkdtemp tmp_dir + '/sync-exec-'
      created = true

    timeout t_limit, 'Can not create sync-exec directory'

  # return process-tracking dir name
  dir
