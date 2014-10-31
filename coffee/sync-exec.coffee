cp = require 'child_process'
fs = require 'fs'


tmp_dir = '/tmp'
for name in ['TMPDIR', 'TMP', 'TEMP']
  tmp_dir = dir.replace /\/$/, '' if (dir = process.env[name])?

create_pipes = ->
  now=new Date()
  until created
    try
      dir = tmp_dir + '/sync-exec-' + Math.floor Math.random() * 1000000000
      fs.mkdir dir
      created = true
    if (new Date()-now)>1000
      throw new Error("Can't create sync-exec directory")
  dir

read_pipes = (dir, maxWait) ->
  now=new Date()
  until read
    try
      read = true if fs.readFileSync(dir + '/done').length
    if (new Date()-now)>maxWait
      throw new Error("sync-exec Process execution timeout or exit flag read failure.")
  until deleted
    try
      fs.unlinkSync dir + '/done'
      deleted = true
    if (new Date()-now)>maxWait
      throw new Error('Can\'t delete sync-exec exit flag file')

  result = {}
  for pipe in ['stdout', 'stderr', 'status']
    result[pipe] = fs.readFileSync dir + '/' + pipe, encoding: 'utf-8'
    read = true
    fs.unlinkSync dir + '/' + pipe
  fs.rmdirSync dir
  result.status = Number result.status
  result

module.exports = (cmd, options) ->
  maxWait=3600000
  options = options || {}
  if options.maxWait
    maxWait=options.maxWait;
    delete options.maxWait;
  
  dir = create_pipes()
  cmd = '(' + cmd + ' > ' + dir + '/stdout 2> ' + dir + '/stderr ); echo $?' +
        ' > ' + dir + '/status ; echo 1 > ' + dir + '/done'
  cp.exec cmd, options or {}, ->
  read_pipes dir, maxWait
