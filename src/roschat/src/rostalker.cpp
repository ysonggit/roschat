#include "rostalker.h"
using namespace std;

void ListenerAgent::getResponse(const std_msgs::String & res){
    ROS_INFO_STREAM("Get listener "<<id<<" response : "<<res);
}

void RosTalker::talk(){
    std_msgs::String msg;
    std::stringstream ss;
    ss<<"hello listeners, I am the presenter";
    msg.data = ss.str();
    msg_pub.publish(msg);
}

int RosTalker::add(int a, int b){
    return a + b;
}

int main(int argc, char **argv){
    ros::init(argc, argv, "rosTalker");
    RosTalker rt;
    ros::Rate loop_rate(5);
    while(ros::ok()){
        rt.talk();
        ros::spinOnce();
        loop_rate.sleep();
    }
    return 0;
}
