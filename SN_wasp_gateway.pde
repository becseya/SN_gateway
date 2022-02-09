/*
    ------ WIFI Example --------

    Explanation: This example shows how to set up a TCP client connecting
    to a MQTT broker  (based on WIFI_PRO example from Libelium)

    Máster IoT-UPM

    Version:           1.0
*/

// Put your libraries here (#include ...)
#include <WaspFrame.h>
#include <WaspWIFI_PRO.h>

#include <Countdown.h>
#include <FP.h>
#include <MQTTFormat.h>
#include <MQTTLogging.h>
#include <MQTTPacket.h>
#include <MQTTPublish.h>
#include <MQTTSubscribe.h>
#include <MQTTUnsubscribe.h>

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET1;
///////////////////////////////////////

// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "18.193.126.219"; // broker.hivemq.com
char REMOTE_PORT[] = "1883";           // MQTT
char LOCAL_PORT[]  = "3000";
///////////////////////////////////////

uint8_t       error;
uint8_t       status;
unsigned long previous;
uint16_t      socket_handle = 0;

uint16_t ciclo = 0;

bool socketOpen = false;

void setup()
{
    USB.println(F("Start program"));
}

void loop()
{
    ciclo++;

    if (!socketOpen) {
        //////////////////////////////////////////////////
        // 1. Switch ON
        //////////////////////////////////////////////////
        error = WIFI_PRO.ON(socket);

        if (error == 0) {
            USB.println(F("1. WiFi switched ON"));
        } else {
            USB.println(F("1. WiFi did not initialize correctly"));
        }

        //////////////////////////////////////////////////
        // 2. Check if connected
        //////////////////////////////////////////////////

        // get actual time
        previous = millis();

        // check connectivity
        status = WIFI_PRO.isConnected();

        // check if module is connected
        if (status == true) {
            USB.print(F("2. WiFi is connected OK"));
            USB.print(F(" Time(ms):"));
            USB.println(millis() - previous);

            // get IP address
            error = WIFI_PRO.getIP();

            if (error == 0) {
                USB.print(F("IP address: "));
                USB.println(WIFI_PRO._ip);
            } else {
                USB.println(F("getIP error"));
            }
        } else {
            USB.print(F("2. WiFi is connected ERROR"));
            USB.print(F(" Time(ms):"));
            USB.println(millis() - previous);
        }

        //////////////////////////////////////////////////
        // 3. TCP
        //////////////////////////////////////////////////

        // Check if module is connected
        if (status == true) {

            ////////////////////////////////////////////////
            // 3.1. Open TCP socket
            ////////////////////////////////////////////////
            error = WIFI_PRO.setTCPclient(HOST, REMOTE_PORT, LOCAL_PORT);

            LOCAL_PORT[3]= (LOCAL_PORT[3] == '9') ? '0': (LOCAL_PORT[3]+1);

            // check response
            if (error == 0) {
                // get socket handle (from 0 to 9)
                socket_handle = WIFI_PRO._socket_handle;

                USB.print(F("3.1. Open TCP socket OK in handle: "));
                USB.println(socket_handle, DEC);
                socketOpen = true;
            } else {
                USB.println(F("3.1. Error calling 'setTCPclient' function"));
                WIFI_PRO.printErrorCode();
                status = false;
            }
        }
    }

    if (socketOpen) {
        static bool socketWasOpen = false;

        /// Publish MQTT
        MQTTPacket_connectData data        = MQTTPacket_connectData_initializer;
        MQTTString             topicString = MQTTString_initializer;
        unsigned char          buf[200];
        int                    buflen = sizeof(buf);
        unsigned char          payload[100];

        // options
        data.clientID.cstring  = (char*)"mt1";
        data.keepAliveInterval = 30;
        data.cleansession      = 1;
        int len                = 0;

        if (!socketWasOpen)
            len = MQTTSerialize_connect(buf, buflen, &data); /* 1 */

        // Topic and message
        topicString.cstring = (char*)"g11/temperature";
        snprintf((char*)payload, 100, "%s%d", "Mota1 #", ciclo);
        int payloadlen = strlen((const char*)payload);

        len += MQTTSerialize_publish(buf + len, buflen - len, 0, 0, 0, 0, topicString, payload, payloadlen); /* 2 */

        ////////////////////////////////////////////////
        // 3.2. send data
        ////////////////////////////////////////////////
        error = WIFI_PRO.send(socket_handle, buf, len);

        // check response
        if (error == 0) {
            USB.println(F("3.2. Send data OK"));
            USB.println(F("Wait 5 seconds...\n"));
            delay(5000);
        } else {
            USB.println(F("3.2. Error calling 'send' function"));
            WIFI_PRO.printErrorCode();
            socketOpen = false;
        }

        socketWasOpen = socketOpen;
    }

    if (!socketOpen) {
        ////////////////////////////////////////////////
        // 3.4. close socket
        ////////////////////////////////////////////////
        error = WIFI_PRO.closeSocket(socket_handle);

        // check response
        if (error == 0) {
            USB.println(F("3.3. Close socket OK"));
        } else {
            USB.println(F("3.3. Error calling 'closeSocket' function"));
            WIFI_PRO.printErrorCode();
        }

        //////////////////////////////////////////////////
        // 4. Switch OFF
        //////////////////////////////////////////////////
        USB.println(F("WiFi switched OFF\n\n"));
        WIFI_PRO.OFF(socket);

        USB.println(F("Wait 1 seconds...\n"));
        delay(1000);
    }
}