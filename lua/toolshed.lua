local M = {
    async = require 'toolshed.async',
    util = {
        string = {
            global = require 'toolshed.util.string.global',
            stream = require 'toolshed.util.string.stream'
        },
        sys = {os_detect = require 'toolshed.util.sys.os-detect'},
        net = {http = require 'toolshed.util.net.http'},
        random = require 'toolshed.util.random',
        generic = {
            queue = require 'toolshed.util.generic.queue',
            pqueue = require 'toolshed.util.generic.pqueue'
        }
    },
    env = require 'toolshed.env',
    plugtool = require 'toolshed.plugtool'
}
return M
