add_gdal_driver(
  TARGET gdal_JPEGXL
  SOURCES jpegxl.cpp
  CORE_SOURCES jpegxldrivercore.cpp
  PLUGIN_CAPABLE
  NO_SHARED_SYMBOL_WITH_CORE)

function(declare_def DEF)
    if(TARGET gdal_JPEGXL)
        target_compile_definitions(gdal_JPEGXL PRIVATE ${DEF})
    endif()
    if(TARGET gdal_JPEGXL_core)
        target_compile_definitions(gdal_JPEGXL_core PRIVATE ${DEF})
    endif()
endfunction()

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_LIBRARIES ${JXL_LIBRARIES})
check_function_exists(JxlEncoderFrameSettingsSetOption HAVE_JxlEncoderFrameSettingsSetOption)
check_function_exists(JxlEncoderFrameSettingsCreate HAVE_JxlEncoderFrameSettingsCreate)
check_function_exists(JxlEncoderSetFrameDistance HAVE_JxlEncoderSetFrameDistance)
check_function_exists(JxlEncoderSetFrameLossless HAVE_JxlEncoderSetFrameLossless)
check_function_exists(JxlEncoderSetCodestreamLevel HAVE_JxlEncoderSetCodestreamLevel)
check_function_exists(JxlEncoderInitExtraChannelInfo HAVE_JxlEncoderInitExtraChannelInfo)
check_function_exists(JxlDecoderSetDecompressBoxes HAVE_JXL_BOX_API)
check_function_exists(JxlEncoderSetExtraChannelDistance HAVE_JxlEncoderSetExtraChannelDistance)

# This function has been removed per https://github.com/libjxl/libjxl/commit/b08a704978d5aeaf6fd1e2aee3ae5907a89e1f96
# Testing its presence enables us to know if JxlDecoderGetColorAsEncodedProfile()
# and other functions have JxlPixelFormat* argument that has been removed
check_function_exists(JxlDecoderDefaultPixelFormat HAVE_JxlDecoderDefaultPixelFormat)

cmake_pop_check_state()
if (HAVE_JxlEncoderFrameSettingsSetOption)
  declare_def(-DHAVE_JxlEncoderFrameSettingsSetOption)
endif ()
if (HAVE_JxlEncoderFrameSettingsCreate)
  declare_def(-DHAVE_JxlEncoderFrameSettingsCreate)
endif ()
if (HAVE_JxlEncoderSetFrameLossless)
  declare_def(-DHAVE_JxlEncoderSetFrameLossless)
endif ()
if (HAVE_JxlEncoderSetFrameDistance)
  declare_def(-DHAVE_JxlEncoderSetFrameDistance)
endif ()
if (HAVE_JxlEncoderSetCodestreamLevel)
  declare_def(-DHAVE_JxlEncoderSetCodestreamLevel)
endif ()
if (HAVE_JxlEncoderInitExtraChannelInfo)
  declare_def(-DHAVE_JxlEncoderInitExtraChannelInfo)
endif ()
if (HAVE_JXL_BOX_API)
  declare_def(-DHAVE_JXL_BOX_API)
else()
  message(WARNING "This version of libjxl lacks the box API used for EXIF, XMP and georeferencing support. Consider using libjxl from its main branch, post 0.6.1 release.")
endif ()
if (HAVE_JxlEncoderSetExtraChannelDistance)
  declare_def(-DHAVE_JxlEncoderSetExtraChannelDistance)
endif ()
if (HAVE_JxlDecoderDefaultPixelFormat)
  declare_def(-DHAVE_JxlDecoderDefaultPixelFormat)
endif()

if(NOT TARGET gdal_JPEGXL)
    return()
endif()

gdal_standard_includes(gdal_JPEGXL)

# --------------------------
# JPEG-XL integration for GDAL
# --------------------------

# Expect JXL_ROOT to be set: either via -DJXL_ROOT=... or in environment
if(NOT DEFINED JXL_ROOT)
    message(WARNING "JXL_ROOT not defined! Please set -DJXL_ROOT=path_to_jxl")
else()
    message(STATUS "Using JXL_ROOT = ${JXL_ROOT}")

    # Include JXL headers
    target_include_directories(gdal_JPEGXL PRIVATE "${JXL_ROOT}/include")

    # Define JXL_THREADS for both Windows and Linux
    add_definitions(-DHAVE_JXL_THREADS)

    # --------------------------
    # Link JXL static libraries
    # --------------------------
    if(WIN32)
        # On Windows, link all .lib files in JXL lib folder
        file(GLOB JXL_LIBS "${JXL_ROOT}/lib/*.lib")
        if(NOT JXL_LIBS)
            message(WARNING "No JXL .lib files found under ${JXL_ROOT}/lib")
        else()
            foreach(LIB_FILE IN LISTS JXL_LIBS)
                message(STATUS "Linking JXL library (Windows): ${LIB_FILE}")
                gdal_target_link_libraries(gdal_JPEGXL PRIVATE "${LIB_FILE}")
            endforeach()
        endif()
    else()
        # On Linux: explicitly list static libs in correct order
        set(JXL_LIBS
            "${JXL_ROOT}/lib/libjxl.a"
            "${JXL_ROOT}/lib/libjxl_dec.a"
            "${JXL_ROOT}/lib/libjxl_threads.a"
            "${JXL_ROOT}/lib/libbrotlienc-static.a"
            "${JXL_ROOT}/lib/libbrotlidec-static.a"
            "${JXL_ROOT}/lib/libbrotlicommon-static.a"
            "${JXL_ROOT}/lib/libhwy.a"
        )

        foreach(LIB_FILE IN LISTS JXL_LIBS)
            if(EXISTS "${LIB_FILE}")
                message(STATUS "Linking JXL library (Linux): ${LIB_FILE}")
                gdal_target_link_libraries(gdal_JPEGXL PRIVATE "${LIB_FILE}")
            else()
                message(WARNING "Expected JXL library not found: ${LIB_FILE}")
            endif()
        endforeach()
    endif()
endif()
