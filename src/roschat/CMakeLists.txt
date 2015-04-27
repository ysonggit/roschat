cmake_minimum_required(VERSION 2.8.3)
set(PROJECT_NAME roschat)
project(${PROJECT_NAME})
set(CMAKE_CXX_FLAGS "-std=c++0x ${CMAKE_CXX_FLAGS}")
find_package(catkin REQUIRED COMPONENTS
  roscpp
  std_msgs
)

include_directories(
  include/${PROJECT_NAME}
  ${catkin_INCLUDE_DIRS}
)
#add_executable(rostalker src/rostalker.cpp)
add_executable(roslistener ${PROJECT_SOURCE_DIR}/src/roslistener.cpp)
target_link_libraries(roslistener
  ${catkin_LIBRARIES} pthread
)
#target_link_libraries(rostalker  ${catkin_LIBRARIES} pthread)
