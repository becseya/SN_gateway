#include <Waspmote.h>

/*
    ------ [Ut_02] Waspmote Using LEDs Example --------

    Explanation: This example shows how to use the LEDs of Waspmote

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:           3.0
    Design:            David Gascón
    Implementation:    Marcos Yarza
*/

#define INPUT_PIN DIGITAL8
#define LED_PIN   LED0

void setup()
{
    pinMode(LED_PIN, OUTPUT);
    pinMode(INPUT_PIN, INPUT);
}

void loop()
{
    // toggle
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));

    // sleep
    if (digitalRead(INPUT_PIN) == HIGH)
        delay(200);
    else
        delay(1000);
}
