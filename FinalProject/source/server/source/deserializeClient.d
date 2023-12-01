module deserializeClient;

import clientpacket;

ClientPacket deserialize(char[ClientPacket.sizeof] packet){
    ClientPacket depacket;

    if(packet.sizeof < 2){
        return depacket;
    }

    depacket.client_id = packet[0];
    depacket.move_num = packet[1];
    depacket.message = packet[2..82];
    

    return depacket;

}