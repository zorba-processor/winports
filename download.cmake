##############################################################################
##############################################################################
#  DOWNLOAD_EXTRACT
##############################################################################
# This function downloads a package from PACKAGE_URL
# and verifies that PACKAGE_MD5 corresponds
# then, if WITH_DIR is set to YES, it creates PACKAGE_NAME directory 
# and extract the content of the downloaded file in this directory
# if WITH_DIR is set to NO, it extracts the file in CMAKE_CURRENT_BINARY_DIR directory
# 
FUNCTION (DOWNLOAD_EXTRACT PACKAGE_NAME FINAL_DESTINATION PACKAGE_URL PACKAGE_MD5 OVERWRITE)
  IF((EXISTS ${FINAL_DESTINATION}) AND (NOT ${OVERWRITE}))
    MESSAGE(STATUS "Package ${PACKAGE_NAME} already in place: ${FINAL_DESTINATION}")
    RETURN()
  ENDIF((EXISTS ${FINAL_DESTINATION}) AND (NOT ${OVERWRITE}))

  MESSAGE(STATUS "Setting up ${PACKAGE_NAME}")

  SET(DOWNLOAD_PACKAGE YES)
  
  IF(WITH_DIR)
    IF(NOT EXISTS ${FINAL_DESTINATION})
      FILE(MAKE_DIRECTORY ${FINAL_DESTINATION})
    ENDIF(NOT EXISTS ${FINAL_DESTINATION})
  ELSE(WITH_DIR)
    SET(FINAL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
  ENDIF(WITH_DIR)
  
  IF (DOWNLOAD_PACKAGE)
    FILE(DOWNLOAD ${PACKAGE_URL} ${FINAL_DESTINATION} SHOW_PROGRESS EXPECTED_MD5 "${PACKAGE_MD5}" )
  ENDIF (DOWNLOAD_PACKAGE)

  IF (EXISTS ${PACKAGE_NAME})
    FILE(MD5 ${PACKAGE_NAME} EXIST_MD5)
    IF (${EXIST_MD5} STREQUAL ${PACKAGE_MD5})
      MESSAGE(STATUS "${PACKAGE_NAME} already downloaded.")
      SET(DOWNLOAD_PACKAGE NO)
    ENDIF (${EXIST_MD5} STREQUAL ${PACKAGE_MD5})
  ENDIF (EXISTS ${PACKAGE_NAME})
  

  MESSAGE(STATUS "Extracting ${PACKAGE_NAME}")
  MESSAGE(STATUS "Extracting ${FINAL_DESTINATION}")
  EXECUTE_PROCESS(
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${PACKAGE_NAME}
    WORKING_DIRECTORY ${FINAL_DESTINATION}
  )
ENDFUNCTION (DOWNLOAD_EXTRACT)

