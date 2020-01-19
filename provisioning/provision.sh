#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.15
# file-purpose: provisioner configuration
# -----------------------------------------------------------------------------

set -e

# -----------------------------------------------------------
# Debugging
# -----------------------------------------------------------
#
# Uncomment the following line to debug the provisioner script
#

# set -x -v
DEBUG=

# ------------------------------------------------
# enable strict mode()
# ------------------------------------------------

function _strict-mode() {
    set -euo pipefail
    IFS=$'\n    '    
}


# ------------------------------------------------
# debug-logstack()
# ------------------------------------------------

function debug-logstack() {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}
  # FRAMES-2 skips main, the last one in arrays
  for ((i=FRAMES-2; i>=0; i--)); do
    echo "  File \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]}"
    # Grab the source code of the line
    sed "${BASH_LINENO[i]}q;d" "${BASH_SOURCE[i+1]}"
  done
}


# ------------------------------------------------
# install exception trap
# ------------------------------------------------

if [[ ! -n "${EXCEPTION_TRAP_DISABLED+x}" || -z ${EXCEPTION_TRAP_DISABLED} ]]; then
    trap 'EXIT_CODE=$?
        COMMAND=${BASH_COMMAND}
        #echo "libutils.sh: exit trap: ${COMMAND} exit: ${EXIT_CODE}"
        if (( $EXIT_CODE != 0 && $EXIT_CODE != 100 )); then 
            debug-logstack
            echo -e "\nerror: command \`$COMMAND\` returned $EXIT_CODE${NEWLINE}"
        fi
        exit $EXIT_CODE
        ' EXIT
fi


# ------------------------------------------------
# constants
# ------------------------------------------------

NEWLINE=$'\n'


# -----------------------------------------------------------
# _ups_log_to_fd()
# -----------------------------------------------------------

function _ups_log_to_fd() {
    local i=1
    if [ -z $DEBUG ]; then
        local source="$(basename ${BASH_SOURCE[i+1]}):${FUNCNAME[i+1]}"
    else
        local source="${BASH_SOURCE[i+1]}:${FUNCNAME[i+1]}:${BASH_LINENO[i]}"    
    fi
    local level=$1
    local message=$2
    local to_stderr=${3:-}
    local log_line="$level\t${source}\t${message}"
    if [ -z $to_stderr ]; then
        echo -e "${log_line}"
    else
        echo -e ${log_line} >&2
    fi
}

# -----------------------------------------------------------
# _ups_log_debug()
# -----------------------------------------------------------

function _ups_log_debug() {
    if [ -z $DEBUG ]; then
        return
    fi
    _ups_log_to_fd "DEBUG" "$1"
}

# -----------------------------------------------------------
# _ups_log_info()
# -----------------------------------------------------------

function _ups_log_info() {
    _ups_log_to_fd "INFO" "$1"
}


# -----------------------------------------------------------
# _ups_log_notice()
# -----------------------------------------------------------

function _ups_log_notice() {
    _ups_log_to_fd "NOTICE" "$1"
}


# -----------------------------------------------------------
# _ups_log_warning()
# -----------------------------------------------------------

function _ups_log_warning() {
    _ups_log_to_fd "WARNING" "$1" 1
}

# -----------------------------------------------------------
# _ups_log_error()
# -----------------------------------------------------------

function _ups_log_error() {
    _ups_log_to_fd "ERROR" "$1" 1
}


# -----------------------------------------------------------
# global variables
# -----------------------------------------------------------

PROVISIONER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ "${PROVISIONER_ROOT}" == "/tmp" ]; then
    PROVISIONER_ROOT=/vagrant/provisioning
fi
PROVISIONER_LOADED_MODULES=()
PROVISIONER_ASSETS=${PROVISIONER_ROOT}/assets


# -----------------------------------------------------------
# UPS internal global variables
# -----------------------------------------------------------

_UPS_PHASES=(
    configure
    validate
    pre_install
    setup
    verify    
)


# -----------------------------------------------------------
# _ups_load_module()
# -----------------------------------------------------------

function _ups_load_module() {
    local module_name=$1
    if [[ $module_name == *".sh" ]]; then
        module_file=$1
        module_name=$(basename $module_name)
        module_name=${module_name::-3}
    else
        module_file="${PROVISIONER_ROOT}/modules/${module_name}.sh"
    fi
    _ups_log_debug "loading module: ${module_name} from ${module_file}"
    if [ ! -f ${module_file} ]; then
        _ups_log_error "module file not found: ${module_file}"
        exit 20
    fi

    source $module_file

    local error_count=0
    for func_name in ${_UPS_PHASES[*]}; do
        local module_func_name=_ups_${module_name}_${func_name}
        if [ ! -n "$(type -t ${module_func_name})" ] || [ ! "$(type -t ${module_func_name})" = function ]; then
            _ups_log_error "invalid module: ${module_file}: API function not provided by module: ${module_func_name}"
            error_count+=1
        fi    
    done
    if (( error_count > 0)); then
        _ups_log_error "failed to load module: ${module_name}"
        exit 20
    fi
    PROVISIONER_LOADED_MODULES+=(${module_name})
    _ups_log_debug "loaded module: ${module_name}"
}


# -----------------------------------------------------------
# _ups_load_module()
# -----------------------------------------------------------

function _ups_execute_phase() {
    local phase_name=$1
    _ups_log_info "============================================================================"
    _ups_log_info "${phase_name}"
    _ups_log_info "============================================================================"

    for module_name in ${PROVISIONER_LOADED_MODULES[*]}; do
        local module_func_name=_ups_${module_name}_${phase_name}
        _ups_log_info "---------------------------------------"
        _ups_log_info "${module_name}:${phase_name}"
        _ups_log_info "---------------------------------------"
        _ups_log_debug "invoking: ${module_func_name}"
        ${module_func_name}
    done

}

# -----------------------------------------------------------
# load config
# -----------------------------------------------------------

. /vagrant/provisioning/config.sh


# -----------------------------------------------------------
# main
# -----------------------------------------------------------


main() {
    _ups_log_debug "PROVISIONER_ROOT: $PROVISIONER_ROOT"
    _ups_log_debug "PROVISIONER_ENABLED_MODULES: ${PROVISIONER_ENABLED_MODULES[*]}"
    
    for module_name in ${PROVISIONER_ENABLED_MODULES[*]}; do
        _ups_load_module $module_name
    done

    _ups_log_debug "PROVISIONER_LOADED_MODULES: ${PROVISIONER_LOADED_MODULES[*]}"

    _ups_execute_phase configure

    _ups_execute_phase validate

    _ups_execute_phase pre_install

    _ups_execute_phase setup

    _ups_execute_phase verify

    _ups_log_info "Provisioning completted without errors."

}


# -----------------------------------------------------------
# invocation
# -----------------------------------------------------------

_strict-mode
main "$@"



