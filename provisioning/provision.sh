#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 2.0
# file-purpose: provisioner configuration
# -----------------------------------------------------------------------------


# ------------------------------------------------
# enable strict mode
# ------------------------------------------------
# Read more about strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/

set -E -uo pipefail
IFS=$'\n    '    


# -----------------------------------------------------------
# provisioner.sh version
# -----------------------------------------------------------

PROVISIONER_VERSION=2.0


# -----------------------------------------------------------
# Debugging
# -----------------------------------------------------------
#
# Uncomment the following line to debug the provisioner script
#

# set -x -v
export PROVISIONER_DEBUG=${PROVISIONER_DEBUG:-}


# -----------------------------------------------------------
# Library mode control variables
# -----------------------------------------------------------

PROVISIONER_LIBRARY=${PROVISIONER_LIBRARY:-}
PROVISIONER_LOG_BASE=${PROVISIONER_LOG_BASE:-}


# ------------------------------------------------
# _psh_print_traceback()
# ------------------------------------------------

function _psh_print_traceback() {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}
  echo "-----------------------------------------------------" >&2
  echo "Traceback (most recent call last):" >&2
  for ((i=FRAMES-2; i>=1; i--)); do
    source=$(sed "${BASH_LINENO[i]}q;d" "${BASH_SOURCE[i+1]}" | sed 's/^ *//g')
    lineno=${BASH_LINENO[i]}
    echo "  File \"${BASH_SOURCE[i+1]}\", line ${lineno}, in ${FUNCNAME[i+1]}" >&2
    echo "    ${source}" >&2
  done
}


# ------------------------------------------------
# _psh_exception_trap
# ------------------------------------------------

function _psh_exception_trap() {
    local exit_code=$1
    local line_no=$2
    local signal_name=$3
    if (( $exit_code != 0 && $exit_code != 177 )); then 
        _psh_print_traceback
        echo "   " >&2
        echo "error in ${BASH_SOURCE[1]} line $line_no, command \`${BASH_COMMAND}\` returned $exit_code" >&2
        echo "   " >&2
        # We need to do this to be able to handle nested errors
    fi
    [[ "$exit_code" == "0" ]] && exit 0
    if [[ "$signal_name" == "ERR" && "$exit_code" == "177" ]]; then
        exit 178
    else
        exit 177
    fi
}


# ------------------------------------------------
# activate exception trap
# ------------------------------------------------

trap '_psh_exception_trap $? ${LINENO} ERR' ERR
trap '_psh_exception_trap $? ??? EXIT' EXIT   # we loose line number info in EXIT trap for some godforsaken reason. :-/


# -----------------------------------------------------------
# _psh_get_caller()
# -----------------------------------------------------------

function _psh_get_caller() {
    local i=${1:-1}
    if [ -z $PROVISIONER_DEBUG ]; then
        local source="${PROVISIONER_LOG_BASE}$(basename ${BASH_SOURCE[i+1]}):${FUNCNAME[i+1]}"
    else
        local source="${PROVISIONER_LOG_BASE}${BASH_SOURCE[i+1]}:${FUNCNAME[i+1]}:${BASH_LINENO[i]}"
    fi
    echo $source
}


# -----------------------------------------------------------
# _psh_log_to_fd()
# -----------------------------------------------------------

function _psh_log_to_fd() {
    local source=$(_psh_get_caller 2)
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
# _psh_log_debug()
# -----------------------------------------------------------

function _psh_log_debug() {
    if [ -z $PROVISIONER_DEBUG ]; then
        return
    fi
    _psh_log_to_fd "DEBUG" "$1"
}

# -----------------------------------------------------------
# _psh_log_info()
# -----------------------------------------------------------

function _psh_log_info() {
    _psh_log_to_fd "INFO" "$1"
}


# -----------------------------------------------------------
# _psh_log_notice()
# -----------------------------------------------------------

function _psh_log_notice() {
    _psh_log_to_fd "NOTICE" "$1"
}


# -----------------------------------------------------------
# _psh_log_warning()
# -----------------------------------------------------------

function _psh_log_warning() {
    _psh_log_to_fd "WARNING" "$1" 1
}

# -----------------------------------------------------------
# _psh_log_error()
# -----------------------------------------------------------

function _psh_log_error() {
    _psh_log_to_fd "ERROR" "$1" 1
}


# -----------------------------------------------------------
# global variables
# -----------------------------------------------------------

export PROVISIONER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ "${PROVISIONER_ROOT}" == "/tmp" ]; then
    PROVISIONER_ROOT=/vagrant/provisioning
fi
export PROVISIONER_MAIN=${PROVISIONER_ROOT}/provision.sh
PROVISIONER_LOADED_MODULES=()
PROVISIONER_ASSETS=${PROVISIONER_ROOT}/assets
PROVISIONER_DEFAULT_CONFIG_FILE=${PROVISIONER_ROOT}/default_config.sh

export PROVISIONER_CONFIG_ROOT=/vagrant
export PROVISIONER_CONFIG_ASSETS_ROOT=${PROVISIONER_CONFIG_ROOT}/assets
export PROVISIONER_CONFIG_CREDENTIALS_ROOT=${PROVISIONER_CONFIG_ROOT}/credentials
export PROVISIONER_CONFIG_FILE=${PROVISIONER_CONFIG_ROOT}/config.sh


# -----------------------------------------------------------
# Internal global variables
# -----------------------------------------------------------

_PROVISIONER_PHASES=(
    configure
    validate
    pre_install
    setup
    verify    
)


