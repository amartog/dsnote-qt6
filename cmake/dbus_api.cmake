set(dbus_dsnote_interface_file "${PROJECT_BINARY_DIR}/${info_dbus_app_interface}.xml")

configure_file(${dbus_dir}/dsnote.xml.in ${dbus_dsnote_interface_file})

find_package(Qt6 COMPONENTS DBus REQUIRED)

# try several possible executable names and common locations (including /usr/local/bin)
find_program(QDBUSXML2CPP_EXECUTABLE
    NAMES qdbusxml2cpp-qt6 qdbusxml2cpp-qt5 qdbusxml2cpp
    PATHS /usr/local/bin ENV PATH
    NO_DEFAULT_PATH
)

# if not found in /usr/local/bin try system PATH
if(NOT QDBUSXML2CPP_EXECUTABLE)
    find_program(QDBUSXML2CPP_EXECUTABLE
        NAMES qdbusxml2cpp-qt6 qdbusxml2cpp-qt5 qdbusxml2cpp
        PATHS ENV PATH
    )
endif()

if(NOT QDBUSXML2CPP_EXECUTABLE)
    message(FATAL_ERROR "qdbusxml2cpp not found but it is required (tried qdbusxml2cpp-qt6/qdbusxml2cpp-qt5/qdbusxml2cpp in /usr/local/bin and PATH)")
endif()


add_custom_command(
    OUTPUT dbus_dsnote_adaptor.h dbus_dsnote_adaptor.cpp
    COMMAND ${QDBUSXML2CPP_EXECUTABLE} ${info_dbus_app_interface}.xml -m -a dbus_dsnote_adaptor -c DsnoteAdaptor
    DEPENDS ${info_dbus_app_interface}.xml
    COMMENT "generate dbus app adaptor sources"
)

add_custom_command(
    OUTPUT dbus_dsnote_inf.h dbus_dsnote_inf.cpp
    COMMAND ${QDBUSXML2CPP_EXECUTABLE} ${info_dbus_app_interface}.xml -m -p dbus_dsnote_inf -c DsnoteDbusInterface
    DEPENDS ${info_dbus_app_interface}.xml
    COMMENT "generate dbus app inf sources"
)

list(APPEND dsnote_lib_sources
    dbus_dsnote_adaptor.cpp dbus_dsnote_adaptor.h
    dbus_dsnote_inf.cpp dbus_dsnote_inf.h)
