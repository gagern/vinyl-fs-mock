pathUtil = require('path')
File = require('vinyl')
FileSystem = require('./FileSystem')
Readable = require('readable-stream/readable')

class ReadableFSStream extends Readable
  constructor: (@fileSystem, @iterator, basepath) ->
    super
      objectMode: true

    @basepath = if basepath?
                  pathUtil.resolve(@fileSystem.fullpath(), basepath)
                else
                  @fileSystem.fullpath()

  createFile: (path) ->
    new File
      path: path
      base: @basepath
      contents: @fileSystem.readFileAsBuffer(path)  
    
  _read: ->
    path = @iterator.next()    
    
    if path?
      @push @createFile path
    else
      @push null
    
module.exports = ReadableFSStream

FileSystem.prototype.createReadStream = (path) ->
  new ReadableFSStream(this, @createIterator(path), path)