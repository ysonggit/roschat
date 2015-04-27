#include "roslistener.h"

void RosListener::msgCallback(const std_msgs::String & msg){
    ROS_INFO_STREAM("I hear from talker: "<< msg.data.c_str());
    std_msgs::String response;
    stringstream ss;
    ss<<id;
    response.data = string("Listener ")+ss.str()+string(" responses: Msg received");
    res_pub.publish(response);
}

int main(int argc, char **argv){
    ros::init(argc, argv, "rosListener");
    RosListener rl;
    ros::spin();
    return 0;
}