# -----------------------------------------------------------
# _psh_execute_as()
# -----------------------------------------------------------

function _psh_execute_as() {
    local env_variables=()
    while getopts "e:" OPT; do
      case $OPT in
        e)  
            env_variables+=("$OPTARG");;
      esac
    done
    shift $((OPTIND-1))
    unset OPTIND
    unset OPTARG
    local user_name=$1
    local script_file=$2
    local module_root="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null && pwd )"
    local source=$(_psh_get_caller)
    local env_variable_passthrough=""
    for variable_name in "${env_variables[@]}"; do
        env_variable_passthrough+="export ${variable_name}=\"\${${variable_name}}\"; "
    done
    local env_variable_passthrough=$(echo "${env_variable_passthrough}" | envsubst)
    _psh_log_debug "source: ${source}"
    _psh_log_debug "user_name: ${user_name}"
    _psh_log_debug "env_variables: ${env_variables[@]}"
    _psh_log_debug "script_file: ${script_file}"
    _psh_log_debug "module_root: ${module_root}"
    _psh_log_debug "env_variable_passthrough: ${env_variable_passthrough}"
    _psh_log_info "executing ${script_file} as ${user_name}..."
    su -l ${user_name} -c "\
        export PROVISIONER_MAIN=${PROVISIONER_MAIN}; \
        export PROVISIONER_LIBRARY=1; \
        export PROVISIONER_LOG_BASE='${source}:_psh_execute_as[${user_name}]:'; \
        export PROVISIONER_MODULE_ROOT='${module_root}'; \
        ${env_variable_passthrough} \
        bash ${module_root}/${script_file} \
    "
}


# -----------------------------------------------------------
# _psh_load_module()
# -----------------------------------------------------------

function _psh_load_module() {
    local module_name=$1
    if [[ $module_name == *".sh" ]]; then
        module_file=$1
        module_name=$(basename $module_name)
        module_name=${module_name::-3}
    else
        module_file="${PROVISIONER_ROOT}/modules/${module_name}.sh"
    fi
    _psh_log_debug "loading module: ${module_name} from ${module_file}"
    if [ ! -f ${module_file} ]; then
        _psh_log_error "module file not found: ${module_file}"
        exit 20
    fi

    source $module_file

    local error_count=0
    for func_name in ${_PROVISIONER_PHASES[*]}; do
        local module_func_name=_psh_${module_name}_${func_name}
        if [ ! -n "$(type -t ${module_func_name})" ] || [ ! "$(type -t ${module_func_name})" = function ]; then
            _psh_log_error "invalid module: ${module_file}: API function not provided by module: ${module_func_name}"
            error_count+=1
        fi    
    done
    if (( error_count > 0)); then
        _psh_log_error "failed to load module: ${module_name}"
        exit 20
    fi
    PROVISIONER_LOADED_MODULES+=(${module_name})
    _psh_log_debug "loaded module: ${module_name}"
}


# -----------------------------------------------------------
# _psh_execute_phase()
# -----------------------------------------------------------

function _psh_execute_phase() {
    local phase_name=$1
    _psh_log_info "============================================================================"
    _psh_log_info "${phase_name}"
    _psh_log_info "============================================================================"
    for module_name in ${PROVISIONER_LOADED_MODULES[*]}; do
        local module_func_name=_psh_${module_name}_${phase_name}
        _psh_log_info "---------------------------------------"
        _psh_log_info "${module_name}:${phase_name}"
        _psh_log_info "---------------------------------------"
        _psh_log_debug "invoking: ${module_func_name}"
        ${module_func_name}
    done
}


# -----------------------------------------------------------
# _psh_main
# -----------------------------------------------------------

_psh_main() {
    _psh_log_info "============================================================================"
    _psh_log_info "Provisioner.sh version ${PROVISIONER_VERSION} initializing..."
    _psh_log_info "============================================================================"
    _psh_log_info "Loading default configuration: ${PROVISIONER_DEFAULT_CONFIG_FILE}"
    source ${PROVISIONER_DEFAULT_CONFIG_FILE}
    _psh_log_debug "PROVISIONER_CONFIG_ROOT: ${PROVISIONER_CONFIG_ROOT}"
    _psh_log_debug "PROVISIONER_CONFIG_FILE: ${PROVISIONER_CONFIG_FILE}"
    _psh_log_debug "PROVISIONER_CONFIG_ASSETS_ROOT: ${PROVISIONER_CONFIG_ASSETS_ROOT}"
    _psh_log_debug "PROVISIONER_CONFIG_CREDENTIALS_ROOT: ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}"
    _psh_log_info "Loading configuration file: ${PROVISIONER_CONFIG_FILE}"
    source ${PROVISIONER_CONFIG_FILE}
    _psh_log_debug "PROVISIONER_ROOT: $PROVISIONER_ROOT"
    _psh_log_debug "PROVISIONER_ENABLED_MODULES: ${PROVISIONER_ENABLED_MODULES[*]}"
    for module_name in ${PROVISIONER_ENABLED_MODULES[*]}; do
        _psh_load_module $module_name
    done
    _psh_log_debug "PROVISIONER_LOADED_MODULES: ${PROVISIONER_LOADED_MODULES[*]}"
    for phase_name in ${_PROVISIONER_PHASES[@]}; do
        _psh_execute_phase $phase_name
    done
    _psh_log_info "Provisioning completted without errors. \o/"
}


# -----------------------------------------------------------
# main invocation
# -----------------------------------------------------------

if [[ -z ${PROVISIONER_LIBRARY} ]]; then
    _psh_main "$@"
fi



