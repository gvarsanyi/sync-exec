cp = require 'child_process'
fs = require 'fs'


tmp_dir = '/tmp'
for name in ['TMPDIR', 'TMP', 'TEMP']
  tmp_dir = dir.replace /\/$/, '' if (dir = process.env[name])?

create_pipes = ->
  until created
    try
      dir = tmp_dir + '/sync-exec-' + Math.floor Math.random() * 1000000000
      fs.mkdir dir
      created = true
  dir

read_pipes = (dir) ->
  until read
    try
      read = true if fs.readFileSync(dir + '/done').length
  until deleted
    try
      fs.unlinkSync dir + '/done'
      deleted = true

  result = {}
  for pipe in ['stdout', 'stderr', 'status']
    result[pipe] = fs.readFileSync dir + '/' + pipe, encoding: 'utf-8'
    read = true
    fs.unlinkSync dir + '/' + pipe
  fs.rmdirSync dir
  result.status = Number result.status
  result

module.exports = (cmd, options) ->
  dir = create_pipes()
  cmd = '(' + cmd + ' > ' + dir + '/stdout 2> ' + dir + '/stderr ); echo $?' +
        ' > ' + dir + '/status ; echo 1 > ' + dir + '/done'
  cp.exec cmd, options or {}, ->
  read_pipes dir
