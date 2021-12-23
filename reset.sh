#!/bin/env bash
cd "$HOME/.local/share/nvim/site/pack" && for x in * ; do if [[ $x != "vrighter" ]] ; then rm -rf $x ; fi ; done && cd "vrighter/opt" && for x in * ; do if [[ $x != "toolshed.nvim" ]] ; then rm -rf $x ; fi ; done && cd "toolshed.nvim"
