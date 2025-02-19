function(determine_version VER_FILE_NAME)
    file(READ ${VER_FILE_NAME} ETL_VERSION_RAW)
    # Remove trailing whitespaces and/or newline
    string(STRIP ${ETL_VERSION_RAW} ETL_VERSION)
    set(ETL_VERSION ${ETL_VERSION} CACHE STRING
        "ETL version determined from version.txt"
    )
    message(STATUS "Determined ETL version ${ETL_VERSION} from version.txt file")
endfunction()

function(determine_version_with_git)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/GetGitRevisionDescription.cmake)
    git_describe(VERSION ${ARGN})
    string(FIND ${VERSION} "." VALID_VERSION)
    if(VALID_VERSION EQUAL -1)
        message(WARNING "Version string ${VERSION} retrieved with git describe is invalid")
        return()
    endif()
    message(STATUS ${VERSION})
    # Parse the version information into pieces.
    string(REGEX REPLACE "^([0-9]+)\\..*" "\\1" VERSION_MAJOR "${VERSION}")
    string(REGEX REPLACE "^[0-9]+\\.([0-9]+).*" "\\1" VERSION_MINOR "${VERSION}")
    string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" VERSION_PATCH "${VERSION}")
    string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.[0-9]+(.*)" "\\1" VERSION_SHA1 "${VERSION}")
    set(ETL_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

    set(ETL_VERSION ${ETL_VERSION} CACHE STRING
        "ETL version determined from version.txt"
    )
    message(STATUS "Determined ETL version ${ETL_VERSION} from the git tag")
endfunction()
