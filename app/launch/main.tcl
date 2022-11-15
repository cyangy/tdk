# Copyright (c) 2018 ActiveState Software Inc.
# Released under the BSD-3 license. See LICENSE file for details.
#
# TDK launcher - Windows only
# Dispatches .tdk .tpj to the appropriate tools.

set self [file dirname [file dirname [file dirname [file normalize [info script]]]]]
lappend auto_path [file join $self lib]

package require starkit
starkit::startup
package require app-launch
