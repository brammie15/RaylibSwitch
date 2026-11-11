cmake_minimum_required(VERSION 3.22)

# -----------------------------------------------------------------------------
# devkitPro
# -----------------------------------------------------------------------------
if(NOT DEVKITPRO)
    if(DEFINED ENV{DEVKITPRO} AND IS_DIRECTORY "$ENV{DEVKITPRO}/devkitA64")
        file(TO_CMAKE_PATH "$ENV{DEVKITPRO}" DEVKITPRO)
    elseif(CMAKE_HOST_WIN32 AND IS_DIRECTORY "C:/devkitPro/devkitA64")
        set(DEVKITPRO "C:/devkitPro")
    elseif(IS_DIRECTORY "/opt/devkitpro/devkitA64")
        set(DEVKITPRO "/opt/devkitpro")
    else()
        message(FATAL_ERROR "devkitPro not found. Pass -DDEVKITPRO=<path> (e.g. C:/devkitPro).")
    endif()
endif()
set(DEVKITPRO "${DEVKITPRO}" CACHE PATH "devkitPro install root" FORCE)
set(ENV{DEVKITPRO} "${DEVKITPRO}")

if(NOT IS_DIRECTORY "${DEVKITPRO}/portlibs/switch")
    message(FATAL_ERROR "Switch portlibs missing. Install them (msys2/devkitPro shell):\n"
                        "  pacman -S switch-dev switch-mesa switch-libdrm_nouveau")
endif()

# -----------------------------------------------------------------------------
# devkitA64
# -----------------------------------------------------------------------------
list(APPEND CMAKE_MODULE_PATH "${DEVKITPRO}/cmake")
include(dkp-toolchain-common)

set(CMAKE_SYSTEM_NAME NintendoSwitch)
set(DKP_BIN2S_ALIGNMENT 8)
set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_CURRENT_LIST_DIR}/SwitchRuleOverrides.cmake")
__dkp_toolchain(devkitA64 aarch64 aarch64-none-elf)

if(CMAKE_HOST_WIN32)
    file(TO_CMAKE_PATH "$ENV{PATH}" CMAKE_SYSTEM_PROGRAM_PATH)
endif()

# -----------------------------------------------------------------------------
# Switch
# -----------------------------------------------------------------------------
set(NX_ROOT ${DEVKITPRO}/libnx)
set(DKP_INSTALL_PREFIX_INIT ${DEVKITPRO}/portlibs/switch)

__dkp_platform_prefix(
    ${DEVKITPRO}/portlibs/switch
    ${NX_ROOT}
)

find_program(PKG_CONFIG_EXECUTABLE NAMES aarch64-none-elf-pkg-config HINTS "${DEVKITPRO}/portlibs/switch/bin")

set(_dkp_tools "${DEVKITPRO}/tools/bin")
find_program(NX_ELF2NRO_EXE    NAMES elf2nro    HINTS "${_dkp_tools}")
find_program(NX_ELF2KIP_EXE    NAMES elf2kip    HINTS "${_dkp_tools}")
find_program(NX_ELF2NSO_EXE    NAMES elf2nso    HINTS "${_dkp_tools}")
find_program(NX_BUILD_PFS0_EXE NAMES build_pfs0 HINTS "${_dkp_tools}")
find_program(NX_NACPTOOL_EXE   NAMES nacptool   HINTS "${_dkp_tools}")
find_program(NX_NPDMTOOL_EXE   NAMES npdmtool   HINTS "${_dkp_tools}")
find_program(NX_UAM_EXE        NAMES uam        HINTS "${_dkp_tools}")
find_program(NX_NXLINK_EXE     NAMES nxlink     HINTS "${_dkp_tools}")

find_file(NX_DEFAULT_ICON NAMES default_icon.jpg HINTS "${NX_ROOT}" NO_CMAKE_FIND_ROOT_PATH)
