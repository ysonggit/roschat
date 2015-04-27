#ifndef ROS_LISTENER_H
#define ROS_LISTENER_H
#include <ros/ros.h>
#include "std_msgs/String.h"
#include <string>
#include <sstream>
using namespace std;
class RosListener{
public:
    RosListener(){
        ros::param::get("~listenerid", id);
        msg_sub = nh.subscribe("talker_msg", 1000, &RosListener::msgCallback, this);
        stringstream ss;
        ss<<id;
        string topic_name = string("listener")+ss.str();
        res_pub = nh.advertise<std_msgs::String>(topic_name, 1000);
    }
    int id;
    ros::NodeHandle nh;
    ros::Subscriber msg_sub;
    ros::Publisher res_pub;
    void msgCallback(const std_msgs::String & );
};
#endif
