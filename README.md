sync-exec
=========

An fs.execSync replacement until you get it natively from node 0.12+
Inspired by [sync-exec](https://www.npmjs.org/package/exec-sync) but comes with a few advantages:
- no libc requirement (no node-gyp compilation)
- no external dependencies
- returns the exit status code

# Installation
    [sudo] npm install sync-exec

# Usage
    var exec = require('sync-exec');

    console.log(exec('echo 1'));
    # { stdout: '1\n',
    #   stderr: '',
    #   status: 0 }
