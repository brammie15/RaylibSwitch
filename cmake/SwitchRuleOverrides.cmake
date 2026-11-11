include("${DEVKITPRO}/cmake/dkp-rule-overrides.cmake")

foreach(_lang C CXX)
    set(CMAKE_${_lang}_STANDARD_INCLUDE_DIRECTORIES "${NX_ROOT}/include;${DEVKITPRO}/portlibs/switch/include")
endforeach()

set(_nx_specs "${CMAKE_BINARY_DIR}/CMakeFiles/switch.specs")
if(NOT EXISTS "${_nx_specs}")
    file(READ "${DEVKITPRO}/libnx/switch.specs" _specs)
    string(REPLACE "%:getenv(DEVKITPRO /libnx/switch.ld)" "${DEVKITPRO}/libnx/switch.ld" _specs "${_specs}")
    file(WRITE "${_nx_specs}" "${_specs}")
endif()
string(REPLACE "-specs=${DEVKITPRO}/libnx/switch.specs" "-specs=${_nx_specs}"
       CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")
