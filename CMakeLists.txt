cmake_minimum_required(VERSION 3.25)

if(NOT CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/cmake/SwitchToolchain.cmake" CACHE FILEPATH "")
endif()

project(RaylibSwitch VERSION 1.0.0 LANGUAGES C CXX)

set(APP_TITLE  "${PROJECT_NAME}" CACHE STRING "Title shown in the Homebrew Menu")
set(APP_AUTHOR "bram"            CACHE STRING "Author shown in the Homebrew Menu")

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT NINTENDO_SWITCH)
    message(FATAL_ERROR "Configure with cmake/SwitchToolchain.cmake (use a preset: cmake --preset switch-debug)")
endif()

# -----------------------------------------------------------------------------
# raylib-nx (https://github.com/luizpestana/raylib-nx)
# -----------------------------------------------------------------------------
include(FetchContent)

set(PLATFORM       "NX" CACHE STRING "" FORCE)
set(BUILD_EXAMPLES OFF  CACHE BOOL   "" FORCE)

FetchContent_Declare(raylib
    GIT_REPOSITORY https://github.com/luizpestana/raylib-nx.git
    GIT_TAG        9978e718cc92c4cf2548c3c20cb5ebb62a7e9b5e
    GIT_SHALLOW    FALSE
    GIT_PROGRESS   TRUE
    SYSTEM
)
FetchContent_MakeAvailable(raylib)

# -----------------------------------------------------------------------------
# Application
# -----------------------------------------------------------------------------
file(GLOB_RECURSE APP_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_executable(${PROJECT_NAME} ${APP_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE src)
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra)
target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

nx_generate_nacp(${PROJECT_NAME}.nacp
    NAME    "${APP_TITLE}"
    AUTHOR  "${APP_AUTHOR}"
    VERSION "${PROJECT_VERSION}")

nx_create_nro(${PROJECT_NAME}
    NACP  ${PROJECT_NAME}.nacp
    ICON  "${CMAKE_CURRENT_SOURCE_DIR}/icon.jpg"
    ROMFS "${CMAKE_CURRENT_SOURCE_DIR}/romfs")

set(APP_NRO "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.nro")
file(GLOB_RECURSE ROMFS_FILES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/romfs/*")
if(ROMFS_FILES)
    add_custom_command(OUTPUT "${APP_NRO}" APPEND DEPENDS ${ROMFS_FILES})
endif()

set(NXLINK_IP       ""  CACHE STRING "Switch IP address (empty = auto-discover by broadcast)")
set(NXLINK_RETRIES  "3" CACHE STRING "nxlink connection retries")
option(NXLINK_ON_BUILD  "Upload the .nro with nxlink after every build" OFF)
option(NXLINK_REQUIRED  "Fail the build/deploy if nxlink can't reach the Switch" OFF)

set(NXLINK_CMD "${CMAKE_COMMAND}"
    "-DNXLINK=${NX_NXLINK_EXE}"
    "-DNRO=${APP_NRO}"
    "-DNXLINK_IP=${NXLINK_IP}"
    "-DNXLINK_RETRIES=${NXLINK_RETRIES}"
    "-DNXLINK_REQUIRED=${NXLINK_REQUIRED}")
set(NXLINK_SCRIPT -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/nxlink.cmake")

add_custom_target(deploy
    COMMAND ${NXLINK_CMD} -DNXLINK_REQUIRED=ON ${NXLINK_SCRIPT}
    DEPENDS ${PROJECT_NAME}_nro
    COMMENT "Uploading ${PROJECT_NAME}.nro to Switch via nxlink"
    USES_TERMINAL VERBATIM)

add_custom_target(run
    COMMAND ${NXLINK_CMD} -DNXLINK_REQUIRED=ON -DNXLINK_SERVER=ON ${NXLINK_SCRIPT}
    DEPENDS ${PROJECT_NAME}_nro
    COMMENT "Uploading ${PROJECT_NAME}.nro and streaming stdio (Ctrl+C to stop)"
    USES_TERMINAL VERBATIM)

if(NXLINK_ON_BUILD)
    add_custom_target(${PROJECT_NAME}_autodeploy ALL
        COMMAND ${NXLINK_CMD} ${NXLINK_SCRIPT}
        DEPENDS ${PROJECT_NAME}_nro
        COMMENT "Auto-deploying ${PROJECT_NAME}.nro via nxlink"
        VERBATIM)
endif()
