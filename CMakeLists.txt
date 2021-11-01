
cmake_minimum_required(VERSION 3.14)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CONAN_DISABLE_CHECK_COMPILER TRUE)
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/arm-gcc-toolchain.cmake)

project(nordic-conan-template C CXX ASM)


set( NRF_TARGET "nrf52" )
set( NRF52SOFTDEVICE "S112" )
set( SDK_DEPENDENT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/sdk_dependent")
set( NORDIC_TARGET nordic-conan)

add_subdirectory(cmake/nordic_sdk ${CMAKE_BINARY_DIR}/nrfsdk )


if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
      message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
      file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake"
                    "${CMAKE_BINARY_DIR}/conan.cmake"
                    EXPECTED_HASH SHA256=396e16d0f5eabdc6a14afddbcfff62a54a7ee75c6da23f32f7a31bc85db23484
                    TLS_VERIFY ON)

    list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
    list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})

    include(${CMAKE_BINARY_DIR}/conan.cmake)

    conan_cmake_configure(REQUIRES fmt/8.0.1
                          GENERATORS cmake_find_package)

    conan_cmake_autodetect(settings)

    conan_cmake_install(PATH_OR_REFERENCE .
                        BUILD missing
                        REMOTE conancenter
                        SETTINGS ${settings}
                        PROFILE ${PROJECT_SOURCE_DIR}/cmake/arm-none-eabi-toolchain-conan
                        )
    find_package(fmt REQUIRED)
endif()

add_executable(nordic-conan ${PROJECT_SOURCES})
target_sources(
    nordic-conan
    PRIVATE
    main.cpp
)
target_link_libraries(
    nordic-conan PRIVATE
    NordicSDK::Common
    fmt::fmt
)
target_compile_features(
    nordic-conan
    PRIVATE
    cxx_std_20
)
target_compile_options(
    nordic-conan
    PRIVATE
    -O0
    -fcoroutines
    -fnothrow-opt
    -fno-threadsafe-statics
)

set_target_properties( nordic-conan PROPERTIES SUFFIX ".out" )
option( EXECUTE_MCU_FLASHING "Execute binary flashing to target MCU" OFF )
option( CREATE_NORDIC_FIRMWARE "Execute firmware bin and hex files creation" ON )

if( CREATE_NORDIC_FIRMWARE )
    nordicSdk_createBinAndHexFiles( nordic-conan )
endif()

if( EXECUTE_MCU_FLASHING )
    nordicSdk_flashSoftDevice( ${SOFTDEVICE_PATH} ${NRF_TARGET} )
    nordicSdk_flashFirmware( nordic-conan )
endif()