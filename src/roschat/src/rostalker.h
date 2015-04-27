#ifndef ROS_TALKER_H
#define ROS_TALKER_H

#include <ros/ros.h>
#include "std_msgs/String.h"
#include <sstream>
#include <string>
#include <unordered_map>
using namespace std;
struct ListenerAgent{
    ListenerAgent(int i){
        id = i;
        stringstream ss;
        ss<<id;
        string topic_name = "listener"+ss.str();
        res_sub = nh.subscribe(topic_name, 1000, &ListenerAgent::getResponse, this);
    }
    int id;
    ros::NodeHandle nh;
    ros::Subscriber res_sub;
    void getResponse(const std_msgs::String & res);
};

class RosTalker{
public:
    RosTalker(){
        msg_pub = nh.advertise<std_msgs::String>("talker_msg", 1000);
        ros::param::get("listener_num", listener_num);
        for(int i=1; i<=listener_num; i++){
            ListenerAgent * agent = new ListenerAgent(i);
            agents[i] = agent;
        }
    }
    int listener_num;
    unordered_map<int, ListenerAgent*> agents;
    ros::NodeHandle nh;
    ros::Publisher msg_pub;
    void talk();
    int add(int, int);
};
#endif
